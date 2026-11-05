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
| See where I am in the course | [docs/progress/PROGRESS.md](docs/progress/PROGRESS.md) |
| See what is worth posting later | [docs/LINKEDIN-IDEAS.md](docs/LINKEDIN-IDEAS.md) |
| Check tool versions and when they were verified | [docs/VERSIONS.md](docs/VERSIONS.md) |
| See how the playlist and the instructor repo differ | [docs/SYNC.md](docs/SYNC.md) |
| Learn the doc-reading method | [docs/HOW-TO-READ-DOCS.md](docs/HOW-TO-READ-DOCS.md) |

## The course, day by day

Titles are copied from the playlist (checked 2026-11-05). Status and costs live in [docs/SYLLABUS.md](docs/SYLLABUS.md); where I am now is in [docs/progress/PROGRESS.md](docs/progress/PROGRESS.md).

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
| 11 | [AWS Terraform Functions - Part 1](https://www.youtube.com/watch?v=-dKsmU4Z1hM) | 55 |
| 12 | [AWS Terraform Functions - Part 2](https://www.youtube.com/watch?v=ZYCCu9rZkU8) | 43 |
| 13 | [Terraform Data Source AWS Explained (with demo)](https://www.youtube.com/watch?v=MSr67lWCyD8) | 23 |
| 14 | [Host A Static Website In AWS S3 And Cloudfront (using terraform)](https://www.youtube.com/watch?v=bK6RimAv2nQ) | 53 |
| 15 | [AWS VPC Peering Using Terraform - Mini project](https://www.youtube.com/watch?v=WGt000THDmQ) | 58 |
| 16 | [AWS IAM User Management with Terraform - Mini Project](https://www.youtube.com/watch?v=33dWo4esH1U) | 37 |
| 17 | [AWS Terraform Blue-Green Deployment Using Elastic Beanstalk](https://www.youtube.com/watch?v=fTVx2m5fEbQ) | 20 |
| 18 | [Image Processing Serverless Project using AWS Lambda (with terraform)](https://www.youtube.com/watch?v=l0RYCxczgyk) | 40 |
| 19 | [Terraform Provisioners (with demo) - local vs remote vs file](https://www.youtube.com/watch?v=DkhAgYa0448) | 25 |
| 20 | [Terraform Custom Modules for EKS - From Zero to Production](https://www.youtube.com/watch?v=a_j6Gq-KtxE) | 33 |
| 21 | [AWS Policy and Governance Setup Using Terraform](https://www.youtube.com/watch?v=sAtbDGi-82A) | 36 |
| 22 | [2-Tier Architecture Setup on AWS Using Terraform](https://www.youtube.com/watch?v=7XcqRDVMv3o) | 14 |
| 23 | [Setup End-to-End Observability in AWS Using Terraform (Real-Time Project)](https://www.youtube.com/watch?v=IxMwlFJRWC0) | 52 |
| 24 | [Highly Available and Scalable Architecture Using Terraform](https://www.youtube.com/watch?v=XAPCxphpgmQ) | 43 |
| 25 | [Terraform Import In AWS Explained With Demo](https://www.youtube.com/watch?v=gnO0P9CgVoo) | 50 |
| 26 | [HCP Terraform Explained with Demo - Terraform Projects and Workspaces](https://www.youtube.com/watch?v=n1kS8jKf70E) | 44 |
| 27 | [Automate AWS Infra Using Terraform and GitHub Actions \| Realtime Project](https://www.youtube.com/watch?v=cRnmyzT9gtU) | 49 |
| 28 | [AWS 3-tier Architecture With Terraform \| End-to-End Real-Time Project](https://www.youtube.com/watch?v=9_l_AplELi4) | 62 |
| 29 | [End-to-end GitOps With Terraform and ArgoCD For EKS \| Production-grade Kubernetes Project](https://www.youtube.com/watch?v=c_a5e2Dnxkk) | 48 |
| 30 | [Drift Detection and Remediation Using Terraform and GitHub Actions \| Real Time Project](https://www.youtube.com/watch?v=nRgNIy-SDEw) | 55 |

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

- One branch per course day (`day-00` to `day-30`), squash-merged into `main` through a PR with Conventional Commit messages. Day branches are kept after merge, so you can browse any day's work by switching to its branch; `main` always has everything finished so far.
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
