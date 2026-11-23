# Changelog

## [Unreleased]

### Changed
- Repo tidy-up before Day 9: `TIPS.md` moved to the repo root; the Day 7 note moved to `notes/week-02/` to match the syllabus weeks; the Week 1 session log archived to `docs/progress/LOG.md`; `sandbox/README.md` gained a folder table; `infra/` now starts on Day 14; the README layout and links updated.

### Added
- `CHEATSHEET.md` at the repo root: commands and concepts learned so far, one line each, with the day they came from.
- A "restate before posting" list in `docs/LINKEDIN-IDEAS.md` for Q&A answers that use Claude's wording.
- Day 9 note skeleton (`notes/week-02/day-09-lifecycle-rules.md`) holding the lifecycle preview moved from the Day 8 note.

### Added: setup
- Repo scaffolding: syllabus for Days 0 to 30, daily note template, version and sync logs, doc-reading guide, checks-only CI, pinned tool versions.
- Progress tracker (`docs/progress/PROGRESS.md`), LinkedIn ideas log, per-day playlist titles in the README, and a LinkedIn section in the note template.
- Day-to-instructor-folder mapping in `docs/SYNC.md`.
- Branch convention: `day-NN` per course day, kept after squash merge.
- Branch protection on `main` (required checks, PRs, linear history, squash only).

### Added: Week 1 (Days 0 to 6)
- Day 0 note: course overview, prerequisites and a readiness checklist.
- Day 0 completed: Q&A-checked explanations, mistakes log and a weak-prerequisite plan (CIDR math, YAML).
- Day 1 note: why infrastructure as code, how the Terraform workflow runs, install check, and six checked self-check answers.
- Day 2 note: providers, versions and constraints, first VPC apply and destroy, and the first Terraform code in `sandbox/day-02-provider/`.
- Day 3 note and `sandbox/day-03-s3/`: first S3 bucket, the four core commands, and a VPC plus a hardened bucket (public access block, KMS encryption) linked by an implicit dependency. Applied, changed in place and destroyed.
- Day 4 note: state versus actual state, lock file versus state file, S3 remote backend with native locking, a `terraform state` command reference, and a review of my first backend setup. Fixed code in `sandbox/day-04-remote-backend/`: provider tags, a hardened demo bucket, and a `tf30-` state bucket with versioning.
- Day 5 note: input variables, locals and outputs, the variable precedence ladder, the type list from my key notes, and a plan-only hands-on in `sandbox/day-05-variables/` (variables, locals, outputs, a hardened bucket and VPC, `terraform.tfvars.example`, and a four-run precedence test).
- Day 6 note and `sandbox/day-06-structure/`: Terraform file layout and what each conventional file holds, the Q&A mistakes, and the Day 5 code split into `versions.tf`, `provider.tf`, `variables.tf`, `locals.tf`, `main.tf`, `outputs.tf` with a README (plan-only, local state).

### Added: Week 2 (Days 7 to 13)
- Day 7 note and `sandbox/day-07-types/`: the type constraints, instructor-material traps, and plan-only practice for all ten assignments (string, number, bool, list, set, map, tuple, object, and a `deployment_summary` output) with a precondition on the instance type, a validation on the region, a hardened instance, a VPC, two subnets and a security group with one ingress rule.
- Day 8 note and `sandbox/day-08-meta-arguments/`: `count`, `for_each` and `depends_on`, the instructor-material traps, and plan-only practice for Tasks 1 to 3 (two bucket blocks, a KMS key, per-bucket protections and `for`-expression outputs), a `depends_on` bucket read with `terraform graph`, a reasoned removal test, a `count` versus `for_each` warning and the five-question Q&A.
- Day 9 note and `sandbox/day-09-lifecycle/`: all eight lifecycle settings checked against the docs, my key notes with a production scenario, instructor-material traps, and three applied-and-destroyed tasks (`prevent_destroy`, a `create_before_destroy` name clash, and the `name_prefix` fix). Day 9 lessons and lifecycle practices added to `TIPS.md`, and lifecycle rows to `CHEATSHEET.md`.
- Day 10 note and `sandbox/day-10-expressions/`: conditionals, splat and dynamic blocks checked against the docs, instructor-material traps, and five plan-only tasks (a conditional VPC range, a security group switched by `count` with a dynamic `ingress` block, `count` and `for_each` subnets with splat and `for` outputs, and console checks). Day 10 lessons and practices added to `TIPS.md`, and expression rows to `CHEATSHEET.md`.
- `TIPS.md` (first in `docs/`, now at the repo root): lessons from the course (config versus state, graph versus plan, ordering, `count` lists and `for_each` keys) and industry practices linked to the official docs. The README links to it.
