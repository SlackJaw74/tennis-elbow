#!/bin/bash

# version_bump.sh
# Script to automatically increment app version numbers
# Usage: ./scripts/version_bump.sh [major|minor|patch|build]

set -e

PROJECT_FILE="TennisElbow/TennisElbow.xcodeproj/project.pbxproj"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to show usage
show_usage() {
    echo "Usage: $0 [major|minor|patch|build]"
    echo ""
    echo "Bump types:"
    echo "  major  - Increment major version (1.0.0 -> 2.0.0), reset minor and patch to 0"
    echo "  minor  - Increment minor version (1.0.0 -> 1.1.0), reset patch to 0"
    echo "  patch  - Increment patch version (1.0.0 -> 1.0.1)"
    echo "  build  - Increment build number only (CURRENT_PROJECT_VERSION)"
    echo ""
    echo "Examples:"
    echo "  $0 patch  # 1.0.0 -> 1.0.1"
    echo "  $0 minor  # 1.0.0 -> 1.1.0"
    echo "  $0 major  # 1.0.0 -> 2.0.0"
    echo "  $0 build  # Just increment build number"
}

# Function to get current version from project file
get_current_version() {
    cd "${PROJECT_ROOT}"
    
    if [ ! -f "${PROJECT_FILE}" ]; then
        echo -e "${RED}Error: Project file not found: ${PROJECT_FILE}${NC}" >&2
        exit 1
    fi
    
    local version=$(grep -m 1 "MARKETING_VERSION = " "${PROJECT_FILE}" | sed 's/.*MARKETING_VERSION = \(.*\);/\1/')
    
    if [ -z "${version}" ]; then
        echo -e "${RED}Error: MARKETING_VERSION not found in ${PROJECT_FILE}${NC}" >&2
        exit 1
    fi
    
    # Validate version format (should be digits and dots only)
    if ! [[ "${version}" =~ ^[0-9]+(\.[0-9]+)*$ ]]; then
        echo -e "${RED}Error: Invalid version format in project file: ${version}${NC}" >&2
        exit 1
    fi
    
    echo "${version}"
}

# Function to get current build number from project file
get_current_build() {
    cd "${PROJECT_ROOT}"
    
    if [ ! -f "${PROJECT_FILE}" ]; then
        echo -e "${RED}Error: Project file not found: ${PROJECT_FILE}${NC}" >&2
        exit 1
    fi
    
    local build=$(grep -m 1 "CURRENT_PROJECT_VERSION = " "${PROJECT_FILE}" | sed 's/.*CURRENT_PROJECT_VERSION = \(.*\);/\1/')
    
    if [ -z "${build}" ]; then
        echo -e "${RED}Error: CURRENT_PROJECT_VERSION not found in ${PROJECT_FILE}${NC}" >&2
        exit 1
    fi
    
    # Validate build number format (should be digits only)
    if ! [[ "${build}" =~ ^[0-9]+$ ]]; then
        echo -e "${RED}Error: Invalid build number format in project file: ${build}${NC}" >&2
        exit 1
    fi
    
    echo "${build}"
}

