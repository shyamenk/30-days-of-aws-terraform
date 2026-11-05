# Progress

This file is the memory of where the course stands. Update it in the same PR that finishes a day. When you say "next day", the next day is the first row below that is not `done`, in day order.

**Last updated:** 2026-11-05 · **Started:** not yet · **Target finish:** about 5 weeks after the start · **Credits expire:** 2026-12-31

## Where I am

- **Current day:** 0 (note written on branch `day-00`; readiness checklist still to do)
- **Next up:** finish the Day 0 checklist in `notes/week-01/day-00-course-intro.md`, then merge `day-00` and start Day 1
- **Left running in AWS:** nothing
- **Open questions / blockers:** none

## Open items checklist

Tick these as you verify them. Anything unchecked is deliberately left open.

**Day 0 readiness (your hands-on, see the note for hints)**
- [x] Root user has MFA and is not used for daily work
- [x] Non-root identity does the work through the default profile (an IAM user, confirmed)
- [x] AWS Budget alert with an email notification at a low limit
- [x] `aws sts get-caller-identity` on the default profile shows the right account (you confirmed the account; the non-root part is the line above)
- [x] `terraform version` prints 1.17.1 inside this repo (confirmed by you in your own terminal)
- [ ] Explain VPC, subnet, internet gateway, route table, and what makes a subnet public
- [ ] CIDR: subnets in a `10.0.0.0/16` split into `/24`, and usable addresses in one AWS `/24`
- [ ] Describe blue-green, canary and rolling deployments with one risk each
- [ ] Write down the prerequisites you are weak on and when you will fix them

**Deliberately open, to fix later**
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
| 0 | todo (note drafted, checklist open) | | | [day-00](../../notes/week-01/day-00-course-intro.md) |
| 1 | todo | | | |
| 2 | todo | | | |
| 3 | todo | | | |
| 4 | todo | | | |
| 5 | todo | | | |
| 6 | todo | | | |
| 7 | todo | | | |
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
