#!/usr/bin/env python3
"""
PR CI Fix Agent

Monitors a PR's CI checks and automatically fixes failures until all checks pass.

Usage:
    python pr_agent.py           # auto-detects PR from current branch
    python pr_agent.py --pr 42   # target a specific PR number

Requirements:
    pip install claude-agent-sdk
    gh CLI authenticated: gh auth login
"""

import anyio
import argparse
import os
import subprocess
import sys
from claude_agent_sdk import query, ClaudeAgentOptions, ResultMessage, SystemMessage

CWD = os.path.dirname(os.path.abspath(__file__))

SYSTEM_PROMPT = """You are a CI fix agent for an iOS SwiftUI project (the Tennis Elbow app).

## Goal
Monitor a GitHub PR's CI checks and fix all failures until every check passes.

## Workflow
1. Run `gh pr checks <pr>` to see current check status
2. If any check is pending/running, wait 30s and check again
3. For each failing check, get the details to understand the root cause
4. Fix the issue in the code
5. Commit (Conventional Commits format) and push
6. Wait ~90 seconds, then check CI again
7. Repeat until all checks pass

## Getting Failure Details

**SwiftFormat failures:**
Run `cd TennisElbow && swiftformat .` — it auto-fixes formatting.
Then `git diff` to review what changed before committing.

**SwiftLint failures:**
Run `cd TennisElbow && swiftlint lint` to see specific violations with file/line info.

**Build or test failures:**
Run `gh run list --branch <branch> --limit 3` to find the latest run ID, then:
`gh run view <run-id> --log-failed` to read the full error output.

## Common Fix Patterns

### SwiftFormat
The most frequent issue: view modifiers (`.cornerRadius`, `.opacity`, `.frame`) are
indented 4 extra spaces after a multiline closing `))`. They should align with the
opening expression, not with the ternary continuation.

Auto-fix with: `cd TennisElbow && swiftformat .`

### SwiftLint
Common violations:
- Force unwrapping `!` → use `guard let` / `if let` / optional chaining
- Line too long → break into multiple lines (max 120 chars, 150 absolute)
- `== ""` → use `.isEmpty`
- `filter().first` → use `first(where:)`

### Tests
Read the specific failure message from `gh run view --log-failed` to understand
what assertion failed, then fix the code or test.

## Commit Rules
- Format: `<type>: <description>` (Conventional Commits)
  - `style: fix SwiftFormat violations`
  - `fix: resolve SwiftLint force-unwrap warning in FooView`
  - `test: fix failing assertion in TreatmentManagerTests`
- Stage only changed Swift files — never stage `.claude/` or other untracked dirs
- Never use `--no-verify`
- Co-author line: `Co-Authored-By: Claude Opus 4.6 <noreply@anthropic.com>`

## After Pushing
Wait ~90 seconds for GitHub Actions to pick up the push before checking `gh pr checks` again.
CI jobs (SwiftFormat, SwiftLint, build, tests) run in parallel — all must be green.
"""


async def run_agent(pr_number: str) -> None:
    prompt = f"""
Fix all failing CI checks on PR #{pr_number}.

Steps:
1. Run `gh pr checks {pr_number}` to see what's failing
2. If checks are still running, wait 30 seconds and check again
3. For each failure, investigate and fix the root cause
4. Commit and push the fix
5. Wait ~90 seconds, then re-check until everything is green

Start now.
"""

    print(f"🤖 PR CI Fix Agent — PR #{pr_number}")
    print(f"   Working directory: {CWD}")
    print()

    async for message in query(
        prompt=prompt,
        options=ClaudeAgentOptions(
            cwd=CWD,
            allowed_tools=["Bash", "Read", "Edit", "Write", "Glob", "Grep"],
            permission_mode="bypassPermissions",
            system_prompt=SYSTEM_PROMPT,
            max_turns=100,
        ),
    ):
        if isinstance(message, ResultMessage):
            print()
            print("=" * 60)
            print(f"✅  Agent finished")
            print(f"    {message.result}")
            print(f"    Stop reason: {message.stop_reason}")
            return
        elif isinstance(message, SystemMessage) and message.subtype == "init":
            session_id = message.data.get("session_id", "unknown")
            print(f"   Session ID: {session_id}")
            print()


def detect_pr_number() -> str | None:
    """Detect the PR number for the current git branch via gh CLI."""
    try:
        result = subprocess.run(
            ["gh", "pr", "view", "--json", "number", "-q", ".number"],
            capture_output=True,
            text=True,
            check=True,
            cwd=CWD,
        )
        return result.stdout.strip()
    except subprocess.CalledProcessError:
        return None
    except FileNotFoundError:
        print("❌  gh CLI not found. Install it from https://cli.github.com/")
        sys.exit(1)


def main() -> None:
    parser = argparse.ArgumentParser(
        description="Automatically fix CI failures on a GitHub PR",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog=__doc__,
    )
    parser.add_argument(
        "--pr",
        metavar="NUMBER",
        help="PR number (auto-detected from current branch if omitted)",
    )
    args = parser.parse_args()

    pr_number = args.pr
    if not pr_number:
        pr_number = detect_pr_number()
        if not pr_number:
            print("❌  Could not find a PR for the current branch.")
            print("    Make sure there's an open PR, or pass --pr <number>")
            sys.exit(1)
        print(f"📌  Detected PR #{pr_number} for current branch")

    try:
        import claude_agent_sdk  # noqa: F401
    except ImportError:
        print("❌  claude-agent-sdk not installed.")
        print("    Run: pip install claude-agent-sdk")
        sys.exit(1)

    anyio.run(run_agent, pr_number)


if __name__ == "__main__":
    main()
