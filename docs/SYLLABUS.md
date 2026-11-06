# Syllabus

Source of truth for order and titles: the [YouTube playlist](https://www.youtube.com/playlist?list=PLl4APkPHzsUXcfBSJDExYR-a4fQiZGmMp). Instructor code for comparison only: [piyushsachdeva/Terraform-Full-Course-Aws](https://github.com/piyushsachdeva/Terraform-Full-Course-Aws). See [SYNC.md](SYNC.md) for where the two disagree.

Cost column is my estimate from the services involved, not measured. Confirm it from the video before you apply. Low = pennies, Med = a few dollars if left running a day, High = destroy the same session (EKS control plane is $0.10/hour plus nodes and NAT).

Tick the box in the PR that finishes the day.

## Week 1: Foundations (about 2.7 h of video)

| Done | Day | Topic | Video | Min | Cost | Primary docs |
|---|---|---|---|---|---|---|
| [x] | 0 | Course intro | [xUtGqC-NXJE](https://www.youtube.com/watch?v=xUtGqC-NXJE) | 34 | None | [Terraform intro](https://developer.hashicorp.com/terraform/intro) |
| [x] | 1 | How Terraform works, IaC | [s5fwSG_00P8](https://www.youtube.com/watch?v=s5fwSG_00P8) | 21 | None | [Install](https://developer.hashicorp.com/terraform/install), [Core workflow](https://developer.hashicorp.com/terraform/intro/core-workflow) |
| [ ] | 2 | AWS provider | [JFiMmaktnuM](https://www.youtube.com/watch?v=JFiMmaktnuM) | 31 | None | [Provider requirements](https://developer.hashicorp.com/terraform/language/providers/requirements), [AWS provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs) |
| [ ] | 3 | S3 bucket | [09HQ_R1P7Lw](https://www.youtube.com/watch?v=09HQ_R1P7Lw) | 12 | Low | [aws_s3_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) |
| [ ] | 4 | State, S3 remote backend | [YsEdrl9O5os](https://www.youtube.com/watch?v=YsEdrl9O5os) | 17 | Low | [State](https://developer.hashicorp.com/terraform/language/state), [S3 backend](https://developer.hashicorp.com/terraform/language/backend/s3) |
| [ ] | 5 | Variables: input, output, local | [V-2yC39BONc](https://www.youtube.com/watch?v=V-2yC39BONc) | 37 | Low | [Variables](https://developer.hashicorp.com/terraform/language/values/variables), [Outputs](https://developer.hashicorp.com/terraform/language/values/outputs), [Locals](https://developer.hashicorp.com/terraform/language/values/locals) |
| [ ] | 6 | Project structure best practices | [QMsJholPkDY](https://www.youtube.com/watch?v=QMsJholPkDY) | 12 | None | [Style guide](https://developer.hashicorp.com/terraform/language/style), [Module structure](https://developer.hashicorp.com/terraform/language/modules/develop/structure) |

Note: the playlist lists Day 6 before Day 5. Notes follow the day number.

## Week 2: The language (about 4.6 h of video)

| Done | Day | Topic | Video | Min | Cost | Primary docs |
|---|---|---|---|---|---|---|
| [ ] | 7 | Type constraints | [gu2oCJ9DQiQ](https://www.youtube.com/watch?v=gu2oCJ9DQiQ) | 52 | None | [Type constraints](https://developer.hashicorp.com/terraform/language/expressions/type-constraints) |
| [ ] | 8 | Meta-arguments | [XMMsnkovNX4](https://www.youtube.com/watch?v=XMMsnkovNX4) | 29 | Low | [count](https://developer.hashicorp.com/terraform/language/meta-arguments/count), [for_each](https://developer.hashicorp.com/terraform/language/meta-arguments/for_each), [depends_on](https://developer.hashicorp.com/terraform/language/meta-arguments/depends_on) |
| [ ] | 9 | Lifecycle rules | [60tOSwpvldY](https://www.youtube.com/watch?v=60tOSwpvldY) | 35 | Low | [lifecycle](https://developer.hashicorp.com/terraform/language/meta-arguments/lifecycle) |
| [ ] | 10 | Conditionals, splat, dynamic blocks | [R4ShnFDJwI8](https://www.youtube.com/watch?v=R4ShnFDJwI8) | 39 | Low | [Conditionals](https://developer.hashicorp.com/terraform/language/expressions/conditionals), [Splat](https://developer.hashicorp.com/terraform/language/expressions/splat), [Dynamic blocks](https://developer.hashicorp.com/terraform/language/expressions/dynamic-blocks) |
| [ ] | 11 | Functions, part 1 | [-dKsmU4Z1hM](https://www.youtube.com/watch?v=-dKsmU4Z1hM) | 55 | None | [Function reference](https://developer.hashicorp.com/terraform/language/functions) |
| [ ] | 12 | Functions, part 2 | [ZYCCu9rZkU8](https://www.youtube.com/watch?v=ZYCCu9rZkU8) | 43 | None | [Function reference](https://developer.hashicorp.com/terraform/language/functions) |
| [ ] | 13 | Data sources | [MSr67lWCyD8](https://www.youtube.com/watch?v=MSr67lWCyD8) | 23 | Low | [Data sources](https://developer.hashicorp.com/terraform/language/data-sources) |

## Week 3: Mini projects (about 3.9 h of video)

| Done | Day | Topic | Video | Min | Cost | Primary docs |
|---|---|---|---|---|---|---|
| [ ] | 14 | Static site on S3 and CloudFront | [bK6RimAv2nQ](https://www.youtube.com/watch?v=bK6RimAv2nQ) | 53 | Low | [aws_cloudfront_distribution](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_distribution), [aws_cloudfront_origin_access_control](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_origin_access_control) |
| [ ] | 15 | VPC peering | [WGt000THDmQ](https://www.youtube.com/watch?v=WGt000THDmQ) | 58 | Low | [aws_vpc_peering_connection](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_peering_connection) |
| [ ] | 16 | IAM user management | [33dWo4esH1U](https://www.youtube.com/watch?v=33dWo4esH1U) | 37 | None | [aws_iam_user](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user) |
| [ ] | 17 | Blue-green on Elastic Beanstalk | [fTVx2m5fEbQ](https://www.youtube.com/watch?v=fTVx2m5fEbQ) | 20 | Med | [aws_elastic_beanstalk_environment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elastic_beanstalk_environment) |
| [ ] | 18 | Serverless image processing (Lambda) | [l0RYCxczgyk](https://www.youtube.com/watch?v=l0RYCxczgyk) | 40 | Low | [aws_lambda_function](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) |
| [ ] | 19 | Provisioners | [DkhAgYa0448](https://www.youtube.com/watch?v=DkhAgYa0448) | 25 | Low | [Provisioners](https://developer.hashicorp.com/terraform/language/provisioners) |

## Week 4: Production patterns (about 3.8 h of video)

| Done | Day | Topic | Video | Min | Cost | Primary docs |
|---|---|---|---|---|---|---|
| [ ] | 20 | Custom modules for EKS | [a_j6Gq-KtxE](https://www.youtube.com/watch?v=a_j6Gq-KtxE) | 33 | **High** | [Modules](https://developer.hashicorp.com/terraform/language/modules), [aws_eks_cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_cluster) |
| [ ] | 21 | Policy and governance | [sAtbDGi-82A](https://www.youtube.com/watch?v=sAtbDGi-82A) | 36 | Low | Confirm services from the video, then search the [AWS provider docs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs) |
| [ ] | 22 | 2-tier architecture | [7XcqRDVMv3o](https://www.youtube.com/watch?v=7XcqRDVMv3o) | 14 | Med | [aws_instance](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance), [aws_db_instance](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance) |
| [ ] | 23 | End-to-end observability | [IxMwlFJRWC0](https://www.youtube.com/watch?v=IxMwlFJRWC0) | 52 | Med | [aws_cloudwatch_metric_alarm](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) |
| [ ] | 24 | Highly available, scalable architecture | [XAPCxphpgmQ](https://www.youtube.com/watch?v=XAPCxphpgmQ) | 43 | **High** | [aws_autoscaling_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_group), [aws_lb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb) |
| [ ] | 25 | Terraform import | [gnO0P9CgVoo](https://www.youtube.com/watch?v=gnO0P9CgVoo) | 50 | Low | [Import](https://developer.hashicorp.com/terraform/language/import) |

## Week 5: Automation and real-time projects (about 4.3 h of video)

| Done | Day | Topic | Video | Min | Cost | Primary docs |
|---|---|---|---|---|---|---|
| [ ] | 26 | HCP Terraform: projects and workspaces | [n1kS8jKf70E](https://www.youtube.com/watch?v=n1kS8jKf70E) | 44 | None | [HCP Terraform docs](https://developer.hashicorp.com/terraform/cloud-docs) |
| [ ] | 27 | Terraform with GitHub Actions | [cRnmyzT9gtU](https://www.youtube.com/watch?v=cRnmyzT9gtU) | 49 | Low | [GitHub Actions tutorial](https://developer.hashicorp.com/terraform/tutorials/automation/github-actions), [OIDC in AWS](https://docs.github.com/en/actions/how-tos/secure-your-work/security-harden-deployments/oidc-in-aws) |
| [ ] | 28 | 3-tier architecture | [9_l_AplELi4](https://www.youtube.com/watch?v=9_l_AplELi4) | 62 | **High** | [aws_vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc), [aws_nat_gateway](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/nat_gateway) |
| [ ] | 29 | GitOps with ArgoCD on EKS | [c_a5e2Dnxkk](https://www.youtube.com/watch?v=c_a5e2Dnxkk) | 48 | **High** | [Argo CD docs](https://argo-cd.readthedocs.io/en/stable/), [aws_eks_cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_cluster) |
| [ ] | 30 | Drift detection and remediation | [nRgNIy-SDEw](https://www.youtube.com/watch?v=nRgNIy-SDEw) | 55 | Low | [Detect drift](https://developer.hashicorp.com/terraform/cli/commands/plan), refresh-only mode |

## After Day 30 (credits expire 2026-12-31)

An EKS and Kubernetes block. Plan it in a separate repo so this one stays a clean Terraform course.
