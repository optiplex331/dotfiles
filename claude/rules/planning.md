# Planning Rules

Planning owns workflow routing, durable execution documents, task closure, and
verification order.

## Mode Router

Use `quick-fix` only when all are true:

- The main agent can close the work in one bounded round.
- No durable spec, plan, task, or task-board state is needed.
- No delegated task ownership or planned parallel write scope is needed.

Use `spec-driven-full` when any are true:

- The work needs durable decisions, task state, or resumability.
- The work needs delegated task ownership or planned parallel write scopes.
- The scope spans multiple reviewable units, public behavior, or cross-module
  coordination.

Use `superteam` only for brand-new, large, long-running work that is better
served by planner/reviewer/implementer automation than normal interactive
review. Do not switch existing quick-fix or spec-driven work into `superteam`.

## Quick Fix

Route:

`think/hunt -> build -> check -> docs update`

Rules:

- Write a lightweight plan summary before coding.
- Keep task ownership, final diff, verification, and docs update in the main
  thread.
- Delegated quick-fix submissions are candidates only; the main thread must
  absorb and verify them in the same workflow round.
- Re-route to `spec-driven-full` as soon as durable state, delegated task
  ownership, or planned parallel write scopes are needed.
- Close with verification results and a concise diff summary.

## Spec Driven Full

Route:

`spec -> plan -> task -> code -> unit -> integration -> e2e`

Gates:

- Spec must be approved before planning starts.
- Plan must be approved before task generation.
- Task must be approved before coding starts.
- Coding must stay inside the approved task boundary.

## Spec

Spec owns the problem definition and acceptance criteria.

Required fields:

- Background
- Goal
- Audience
- User scenarios
- Scope
- Non-goals
- Constraints
- Edge cases
- Acceptance criteria
- Open questions

Rules:

- Spec does not generate tasks.
- Acceptance criteria must be judgeable.

## Plan

Plan owns execution topology.

Required content:

- Approved spec reference.
- Implementation strategy.
- Workstreams, dependency order, serial chains, and parallel task groups.
- Risks.
- Test strategy.
- Task breakdown rules.

Rules:

- Tasks must structurally belong to the plan that owns them.
- Tasks should be small enough for independent review and rollback.
- Tasks in the same parallel group must have disjoint write scopes.
- When multiple agents will write code, define each task's branch or worktree
  strategy before implementation starts.

## Task

Task owns one executable unit.

Required fields:

- Status
- References
- Dependencies
- Inputs
- Objective
- In scope
- Out of scope
- Checklist
- Acceptance criteria
- Test requirements
- Documentation updates
- Return contract
- Notes / risks

Rules:

- One task, one clear objective.
- One task, one reviewable unit.
- One task, one commit when feasible.
- A task must be independently testable, revertible, and cold-startable.
- `Inputs` must list the context needed to start cold, including file paths and
  dependency outputs.
- `Return contract` must define the expected result format, such as diff,
  changed files, verification result, risks, and bounded summary.

## Task Closure

Before marking a formal task `done`:

- Reconcile every checklist item as complete, `N/A` with a reason, or moved to a
  documented follow-up.
- Confirm acceptance criteria and test requirements are satisfied, or keep the
  task `blocked` / `partial` and record the blocker.
- Update task status with completion date and verification result.
- Update the owning plan with completion state, output links, verification
  result, unlocked next tasks, and changed risks.
- Update the owning spec when open questions, acceptance criteria, scope, or
  constraints were resolved or changed.

Rules:

- A task marked `done` must not contain unreconciled checklist items.
- A plan with formal tasks must maintain a `Progress` section or equivalent
  task table that covers every task in the plan.
- Spec `Open questions` must preserve the original question text and add status
  metadata in place: `[RESOLVED <date>]`, `[DEFERRED <date>]`, or a newly added
  question.
- A formal task is not closed until its task document, owning plan, and affected
  spec questions agree.

## Verification

- Testable code tasks default to TDD.
- Test requirements must be written in the task before coding starts.
- If test-first is not appropriate, write the verification approach before
  coding starts.
- Verification order is fixed: `unit -> integration -> e2e`.
- If a bug is found during verification, reproduce it with a failing test first,
  then fix it with TDD.
- Scale tests with risk and blast radius.
- If a task changes public contracts, pair tests with `SURFACE.md` updates when
  that registry is enabled.
