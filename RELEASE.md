# Release Process

This document explains how to create and publish releases for Pamuk Desktop.

## Creating a Release

### Automatic Release (Recommended)

1. **Ensure all changes are committed and pushed to main**
2. **Create and push a version tag**:
   ```bash
   git tag v1.0.0
   git push origin v1.0.0
   ```
3. **GitHub Actions will automatically**:
   - Build Windows and Linux binaries
   - Create a GitHub Release
   - Upload ZIP files for public download

### Manual Release

1. **Go to Actions tab** in GitHub
2. **Select "Build and Release" workflow**
3. **Click "Run workflow"**
4. **Enter tag version** (e.g., v1.0.1)
5. **Click "Run workflow"**

## Version Numbering

Follow semantic versioning (semver):
- `v1.0.0` - Major release
- `v1.0.1` - Patch/bugfix
- `v1.1.0` - Minor feature update

## Release Checklist

- [ ] All tests pass
- [ ] Documentation updated
- [ ] Version bumped in `pubspec.yaml`
- [ ] Changelog updated
- [ ] Tag created and pushed
- [ ] Release notes written
- [ ] Binaries tested on target platforms

## Release Artifacts

Each release includes:
- **Windows**: `pamuk-desktop-windows-x64.zip`
- **Linux**: `pamuk-desktop-linux-x64.zip`
- **Source code**: Automatic GitHub archive

## Post-Release

1. **Test downloads** from the releases page
2. **Update documentation** if needed
3. **Announce** on relevant channels
4. **Monitor** for issues and feedback

## Troubleshooting

### Build Failures
- Check GitHub Actions logs
- Verify Flutter version compatibility
- Ensure all dependencies are available

### Missing Artifacts
- Confirm workflow completed successfully
- Check artifact upload steps in logs
- Verify release creation step

## Access Levels

- **Public releases**: Anyone can download from GitHub Releases
- **Development artifacts**: Only repository contributors (from CI builds)
- **Private builds**: Local development builds
