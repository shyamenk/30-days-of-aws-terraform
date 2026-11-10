# Changelog

## [Unreleased]

### Added
- Repo scaffolding: syllabus for Days 0 to 30, daily note template, version and sync logs, doc-reading guide, checks-only CI, pinned tool versions.
- Progress tracker (`docs/progress/PROGRESS.md`), LinkedIn ideas log, per-day playlist titles in the README, and a LinkedIn section in the note template.
- Day-to-instructor-folder mapping in `docs/SYNC.md`.
- Branch convention: `day-NN` per course day, kept after squash merge.
- Branch protection on `main` (required checks, PRs, linear history, squash only).
- Day 0 note: course overview, prerequisites and a readiness checklist.
- Day 0 completed: Q&A-checked explanations, mistakes log and a weak-prerequisite plan (CIDR math, YAML).
- Day 1 note: why infrastructure as code, how the Terraform workflow runs, install check, and six checked self-check answers.
- Day 2 note: providers, versions and constraints, first VPC apply and destroy, and the first Terraform code in `sandbox/day-02-provider/`.
- Day 3 note and `sandbox/day-03-s3/`: first S3 bucket, the four core commands, and a VPC plus a hardened bucket (public access block, KMS encryption) linked by an implicit dependency. Applied, changed in place and destroyed.
- Day 4 note: state versus actual state, lock file versus state file, S3 remote backend with native locking, a `terraform state` command reference, and a review of my first backend setup. Fixed code in `sandbox/day-04-remote-backend/`: provider tags, a hardened demo bucket, and a `tf30-` state bucket with versioning.
- Day 5 note: input variables, locals and outputs, the variable precedence ladder, the type list from my key notes, and a plan-only hands-on in `sandbox/day-05-variables/` (variables, locals, outputs, a hardened bucket and VPC, `terraform.tfvars.example`, and a four-run precedence test).
- Day 6 note and `sandbox/day-06-structure/`: Terraform file layout and what each conventional file holds, the Q&A mistakes, and the Day 5 code split into `versions.tf`, `provider.tf`, `variables.tf`, `locals.tf`, `main.tf`, `outputs.tf` with a README (plan-only, local state).
- Day 7 note (in progress) and `sandbox/day-07-types/`: the type constraints, instructor-material traps, and plan-only practice for tasks 1 to 8 (string, number, bool, list, set, map, tuple) with a precondition on the instance type, a validation on the region, a hardened instance, a VPC, two subnets and a security group with one ingress rule.
