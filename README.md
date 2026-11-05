# 30 Days of AWS Terraform

My notes and hands-on work while following Piyush Sachdeva's [#30DaysOfAWSTerraform](https://www.youtube.com/playlist?list=PLl4APkPHzsUXcfBSJDExYR-a4fQiZGmMp) playlist. The aim is to understand the concepts and read the docs well enough to build AWS resources without help, not to memorize commands.

Everything here is written by me. The instructor's [reference repo](https://github.com/piyushsachdeva/Terraform-Full-Course-Aws) is used only to compare after I attempt a day.

## Where to find things

| I want to... | Go to |
|---|---|
| See the day-by-day plan and tick progress | [docs/SYLLABUS.md](docs/SYLLABUS.md) |
| Read a day's notes, challenge and gotchas | `notes/week-NN/day-NN-topic.md` |
| See the Terraform code | `infra/` (modules and environments) |
| See early throwaway experiments | `sandbox/` |
| Check tool versions and when they were verified | [docs/VERSIONS.md](docs/VERSIONS.md) |
| See how the playlist and the instructor repo differ | [docs/SYNC.md](docs/SYNC.md) |
| Learn the doc-reading method | [docs/HOW-TO-READ-DOCS.md](docs/HOW-TO-READ-DOCS.md) |

## Layout

```
notes/        one note per day, same 8 sections (see notes/_template.md)
infra/
  modules/    reusable building blocks (vpc, ec2, ...)
  envs/       dev and prod root modules that call the modules
sandbox/      first attempts before the code has a structure
docs/         syllabus, versions, sync log, reading guide
```

## How the repo is run

- One branch and one squash-merged PR per course day, with Conventional Commit messages.
- CI checks formatting, validation, linting and security only. It has no AWS credentials.
- No state files, `*.tfvars`, keys or account IDs are ever committed.
- `terraform apply` and `destroy` run only from my machine, after reading the plan.

## Setup

```
mise install          # installs the pinned Terraform, TFLint and Trivy
terraform version
```

Use temporary credentials from an AWS profile. Never put access keys in files.

## License

MIT. See [LICENSE](LICENSE).
