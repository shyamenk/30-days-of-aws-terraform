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
