# AGENTS.md

## Project Overview

EasyGitOps (binary: `ego`) is an opinionated CI+CD pattern for building and deploying services. Written in Go.

## Stack

- **Language**: Go 1.26.2
- **Build**: `make` (see Makefile for targets: `build`, `run`, `clean`, `test`, `lint`, `tidy`)
- **Versioning**: semantic-release (conventional commits)
- **Binary Distribution**: GoReleaser v2

## Versioning and Release Pipeline

This project uses a **hybrid semantic-release + GoReleaser** setup:

### Roles

| Tool | Responsibility |
|------|---------------|
| **semantic-release** | Reads conventional commits, calculates next version, creates git tag, generates changelog, creates GitHub Release draft |
| **GoReleaser** | Builds cross-platform binaries (linux/amd64, linux/arm64, windows/amd64) and uploads them to the GitHub Release created by semantic-release |

### Why Both?

GoReleaser does not calculate versions or read commit messages. It reads the current git tag and builds binaries for it. semantic-release handles the version calculation and tagging but doesn't build Go binaries. Together they cover the full release lifecycle.

### Release Flow

1. Developer pushes conventional commits (`feat:`, `fix:`, `BREAKING CHANGE:`) to a branch
2. On push to `main`, the CI workflow runs tests
3. semantic-release analyzes commits, determines next version, creates a tag (e.g., `v1.2.0`), generates changelog, and creates a GitHub Release
4. GoReleaser runs after semantic-release succeeds, reads the newly created tag, compiles binaries for all targets, and uploads them as assets to the GitHub Release

### Branching Strategy

Defined in `.releaserc.json`:
- `main` branch → full releases (`v1.0.0`, `v1.1.0`, etc.)
- All other branches → prereleases (`v1.0.0-beta.1`, tagged as prerelease on GitHub)

GoReleaser's `release.prerelease: auto` in `.goreleaser.yaml` automatically marks any tag containing `-` (e.g., `v1.0.0-beta.1`) as a GitHub prerelease.

### Conventional Commits

Follow the Angular conventional commit format:
- `feat: ...` → minor version bump
- `fix: ...` → patch version bump
- `BREAKING CHANGE:` in body or `feat!:` / `fix!:` → major version bump

## Directory Structure

```
cmd/ego/main.go       - CLI entry point
Makefile              - Build targets
go.mod                - Go module definition (pins Go 1.26.2)
.releaserc.json       - semantic-release config (branch rules, plugins)
.goreleaser.yaml      - GoReleaser config (build targets, archives, release settings)
.github/workflows/    - CI/CD pipeline
```

## Building Locally

```bash
make build    # compiles to ./ego
make run      # builds and runs
make test     # runs tests
make clean    # removes binary
```
