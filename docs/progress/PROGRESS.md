# Progress

This file is the memory of where the course stands. Update it in the same PR that finishes a day. When you say "next day", the next day is the first row below that is not `done`, in day order.

**Last updated:** 2026-11-09 · **Started:** 2026-11-05 · **Target finish:** about 5 weeks after the start · **Credits expire:** 2026-12-31

## Where I am

- **Current day:** Days 0 to 6 are done and merged. Day 7 is in progress on branch `day-07` (local commits, not pushed). Day 2's five reading items are still unticked (optional).
- **Next up:** Day 7 Task 9 of 10 (`object` config), then Task 10 (`deployment_summary` output), the Q&A, then tick Day 7 in `SYLLABUS.md` and open the PR. Resume in `sandbox/day-07-types/`.
- **Before Day 15:** repeat the CIDR problems. **Before Day 27:** do the five YAML files.
- **Left running in AWS:** nothing. The state bucket and the Day 4 demo bucket are deleted (404 confirmed 2026-11-07); the Day 4 KMS key is `PendingDeletion` for 7 days, which is expected.
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
| 7 | watched | | | [day-07](../../notes/week-01/day-07-type-constraints.md) |
| 8 | todo | | | |
| 9 | todo | | | |
| 10 | todo | | | |
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

One line per session: date, days touched, what to remember tomorrow.

