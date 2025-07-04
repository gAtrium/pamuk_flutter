#!/bin/bash

# Pamuk Desktop Release Script
# Usage: ./create_release.sh v1.0.0

set -e

VERSION=$1

if [ -z "$VERSION" ]; then
    echo "Usage: $0 <version>"
    echo "Example: $0 v1.0.0"
    exit 1
fi

# Validate version format
if [[ ! $VERSION =~ ^v[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    echo "Error: Version must be in format vX.Y.Z (e.g., v1.0.0)"
    exit 1
fi

echo "🚀 Creating release $VERSION"

# Check if working directory is clean
if [ -n "$(git status --porcelain)" ]; then
    echo "❌ Working directory is not clean. Please commit or stash changes."
    exit 1
fi

# Ensure we're on main branch
BRANCH=$(git branch --show-current)
if [ "$BRANCH" != "main" ]; then
    echo "⚠️  Warning: You're not on the main branch (current: $BRANCH)"
    read -p "Continue anyway? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi

# Update version in pubspec.yaml
echo "📝 Updating version in pubspec.yaml..."
VERSION_NUMBER=${VERSION#v}  # Remove 'v' prefix
sed -i.bak "s/^version: .*/version: $VERSION_NUMBER+1/" pubspec.yaml
rm pubspec.yaml.bak

# Commit version bump
git add pubspec.yaml
git commit -m "Bump version to $VERSION"

# Create and push tag
echo "🏷️  Creating tag $VERSION..."
git tag -a "$VERSION" -m "Release $VERSION"

echo "📤 Pushing changes and tag..."
git push origin main
git push origin "$VERSION"

echo "✅ Release $VERSION created successfully!"
echo "🔗 Check the GitHub Actions workflow: https://github.com/$(git config --get remote.origin.url | sed 's/.*://;s/\.git$//')/actions"
echo "📦 Release will be available at: https://github.com/$(git config --get remote.origin.url | sed 's/.*://;s/\.git$//')/releases"
