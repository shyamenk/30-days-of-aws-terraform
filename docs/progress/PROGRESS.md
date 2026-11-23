# Progress

This file is the memory of where the course stands. Update it in the same PR that finishes a day. When you say "next day", the next day is the first row below that is not `done`, in day order.

**Last updated:** 2026-11-23 · **Started:** 2026-11-05 · **Target finish:** about 5 weeks after the start · **Credits expire:** 2026-12-31

## Where I am

- **Current day:** Days 0 to 10 are done (Day 9 closed after Task 3 of 7; Day 10 all five tasks, plan only; both skipped the Q&A by my choice). Day 2's five reading items are still unticked (optional).
- **Next up:** Day 11 (functions, part 1). Cut `day-11` from `main`.
- **Where code goes:** `sandbox/` through Day 13 (concept days); `infra/modules` and `infra/envs` start on Day 14, the first project day.
- **Before Day 15:** repeat the CIDR problems. **Before Day 27:** do the five YAML files.
- **Left running in AWS:** nothing. Day 10 was plan only. The Day 9 KMS key is `PendingDeletion` (about 2026-11-30), which is expected.
- **Open questions / blockers:** none. `trivy` HIGH/CRITICAL gate passes on the Day 7 sandbox; one MEDIUM (VPC flow logs) is left on purpose.

## Open items checklist

Tick these as you verify them. Anything unchecked is deliberately left open.

**Day 0 readiness (your hands-on, see the note for hints)**
- [x] Root user has MFA and is not used for daily work
- [x] Non-root identity does the work through the default profile (an IAM user, confirmed)
- [x] AWS Budget alert with an email notification at a low limit
- [x] `aws sts get-caller-identity` on the default profile shows the right account (you confirmed the account; the non-root part is the line above)
- [x] `terraform version` prints 1.17.1 inside this repo (confirmed by you in your own terminal)
- [x] Explain VPC, subnet, internet gateway, route table, and what makes a subnet public
- [x] CIDR: subnets in a `10.0.0.0/16` split into `/24`, and usable addresses in one AWS `/24`
- [x] Describe blue-green, canary and rolling deployments with one risk each
- [x] Write down the prerequisites you are weak on and when you will fix them

**Deliberately open, to fix later**
- [x] CIDR practice: five hand problems done 2026-11-06 (first pass for Day 3). Repeat before Day 15 (see the Day 0 note, section 7)
- [ ] YAML practice: five hand-written files checked with a parser, before Day 27
- [ ] Day 21 doc links: the row says "confirm services from the video". Fill in the real services after you watch it.
- [ ] Cost estimates in `SYLLABUS.md` are my estimates from the services involved. Replace each with the actual cost after you run that day.

- [x] Account is shared with older resources. Decision (owner, 2026-11-05): they are backed up and loss is acceptable, so no separate account is needed. The `tf30-` prefix and `Project` tag stay as a naming convention.

**Verified**
- [x] Terraform per directory: a fresh interactive zsh printed 1.17.1 inside this repo and 1.15.9 (system) in `~`, as intended
- [x] Branch protection on `main`: a direct push was rejected with "Changes must be made through a pull request" and "2 of 2 required status checks are expected" (2026-11-05)
- [x] `aws --version` works (aws-cli 2.37.9)
- [x] CI green on `main`

## Status by day

Status values: `todo`, `watched`, `built`, `done` (built, note written, destroyed, PR merged). Details for each day are in [SYLLABUS.md](../SYLLABUS.md).

