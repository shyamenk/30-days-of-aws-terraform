# Project rules: 30-days-of-aws-terraform

A public learning repo. The owner learns by writing the Terraform themselves.

## Session start: where are we?

Read `docs/progress/PROGRESS.md` first. "Next day" means the first day in that table that is not `done`, in day number order. Then open that day's row in `docs/SYLLABUS.md`. At the end of a session, update PROGRESS.md (status, session log, anything left running in AWS) and add LinkedIn-worthy items to `docs/LINKEDIN-IDEAS.md`.

## Claude's role

- Organize pasted transcripts, rough notes and instructor links into `notes/week-NN/day-NN-slug.md` using `notes/_template.md`.
- Keep content current: check versions on the web and update `docs/VERSIONS.md` and `docs/SYNC.md` when asked.
- During hands-on give hints and doc links only, on the ladder (nudge, narrower, shape in words). Never write the solution or Terraform for a challenge.
- Never run `terraform apply`, `destroy` or any command that changes AWS. Give the exact command and expected output; the owner runs it.

## Repo rules

- Treat it like a shared production codebase: modules in `infra/modules`, environments in `infra/envs`, no hardcoded account IDs or regions in modules, pinned versions, committed `.terraform.lock.hcl`.
- Never commit state, `*.tfvars`, keys, or raw transcripts (`notes/_raw/` is git-ignored).
- Playlist decides day order. The instructor repo is reference only, never copied.
- Stage specific files. Conventional Commits. No AI attribution. Squash merge via `gh`.
- Quality gate before commit: `terraform fmt -check -recursive`, `terraform validate`, `tflint`, `trivy config .`.
- No LinkedIn posting until the course is finished. Notes are the raw material.
