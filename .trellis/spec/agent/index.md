# Agent System Guidelines

> Source of truth for global Claude/Codex agent behavior installed by this
> dotfiles repository.

## Overview

This package owns durable rules for agentic coding tools. Keep entry files short
and put reusable behavior here so Claude, Codex, and future Trellis-compatible
platforms share one source of truth.

## Pre-Development Checklist

Read the guides that match the task:

| Guide | When To Read |
| --- | --- |
| [Global Baseline](./global-baseline.md) | Always, before changing agent entry points or workflow rules |
| [Git And Branching](./git-and-branching.md) | Before changing branch, commit, staging, or restore behavior |
| [Workflow Routing](./workflow-routing.md) | Before changing task routing, Trellis workflow, or execution gates |
| [Review And Verification](./review-and-verification.md) | Before changing review, testing, or quality gates |
| [Documentation Memory](./documentation-memory.md) | Before changing docs, handoff, or continuity rules |
| [Delegation](./delegation.md) | Before changing sub-agent or parallel-work rules |
| [English Coaching](./english-coaching.md) | Before changing passive English-coaching behavior |

## Quality Check

- Entry files remain short and point to Trellis specs instead of duplicating
  detailed rules.
- Claude and Codex behavior stays agent-neutral unless a platform genuinely
  needs a different adapter.
- Restore behavior is explicit about what gets installed and what obsolete links
  are removed.
- New durable rules are added here only when they change real agent decisions.

## Language

Use English for durable rule files.