| Day | Status | Date done | PR | Note |
|---|---|---|---|---|
| 0 | done | 2026-11-05 | #4 | [day-00](../../notes/week-01/day-00-course-intro.md) |
| 1 | done | 2026-11-06 | #7 | [day-01](../../notes/week-01/day-01-how-terraform-works.md) |
| 2 | done | 2026-11-06 | #9 | [day-02](../../notes/week-01/day-02-aws-provider.md) |
| 3 | done | 2026-11-07 | #14 | [day-03](../../notes/week-01/day-03-s3-bucket.md) |
| 4 | done | 2026-11-07 | #16 | [day-04](../../notes/week-01/day-04-state-remote-backend.md) |
| 5 | done | 2026-11-07 | #17 | [day-05](../../notes/week-01/day-05-variables.md) |
| 6 | done | 2026-11-08 | #18 | [day-06](../../notes/week-01/day-06-project-structure.md) |
| 7 | done | 2026-11-10 | #21 | [day-07](../../notes/week-02/day-07-type-constraints.md) |
| 8 | done | 2026-11-20 | #24 | [day-08](../../notes/week-02/day-08-meta-arguments.md) |
| 9 | done | 2026-11-23 | #26 | [day-09](../../notes/week-02/day-09-lifecycle-rules.md) |
| 10 | done | 2026-11-23 | | [day-10](../../notes/week-02/day-10-conditionals-splat-dynamic.md) |
| 11 | todo | | | |
| 12 | todo | | | |
| 13 | todo | | | |
| 14 | todo | | | |
| 15 | todo | | | |
| 16 | todo | | | |
| 17 | todo | | | |
| 18 | todo | | | |
| 19 | todo | | | |
| 20 | todo | | | |
| 21 | todo | | | |
| 22 | todo | | | |
| 23 | todo | | | |
| 24 | todo | | | |
| 25 | todo | | | |
| 26 | todo | | | |
| 27 | todo | | | |
| 28 | todo | | | |
| 29 | todo | | | |
| 30 | todo | | | |

## Session log

One line per session: date, days touched, what to remember tomorrow. This list keeps the current week only; older weeks are in [LOG.md](LOG.md).

