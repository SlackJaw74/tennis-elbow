# Claude Code Instructions — Tennis Elbow Treatment App

## Project Overview

iOS health app built with SwiftUI to help users manage tennis elbow (lateral epicondylitis) recovery. MVVM architecture, Swift 5.7+, iOS 16.0+.

```
TennisElbow/
├── Models/           # Data models (TreatmentActivity, ScheduledActivity, TreatmentPlan)
├── ViewModels/       # Business logic (TreatmentManager)
├── Views/            # SwiftUI views
├── TennisElbowTests/ # Unit + integration tests (XCTest)
└── TennisElbowUITests/ # UI/E2E tests
```

## Essential Commands

```bash
# Build
make sim-run                        # Run on iPhone simulator (default: iPhone 16e)
make sim-run DEVICE="iPhone 15 Pro" # Run on specific device

# Test
make test                           # All tests
make test-unit                      # Unit tests only
make test-ui                        # UI tests only

# Lint & Format (run before every commit)
cd TennisElbow && swiftlint lint
cd TennisElbow && swiftformat --lint .
cd TennisElbow && swiftformat .     # Auto-fix formatting
```

## Coding Standards

### Testing — Test Pyramid (100% coverage required)

All code must have 100% test coverage. Follow the test pyramid:

- **Unit tests (most)** — Test Models and ViewModels in isolation. One test per behaviour. Fast, no I/O.
- **Integration tests (middle)** — Test interactions between components (e.g., TreatmentManager + model layer).
- **UI tests (fewest)** — Only for critical user flows. Use snapshot tests for SwiftUI views.

When writing new code, write tests first (TDD). Do not add code that lacks a corresponding test.

### Conventional Commits

All commit messages must follow the Conventional Commits specification:

```
<type>[optional scope]: <description>

Types: feat | fix | docs | style | refactor | test | chore | perf
```

Examples:
- `feat(schedule): add weekly view for scheduled activities`
- `fix(notifications): handle denied permission state gracefully`
- `test(treatment-manager): add coverage for edge case in getPainTrend`
- `refactor(views): extract shared pain level picker into component`

### DRY (Don't Repeat Yourself)

- Extract repeated logic into shared functions or computed properties.
- Reuse SwiftUI components via `SharedComponents.swift` — add shared UI there before duplicating view code.
- Prefer protocol extensions and generics over copy-pasted logic.

### Simplicity

- Write the simplest solution that satisfies the requirements. No speculative abstractions.
- Prefer readable code over clever code. A clear `if/else` beats a complex one-liner.
- Keep functions small and single-purpose. If a function needs a comment to explain what it does, consider splitting it.
- Delete dead code — don't comment it out.

### Code Quality Tools (Required)

SwiftLint and SwiftFormat are mandatory on every change — no exceptions.

- **SwiftLint** enforces style and safety rules. Zero warnings/errors required.
- **SwiftFormat** enforces consistent formatting. All code must be formatted before committing.

### Swift Style

- **No force unwrapping** (`!`) — use `if let`, `guard let`, or optional chaining.
- Indentation: 4 spaces. Max line length: 120 chars (150 absolute).
- File length: under 500 lines. Function length: under 50 lines.
- Use `@StateObject` for ViewModel init, `@ObservedObject` for passed-in VMs.
- Use `.isEmpty` instead of `== ""`.
- Prefer `first(where:)` over `filter().first`.

## Documentation

All `.md` files (except `README.md` and `CLAUDE.md`) go in the `docs/` folder.

## Pre-commit Checklist

Before committing:
1. `swiftlint lint` — zero warnings/errors
2. `swiftformat --lint .` — clean formatting
3. `make test` — all tests pass, 100% coverage maintained
4. Commit message follows Conventional Commits format