# Function to set version in project file
set_version() {
    local new_version=$1
    cd "${PROJECT_ROOT}"
    
    # Validate version format before setting (allow X.Y or X.Y.Z format)
    if ! [[ "${new_version}" =~ ^[0-9]+(\.[0-9]+){1,2}$ ]]; then
        echo -e "${RED}Error: Invalid version format for setting: ${new_version}${NC}" >&2
        exit 1
    fi
    
    # Use sed to replace all occurrences of MARKETING_VERSION
    if [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS
        sed -i '' "s/MARKETING_VERSION = .*;/MARKETING_VERSION = ${new_version};/" "${PROJECT_FILE}"
    else
        # Linux
        sed -i "s/MARKETING_VERSION = .*;/MARKETING_VERSION = ${new_version};/" "${PROJECT_FILE}"
    fi
}

# Function to set build number in project file
set_build() {
    local new_build=$1
    cd "${PROJECT_ROOT}"
    
    # Validate build number format before setting
    if ! [[ "${new_build}" =~ ^[0-9]+$ ]]; then
        echo -e "${RED}Error: Invalid build number format for setting: ${new_build}${NC}" >&2
        exit 1
    fi
    
    # Use sed to replace all occurrences of CURRENT_PROJECT_VERSION
    if [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS
        sed -i '' "s/CURRENT_PROJECT_VERSION = .*;/CURRENT_PROJECT_VERSION = ${new_build};/" "${PROJECT_FILE}"
    else
        # Linux
        sed -i "s/CURRENT_PROJECT_VERSION = .*;/CURRENT_PROJECT_VERSION = ${new_build};/" "${PROJECT_FILE}"
    fi
}

# Function to increment version based on type
increment_version() {
    local version=$1
    local bump_type=$2
    
    # Parse version components
    IFS='.' read -r major minor patch <<< "${version}"
    
    # Default components to 0 if not present
    major=${major:-0}
    minor=${minor:-0}
    patch=${patch:-0}
    
    # Validate that components are numeric
    if ! [[ "${major}" =~ ^[0-9]+$ ]] || ! [[ "${minor}" =~ ^[0-9]+$ ]] || ! [[ "${patch}" =~ ^[0-9]+$ ]]; then
        echo -e "${RED}Error: Invalid version format: ${version}${NC}" >&2
        return 1
    fi
    
    case "${bump_type}" in
        major)
            major=$((major + 1))
            minor=0
            patch=0
            ;;
        minor)
            minor=$((minor + 1))
            patch=0
            ;;
        patch)
            patch=$((patch + 1))
            ;;
        *)
            echo -e "${RED}Error: Invalid bump type: ${bump_type}${NC}" >&2
            return 1
            ;;
    esac
    
    echo "${major}.${minor}.${patch}"
}

# Main script logic
main() {
    if [ $# -eq 0 ]; then
        show_usage
        exit 1
    fi
    
    BUMP_TYPE=$1
    
    # Validate bump type
    if [[ ! "${BUMP_TYPE}" =~ ^(major|minor|patch|build)$ ]]; then
        echo -e "${RED}Error: Invalid bump type '${BUMP_TYPE}'${NC}"
        show_usage
        exit 1
    fi
    
    # Get current versions
    CURRENT_VERSION=$(get_current_version)
    CURRENT_BUILD=$(get_current_build)
    
    # Validate build number is numeric
    if ! [[ "${CURRENT_BUILD}" =~ ^[0-9]+$ ]]; then
        echo -e "${RED}Error: Invalid build number: ${CURRENT_BUILD}${NC}" >&2
        exit 1
    fi
    
    echo -e "${YELLOW}Current version: ${CURRENT_VERSION}${NC}"
    echo -e "${YELLOW}Current build: ${CURRENT_BUILD}${NC}"
    echo ""
    
    # Calculate new versions
    if [ "${BUMP_TYPE}" = "build" ]; then
        NEW_BUILD=$((CURRENT_BUILD + 1))
        NEW_VERSION="${CURRENT_VERSION}"
    else
        NEW_VERSION=$(increment_version "${CURRENT_VERSION}" "${BUMP_TYPE}") || {
            echo -e "${RED}Error: Failed to increment version${NC}" >&2
            exit 1
        }
        # Additional validation that we got a valid version
        if [ -z "${NEW_VERSION}" ] || ! [[ "${NEW_VERSION}" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
            echo -e "${RED}Error: Invalid version generated: ${NEW_VERSION}${NC}" >&2
            exit 1
        fi
        NEW_BUILD=$((CURRENT_BUILD + 1))
    fi
    
    echo -e "${GREEN}New version: ${NEW_VERSION}${NC}"
    echo -e "${GREEN}New build: ${NEW_BUILD}${NC}"
    echo ""
    
    # Update project file
    set_version "${NEW_VERSION}"
    set_build "${NEW_BUILD}"
    
    echo -e "${GREEN}✓ Version updated successfully!${NC}"
    echo ""
    echo "Updated files:"
    echo "  - ${PROJECT_FILE}"
    echo ""
    echo "Next steps:"
    echo "  1. Review the changes: git diff ${PROJECT_FILE}"
    echo "  2. Commit the changes: git add ${PROJECT_FILE} && git commit -m 'Bump version to ${NEW_VERSION} (${NEW_BUILD})'"
    echo "  3. Tag the release: git tag -a v${NEW_VERSION} -m 'Release version ${NEW_VERSION}'"
}

# Run main function
main "$@"