- 2026-11-16 (Day 7 follow-up): Closed the question I owed from Task 7. My answer: defaults are evaluated before the dependency graph is built. Exact rule: variables are the starting inputs, so a default must be a constant and cannot reference another variable; build such values in `locals`. The wording is mostly mine, tightened by Claude, so restate it before any post. Nothing applied, nothing running in AWS.
- 2026-11-16 (Day 8 started): Branch `day-08` cut from `main`. Note written to `notes/week-02/day-08-meta-arguments.md` from the transcript, my lifecycle key notes and the instructor README, `task.md` and `code/`. Section 7 lists traps found (the video says `for_each = 2` and `length()` work, which they do not; `task.md` Task 3 needs `for` expressions the video skips). Week 2 version check: Terraform 1.17.2, TFLint 0.66.0 and AWS provider 6.73.0 are newer; pins unchanged. Hands-on and Q&A not started. Nothing applied, nothing committed, nothing running in AWS.
- 2026-11-16 (Day 8 hands-on, tasks 1 to 3): `sandbox/day-08-meta-arguments/` has a `count` bucket block (list), a `for_each` bucket block (set) and `bucket_names` / `bucket_ids` outputs built with `for` expressions. My first Task 1 used `for_each`, left a stale `day07` local, reused the same names in both variables and pointed the outputs at a renamed block; Claude fixed all of it at my request. `trivy` first failed with 20 HIGH findings; Claude added one KMS key plus a public access block and encryption configuration per bucket block. `fmt`, `validate`, `tflint` and the `trivy` HIGH/CRITICAL gate pass; plan `13 to add`. Paused by me; the `depends_on` bucket, the removal test and the Q&A are tomorrow, so Day 8 stays `watched`. Nothing applied, nothing running in AWS.
- 2026-11-20 (Day 8 finished, plan only): Added the `depends_on` bucket (`depends_buckets` waits for `count_buckets`) with its own public access block and KMS encryption; gate passes and plan is `16 to add`. Read the order with `terraform graph`, since a plan does not show order. The removal test was reasoned, not run (empty state only shows adds); expected `3 to add, 9 to destroy` once applied. Q&A: three right, two wrong (Q3 `depends_on` versus references, Q4 graph blocks versus plan instances). Added a `count` versus `for_each` warning to the note and moved repo tips to `docs/TIPS.md` with industry practices. Nothing applied, nothing running in AWS.
- 2026-11-20 (Day 8 done): PR #24 squash-merged (`2a64c53`) after `terraform-checks` and `security-scan` went green; branch `day-08` kept. Nothing applied, nothing running in AWS. Next: Day 9.
- 2026-11-23 (repo tidy-up, on `day-09`): Moved `docs/TIPS.md` to the repo root and added `CHEATSHEET.md` there. Moved the Day 7 note to `notes/week-02/` to match the syllabus weeks. Archived the Week 1 session log to `docs/progress/LOG.md`. Added a folder table to `sandbox/README.md`, set Day 14 as the start of `infra/`, grouped `CHANGELOG.md` by week, added a "restate before posting" list to `LINKEDIN-IDEAS.md`, and moved the Day 8 lifecycle preview into a Day 9 note skeleton. Nothing applied, nothing running in AWS.
- 2026-11-23 (Day 9 note): Note written to `notes/week-02/day-09-lifecycle-rules.md` from the transcript, the instructor README, `task.md` and `code/`, and the lifecycle docs. Section 7 lists traps checked against the docs (`replace_triggered_by` with `.id`, `create_before_destroy` with fixed names, removing `prevent_destroy`, a postcondition on `var.tags`, the deprecated `aws_region` `name`). The challenge uses free resources instead of EC2 and an ASG, and is meant to be applied and destroyed. Hands-on and Q&A not started. Nothing applied, nothing running in AWS.
- 2026-11-23 (Day 9 note, docs and key notes): Checked the note against the lifecycle docs page: added `destroy` and `action_trigger` (on the page, not in the video), narrowed the "literal values" rule to the three graph settings, and added the docs details on `ignore_changes` map keys, conditions and state. Merged my key notes (revision table, five concepts, production scenario) with a review: two claims needed a qualifier, and the scenario gained an RDS `deletion_protection` note. Nothing applied, nothing running in AWS.
- 2026-11-23 (Day 9 hands-on, closed): Tasks 1 to 3 applied and destroyed. Task 1: `prevent_destroy` rejected `plan -destroy` (whole plan); removing the line allowed the destroy with no apply. Task 2: a fixed security group `name` with `create_before_destroy` failed with `InvalidGroup.Duplicate`. Task 3: `name_prefix` replaced cleanly after a `~` in the description failed AWS validation (the old group survived). My mistakes: copied all of Day 8 first; four tries keeping `name` while changing only its value; a `~` in a description. Claude renamed strings and removed unused variables at my request. Recall: two right, one wrong then restated, one half right. Day closed after Task 3 by my choice; Tasks 4 to 7 and the Q&A skipped. TIPS and CHEATSHEET updated. Nothing running in AWS except the KMS key in `PendingDeletion`.
- 2026-11-23 (Day 9 done): PR #26 squash-merged (`28513f7`) after `terraform-checks` and `security-scan` went green; branch `day-09` kept. Nothing running in AWS except the Day 9 KMS key in `PendingDeletion`. Next: Day 10.
- 2026-11-23 (Day 10 note): Branch `day-10` cut from `main`. Note written to `notes/week-02/day-10-conditionals-splat-dynamic.md` from the transcript, the instructor readme, `task.md` and `code/`, and the conditionals, splat, dynamic blocks and `aws_security_group` docs. Section 7 lists traps (`protocol = "HTTP"`, `locals.` versus `local.`, inline rules the provider now advises against, Amazon Linux 2 past end of support, a live EC2 example). The challenge uses free resources only. Hands-on and Q&A not started. Nothing applied, nothing running in AWS.
- 2026-11-23 (Day 10 hands-on, closed): all five tasks, plan and console only. Task 1: only an exact `prod` gets `10.0.0.0/16` (my first draft tested `== "dev"`, so typos got prod). Task 2: `count = var.create_sg ? 1 : 0` with a `one([*])` output. Task 3: a dynamic `ingress` block with `iterator = rule`; a third rule appeared with no code change. Task 4: a splat on `for_each` subnets passed `validate` and failed `plan`; fixed with a `for` expression. Task 5: console checks; my first run was in the repo root. Claude wrote or fixed Tasks 2 to 4, the descriptions and the last console lines at my request. Recall: three right, one half right. Q&A skipped. TIPS and CHEATSHEET updated. Nothing applied, nothing running in AWS.
