# 30 Days of AWS Terraform

My notes and hands-on work while following Piyush Sachdeva's [#30DaysOfAWSTerraform](https://www.youtube.com/playlist?list=PLl4APkPHzsUXcfBSJDExYR-a4fQiZGmMp) playlist. The aim is to understand the concepts and read the docs well enough to build AWS resources without help, not to memorize commands.

Everything here is written by me. The instructor's [reference repo](https://github.com/piyushsachdeva/Terraform-Full-Course-Aws) is used only to compare after I attempt a day.

## Where to find things

**Start here:** [TIPS.md](TIPS.md) for lessons and best practices, and [CHEATSHEET.md](CHEATSHEET.md) for every command and concept so far in one line each.

| I want to... | Go to |
|---|---|
| Read tips and best practices | [TIPS.md](TIPS.md) |
| Look up a command or concept quickly | [CHEATSHEET.md](CHEATSHEET.md) |
| Read a day's notes, challenge and gotchas | `notes/week-NN/day-NN-topic.md` (weeks follow the syllabus) |
| See the concept-day code (Days 2 to 12) | [sandbox/](sandbox/README.md), one folder per day with what was applied |
| See the project code (Day 13 on) | [infra/](infra/README.md), modules and environments |
| See where I am in the course | [docs/progress/PROGRESS.md](docs/progress/PROGRESS.md) (older sessions in [LOG.md](docs/progress/LOG.md)) |
| See the day-by-day plan and costs | [docs/SYLLABUS.md](docs/SYLLABUS.md) |
| See what is worth posting later | [docs/LINKEDIN-IDEAS.md](docs/LINKEDIN-IDEAS.md) |
| Check tool versions and when they were verified | [docs/VERSIONS.md](docs/VERSIONS.md) |
| See how the playlist and the instructor repo differ | [docs/SYNC.md](docs/SYNC.md) |
| Learn the doc-reading method | [docs/HOW-TO-READ-DOCS.md](docs/HOW-TO-READ-DOCS.md) |

## The course, day by day

Titles are copied from the playlist (checked 2026-11-05). Both functions videos are Day 11, so from Day 12 on our number is one less than the video's. Status and costs live in [docs/SYLLABUS.md](docs/SYLLABUS.md); where I am now is in [docs/progress/PROGRESS.md](docs/progress/PROGRESS.md).