- 2026-11-05: Repo scaffolded, pushed to GitHub (public) and first CI run green. Nothing studied yet. Next: cut `day-00` and start Day 0.
- 2026-11-05: Branch protection enabled on `main`; repo is squash-merge only. Docs synced.
- 2026-11-05: Mapped every instructor lessons folder to our days in SYNC.md.
- 2026-11-05: Day 0 transcript organized into `notes/week-01/day-00-course-intro.md` on branch `day-00`. Checklist not done yet, so no PR. SYNC.md records that the announced curriculum differs from the released one.
- 2026-11-05: Pinned Terraform 1.17.1, TFLint 0.65.0 and Trivy 0.76.1 installed with mise; fmt, tflint and trivy pass locally. The earlier `aws --version` error was my tool shell, not the CLI (aws-cli 2.37.9 works).
- 2026-11-05: Tested branch protection with a direct push to `main` (rejected). Added the open items checklist above.
- 2026-11-05 (end of session): Repo, CI, branch protection and tooling are done. Day 0 note is on `day-00`; its last three items are deferred by the owner. Resume by reading this file, then finish those items and open the Day 0 PR.
- 2026-11-05: Day 0 finished. Concept Q&A covered VPC, subnets, gateways, CIDR, deployment strategies, networking, Git, shell and JSON/YAML. Weak spots: CIDR math, YAML. Day 0 PR opened.
- 2026-11-05: Day 0 "Docs to read" list changed to optional reference reading (owner decision), so no Day 0 boxes remain open.
- 2026-11-06: CIDR practice (five problems) checked and recorded on `day-00` (PR #6). Day 1 transcript organized into `notes/week-01/day-01-how-terraform-works.md` on `day-01`. Installs confirmed (Terraform 1.17.1, aws-cli 2.37.9, `tf` alias). Tab completion and the editor extension confirmed. Six concept questions answered and checked; mistake logged: I mixed up the dependency lock file with a state lock. Day 1 done. Nothing left running in AWS.
- 2026-11-06: Day 2 note written from timestamps, notes and terminal output (no spoken transcript pasted). One VPC applied and destroyed by the owner. First code was in the repo root, had no `required_version` (`tflint` exits 2) and no `tf30-` name or `Project` tag. Code then moved to `sandbox/day-02-provider/` and fixed at the owner's request (`required_version`, `tf30-` name, `Project` tag via `default_tags`); `tflint` exits 0. Plan showed the name and both tags. Console check printed `[]`, so nothing is left running in AWS.
- 2026-11-06 (later): Day 2 Q&A finished; mistakes logged (lock file versus state lock again, mixed up `required_providers` and the provider block). Day 2 done once the PR is merged.
- 2026-11-06 (end of session): Docs synced. Fixed a stale CHANGELOG line and two unticked Day 2 boxes, and re-checked versions (Trivy 0.76.2 and OpenTofu 1.13.9 are newer; pins unchanged). Days 0 to 2 are done. Next: Day 3.
- 2026-11-06 (Day 3): Note written from the transcript, the instructor's README, `task.md` and `main.tf`. The assignment is a VPC and a bucket with an implicit dependency. My first version used `depends_on` (explicit), then a `vpc_id` argument the bucket does not have; the final code, which Claude fixed at my request, puts `aws_vpc.main.id` in the bucket's `tags`. `fmt`, `validate`, `tflint` and `terraform graph` checked on a scratch copy. I have only seen a plan of the earlier version. Nothing applied yet, so nothing is running in AWS. The bare bucket failed `trivy` with five HIGH findings; Claude added a public access block, KMS key and encryption config at my request, and the HIGH/CRITICAL gate now exits 0. Day 3 stays `watched` until apply, tag change, destroy and the Q&A are done.
- 2026-11-06 (end of session): Day 3 docs synced and paused by the owner. Resume tomorrow on `day-03`: `plan` (expect 5 to add), `apply`, console check, tag change, `destroy`, Q&A. Then tick Day 3 in `SYLLABUS.md` and `PROGRESS.md`, record the real cost, and open the PR. Nothing was committed or applied.
- 2026-11-07 (Day 3 done): Plan showed 5 to add, apply created all five, a `Name` tag change applied in place (`1 changed`), and destroy removed all five. Leftover checks were empty (`[]`, bucket 404, KMS key `PendingDeletion`). Trivy first failed with five HIGH findings on the bare bucket; Claude added a public access block, KMS key and encryption config at my request. Q&A: first attempt had five mistakes; four answers are Claude's wording that I accepted, so restate them before any post. Actual cost not measured yet (Billing lags). Nothing left running in AWS.
- 2026-11-07 (Day 4): Note written from the transcript, key notes, instructor README and task, and my terminal output. I created the state bucket with the CLI, ran `init`, `plan`, `apply` and `destroy` against the S3 backend (lock released each time). Review found five issues: bucket not versioned, not `tf30-` named and untagged; no `provider` block so no `Project` tag; `fmt` fails; bare bucket would fail `trivy`; demo bucket reuses the Day 3 name. Backend bucket removed afterwards (404 confirmed) and the local `.terraform/` deleted. Then Claude fixed the code at my request (`sandbox/day-04-remote-backend/`), I created the `tf30-` state bucket with versioning, and `init`, `plan` (4 to add), `apply` and `destroy` all ran against it. Then I deleted the state bucket with all versions (404 confirmed). Only the Q&A is left. Nothing committed.
- 2026-11-07 (Day 4 done): Q&A first attempt had four mistakes; four answers are Claude's wording that I accepted, so restate them before any post. Fixed code is in `sandbox/day-04-remote-backend/` (the `main.tf` still names the deleted state bucket; recreate a `tf30-` versioned bucket before using a remote backend again). Actual cost not measured yet. Nothing left running in AWS (one KMS key `PendingDeletion` for 7 days).
- 2026-11-07 (Day 5): Note written from the transcript, my key notes, the instructor's README and `task.md`, and the Terraform docs for variable precedence. Hands-on not started; the planned challenge uses only a bucket and a VPC (no EC2, so nothing that bills). Nothing applied, nothing committed, nothing running in AWS.
- 2026-11-07 (Day 5 hands-on): `sandbox/day-05-variables/` written (provider, variables, locals, main, outputs, tfvars example) with Claude's fixes at my request. Precedence proved with four plans: default `dev`, `TF_VAR_` `stage`, tfvars `pre-prod`, `-var` `prod`. Apply and destroy skipped by my choice, so nothing is running in AWS. Q&A pending. Nothing committed.
- 2026-11-07 (Day 5 done): Q&A first attempt had two gaps; two answers are Claude's wording that I accepted, so restate them before any post. The hands-on was plan-only by my choice (nothing applied, nothing in AWS). Code is in `sandbox/day-05-variables/`.
- 2026-11-08 (Day 6 started): Branch `day-06` cut from `main`. Note written from the transcript and the instructor's README and `task.md` (no `code/` folder exists for Day 6). My Day 5 sandbox is already split into files, so the challenge is a small step: move the `terraform` block into `versions.tf`. Hands-on and Q&A not started; the note's sections 4 to 8 are ready, section 7 holds differences found in the instructor material. SYNC.md and LINKEDIN-IDEAS.md updated. Cost check (Cost Explorer) showed 0 USD for Nov 3 to 7; credits are AWS Activate Founders, $999.12 unused, expiry 1/1/2027, extension request not yet filed. Nothing applied, nothing committed, nothing running in AWS.
- 2026-11-08 (Day 6 hands-on and Q&A): `sandbox/day-06-structure/` copied from Day 5 with the `terraform` block moved to `versions.tf`; `fmt`, `validate`, `tflint` and `trivy` pass, and `plan` matches Day 5 (5 to add, same names and tags; plan only, nothing applied). Q&A: three correct, three partial (file-merge reason, the `.gitignore` catch, state tracks addresses not files); four wordings are Claude's, so restate them before any post. Still open: the directory README, the backend decision (staying on local state is the recommendation), Day 6 tick in SYLLABUS.md, commit and PR. Nothing committed, nothing running in AWS.
- 2026-11-08 (Day 6 closed out): Cleanups done at my request: stray comment removed from `provider.tf`, names renamed to `tf30-day06-`, output renamed to `bucket_name`, README written (local state, no `backend.tf`). Plan still 5 to add; `fmt`, `validate`, `tflint` pass. Note, SYLLABUS, CHANGELOG and LINKEDIN-IDEAS synced. PR #18 squash-merged.
- 2026-11-09 (Day 7 started): Branch `day-07` cut from `main`. Note written from the transcript, my key notes, the instructor's README and `task.md`. Section 7 lists traps found in the instructor material (the `/8` VPC task, a hard-coded AMI). `sandbox/day-07-types/` is untracked work in progress; it includes an EC2 instance, which bills if applied. Hands-on and Q&A not done. Nothing committed, nothing applied, nothing running in AWS.
- 2026-11-09 (Day 7 hands-on, tasks 1 to 4): `sandbox/day-07-types/` has string, number, bool and list(string) variables, an instance, a VPC and two subnets. Plan only, `4 to add`; `fmt`, `validate`, `tflint` pass. `trivy` fails (AWS-0028, AWS-0131, AWS-0178), left open by my choice, so the PR will be blocked by `security-scan` until I fix or ignore them. Claude fixed the `associate_public_ip` type (string to bool) at my request. First Task 4 draft would have failed on apply (subnet outside the VPC, overlapping ranges). Tasks 5 to 10 and the Q&A are pending. Nothing applied, nothing committed, nothing running in AWS.
- 2026-11-09 (Day 7 hands-on, tasks 5 and 6): Task 5 `precondition` on the instance type and Task 6 `validation` on `region` reading a `set(string)`; both fail correctly on a bad value and pass on a good one (plan only, `4 to add`). `fmt`, `validate`, `tflint` pass; `trivy` first failed on two HIGH findings (IMDS token, unencrypted root disk); Claude fixed them at my request and the HIGH/CRITICAL gate now passes (one MEDIUM, VPC flow logs, left on purpose). Claude also fixed both tasks after my first versions did not enforce the rule. Tasks 7 to 10 and the Q&A are pending. Nothing applied, nothing running in AWS.
- 2026-11-09 (end of session): Docs synced and Day 7 paused by the owner. On `day-07`: note (`notes/week-01/day-07-type-constraints.md`) and sandbox committed locally (`27a3ec3`, `8b1ca35`), not pushed. Tasks 1 to 6 of 10 done and plan-checked (string, number, bool, list x2, set); Tasks 7 to 10 and the Q&A are pending, so Day 7 stays `watched`. Nothing applied; a check at the start of the session found no EC2 instance, and nothing has been applied since. Nothing left running in AWS.
- 2026-11-10 (Day 7 hands-on, task 7): `map(string)` `tags` on the VPC with a `vpc_name` output. First draft failed `validate` (`Variables not allowed` in a default) and had no `Name` key; Claude fixed it at my request. Plan `4 to add`; `fmt`, `validate`, `tflint` and the `trivy` HIGH/CRITICAL gate pass. Tasks 1 to 7 of 10 done; Tasks 8 to 10 and the Q&A pending, so Day 7 stays `watched`. Open question I still owe: why a default cannot use `var.environment`. Nothing applied, nothing running in AWS.
- 2026-11-10 (Day 7 hands-on, task 8): tuple `ingress_values` feeding a security group ingress rule in the VPC. My draft had four values for a three-slot tuple, so `validate` failed; Claude fixed it at my request. Plan `6 to add`; `fmt`, `validate`, `tflint` and the `trivy` HIGH/CRITICAL gate pass. Tasks 1 to 8 of 10 done; Task 9, Task 10 and the Q&A pending, so Day 7 stays `watched`. Branch `day-07` pushed. Nothing applied, nothing running in AWS.
