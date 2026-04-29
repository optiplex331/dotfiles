# Testing Rules

## Core Rules

- Testable code tasks default to TDD.
- Test requirements must be written in the task before coding starts.
- If test-first is not appropriate, write the verification approach before
  coding starts.
- Verification order is fixed: `unit -> integration -> e2e`.
- If a bug is found during verification, reproduce it with a failing test first,
  then fix it with TDD.

## Scope

Scale tests with risk and blast radius:

- Narrow changes should get focused tests.
- Shared behavior, cross-module contracts, or user-facing workflows need broader
  coverage.
- If a task changes public contracts, pair tests with `SURFACE.md` updates when
  that registry is enabled.