| Day | Playlist title | Min |
|---|---|---|
| 0 | [Learn AWS With Terraform in 30 Days (with real-time projects)](https://www.youtube.com/watch?v=xUtGqC-NXJE) | 34 |
| 1 | [How Does Terraform Work \| Intro to IAC](https://www.youtube.com/watch?v=s5fwSG_00P8) | 21 |
| 2 | [Terraform AWS Provider explained](https://www.youtube.com/watch?v=JFiMmaktnuM) | 31 |
| 3 | [Create an AWS S3 Bucket Using Terraform (it's simple)](https://www.youtube.com/watch?v=09HQ_R1P7Lw) | 12 |
| 4 | [Terraform State file management with AWS S3 \| Remote Backend](https://www.youtube.com/watch?v=YsEdrl9O5os) | 17 |
| 5 | [Terraform Variables in AWS - Input vs Output vs Local Variables](https://www.youtube.com/watch?v=V-2yC39BONc) | 37 |
| 6 | [AWS Terraform Project Structure Best Practices](https://www.youtube.com/watch?v=QMsJholPkDY) | 12 |
| 7 | [AWS Terraform Type Constraints Explained (with realtime examples)](https://www.youtube.com/watch?v=gu2oCJ9DQiQ) | 52 |
| 8 | [AWS Terraform Meta Arguments Made EASY \| Count, depends_on, for_each](https://www.youtube.com/watch?v=XMMsnkovNX4) | 29 |
| 9 | [AWS Terraform Lifecycle Rules Explained](https://www.youtube.com/watch?v=60tOSwpvldY) | 35 |
| 10 | [AWS Terraform Conditional Expressions, Splat Expressions and Dynamic Block](https://www.youtube.com/watch?v=R4ShnFDJwI8) | 39 |
| 11 | [AWS Terraform Functions - Part 1](https://www.youtube.com/watch?v=-dKsmU4Z1hM) and [Part 2](https://www.youtube.com/watch?v=ZYCCu9rZkU8) | 98 |
| 12 | [Terraform Data Source AWS Explained (with demo)](https://www.youtube.com/watch?v=MSr67lWCyD8) | 23 |
| 13 | [Host A Static Website In AWS S3 And Cloudfront (using terraform)](https://www.youtube.com/watch?v=bK6RimAv2nQ) | 53 |
| 14 | [AWS VPC Peering Using Terraform - Mini project](https://www.youtube.com/watch?v=WGt000THDmQ) | 58 |
| 15 | [AWS IAM User Management with Terraform - Mini Project](https://www.youtube.com/watch?v=33dWo4esH1U) | 37 |
| 16 | [AWS Terraform Blue-Green Deployment Using Elastic Beanstalk](https://www.youtube.com/watch?v=fTVx2m5fEbQ) | 20 |
| 17 | [Image Processing Serverless Project using AWS Lambda (with terraform)](https://www.youtube.com/watch?v=l0RYCxczgyk) | 40 |
| 18 | [Terraform Provisioners (with demo) - local vs remote vs file](https://www.youtube.com/watch?v=DkhAgYa0448) | 25 |
| 19 | [Terraform Custom Modules for EKS - From Zero to Production](https://www.youtube.com/watch?v=a_j6Gq-KtxE) | 33 |
| 20 | [AWS Policy and Governance Setup Using Terraform](https://www.youtube.com/watch?v=sAtbDGi-82A) | 36 |
| 21 | [2-Tier Architecture Setup on AWS Using Terraform](https://www.youtube.com/watch?v=7XcqRDVMv3o) | 14 |
| 22 | [Setup End-to-End Observability in AWS Using Terraform (Real-Time Project)](https://www.youtube.com/watch?v=IxMwlFJRWC0) | 52 |
| 23 | [Highly Available and Scalable Architecture Using Terraform](https://www.youtube.com/watch?v=XAPCxphpgmQ) | 43 |
| 24 | [Terraform Import In AWS Explained With Demo](https://www.youtube.com/watch?v=gnO0P9CgVoo) | 50 |
| 25 | [HCP Terraform Explained with Demo - Terraform Projects and Workspaces](https://www.youtube.com/watch?v=n1kS8jKf70E) | 44 |
| 26 | [Automate AWS Infra Using Terraform and GitHub Actions \| Realtime Project](https://www.youtube.com/watch?v=cRnmyzT9gtU) | 49 |
| 27 | [AWS 3-tier Architecture With Terraform \| End-to-End Real-Time Project](https://www.youtube.com/watch?v=9_l_AplELi4) | 62 |
| 28 | [End-to-end GitOps With Terraform and ArgoCD For EKS \| Production-grade Kubernetes Project](https://www.youtube.com/watch?v=c_a5e2Dnxkk) | 48 |
| 29 | [Drift Detection and Remediation Using Terraform and GitHub Actions \| Real Time Project](https://www.youtube.com/watch?v=nRgNIy-SDEw) | 55 |

## Layout

```
TIPS.md         lessons from the course and industry practices
CHEATSHEET.md   commands and concepts, one line each, with the day
notes/
  week-NN/      one note per day, same 9 sections (see notes/_template.md)
  reviews/      spaced revision rounds over finished days, with grades
  _raw/         pasted transcripts, git-ignored
sandbox/        concept days 2 to 12, one root module per day
infra/          project days 13 on
  modules/      reusable building blocks (vpc, ec2, ...)
  envs/         dev and prod root modules that call the modules
docs/
  progress/     PROGRESS.md (where I am) and LOG.md (older sessions)
  SYLLABUS.md, VERSIONS.md, SYNC.md, LINKEDIN-IDEAS.md, HOW-TO-READ-DOCS.md
```

## How the repo is run

- One branch per course day (`day-00` to `day-29`), squash-merged into `main` through a PR with Conventional Commit messages. Day branches are kept after merge, so you can browse any day's work by switching to its branch; `main` always has everything finished so far.
- `main` is protected: changes go through a PR, both CI jobs must pass, history stays linear, and force-push and deletion are blocked. Only squash merges are allowed.
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
