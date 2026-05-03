# Dotfiles Repository Guidelines

> Operational rules for this macOS dotfiles repository.

## Overview

This repository manages personal macOS developer configuration. Runtime files are
installed into `$HOME` with `scripts/restore.sh`.

## Pre-Development Checklist

- Read root `CLAUDE.md` for the current symlink map and operational commands.
- Inspect `scripts/restore.sh` before changing any installed config path.
- For agent-system changes, also read `.trellis/spec/agent/index.md`.
- Check `git status --short` before editing.

## Quality Check

- `bash -n scripts/restore.sh` passes after restore-script edits.
- Symlink map in root `CLAUDE.md` matches `scripts/restore.sh`.
- Agent-system migrations update both restore cleanup and docs: enumerate
  obsolete per-file symlinks in `scripts/restore.sh`, and make sure README/docs
  no longer present removed rule or agent directories as active structure.
- Machine-specific paths, local secrets, and transient runtime files are not
  added unless intentionally part of the task.
- Do not run `scripts/restore.sh` against live `$HOME` unless the user asks.
