# Day 0: Course intro and readiness check

Video: [Learn AWS With Terraform in 30 Days](https://www.youtube.com/watch?v=xUtGqC-NXJE) (34 min, recorded November 2025) · Instructor code: none for Day 0 · Verified against: Terraform 1.17.1, AWS provider 6.72.0 on 2026-11-05

This video has no Terraform code. It sets expectations and lists what you must know first. Everything about prizes, the submission workflow, the release schedule and Discord was left out on purpose because it does not serve our goal.

## 1. Goal

After today I can state what the 30 days cover, I have a safe AWS account and working tools, and I can honestly say whether I meet the prerequisites.

## 2. Concepts

**What the course is.** Terraform is infrastructure as code: you describe AWS resources in files and Terraform creates, changes and deletes them to match. The course teaches this through 30 videos in three modules.

| Module | Days | Content | Why it matters |
|---|---|---|---|
| 1. Core concepts | 1 to 13 | Providers, S3 and VPC, state and remote backend, variables, file structure, type constraints, meta-arguments, lifecycle rules, conditionals and dynamic blocks, functions, data sources | The instructor says this module covers the Terraform Associate certification exam, plus maybe one or two ideas from the later modules (his claim; check the exam guide yourself) |
| 2. AWS projects | 14 to 24 | S3 with CloudFront, VPC peering, IAM, Elastic Beanstalk blue-green, Lambda, provisioners, EKS modules, policy and governance, 2-tier, observability, highly available app | Real services wired together; modules appear here |
| 3. Advanced | 25 to 30 | Import, HCP Terraform, GitHub Actions, 3-tier, GitOps with ArgoCD, drift detection | How teams run Terraform in production |

**What the instructor says about learning.** Write your own Terraform. Watching without building means you lose the context in days and can't explain it in an interview. What you remember is the places you got stuck and how you fixed them. This is exactly what section 7 of every note is for.

**Prerequisites he lists, and what each is for.**

| Prerequisite | Why Terraform needs it |
|---|---|
| AWS account and basic AWS knowledge | Terraform only automates what you could click in the console. If you can't build it by hand, you can't describe it |
| Networking basics (OSI model, SSH, HTTP/HTTPS, TCP/UDP) | Security groups, subnets and load balancers are all network rules |
| VPC, subnets, gateways, route tables, CIDR math | Days 3, 15, 22, 24 and 28 build networks |
| Deployment strategies (blue-green, canary, rolling) | Day 17 is a blue-green deployment |
| Git and GitHub | All Terraform lives in version control |
| Linux, macOS or WSL, and shell basics | The commands in the course are shell commands |
| YAML and JSON | Terraform's language (HCL) is JSON-like, and Day 7 types map onto it |
| An editor such as VS Code | Day-to-day writing |

**What changed since the video.** It is a year old. The instructor's repo states no versions, and the Day 30 folder pins Terraform 1.10.3. We run 1.17.1. Expect renamed arguments and deprecated resource settings. When the video and the docs disagree, the docs for our pinned version win, and the difference goes in Gotchas.

**The announced curriculum differs from what was released.** Compare the Day 0 description with the playlist (details in [SYNC.md](../../docs/SYNC.md)): Day 22 was announced as an RDS database but released as a 2-tier architecture, Day 27 as a CI/CD pipeline but released as GitHub Actions, and the Terraform Cloud drift detection moved from Day 30 to an unreleased Day 31. Follow the released videos.

## 3. Docs to read

- [ ] [What is Amazon VPC](https://docs.aws.amazon.com/vpc/latest/userguide/what-is-amazon-vpc.html): can you name every component it lists?
- [ ] [VPC subnet sizing](https://docs.aws.amazon.com/vpc/latest/userguide/subnet-sizing.html): which addresses AWS reserves in every subnet
- [ ] [IAM security best practices](https://docs.aws.amazon.com/IAM/latest/UserGuide/best-practices.html): root user, MFA, temporary credentials
- [ ] [Create a budget](https://docs.aws.amazon.com/cost-management/latest/userguide/budgets-create.html)
- [ ] [Install the AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html) and [configure SSO](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-sso.html)
- [ ] [Deployment strategies](https://docs.aws.amazon.com/whitepapers/latest/overview-deployment-options/deployment-strategies.html): blue-green, canary, rolling
- [ ] [Terraform intro](https://developer.hashicorp.com/terraform/intro) and the [Terraform Associate exam page](https://developer.hashicorp.com/certifications/infrastructure-automation) (to see what the exam actually lists)

## 4. Challenge

You are ready for Day 1 when all of these are true:

- [ ] Root user has MFA and is not used for daily work. A non-root identity does the work, using temporary credentials from a named profile.
- [ ] An AWS Budget alert exists with an email notification at a low limit.
- [ ] `mise install` completes in this repo, and `terraform version` prints 1.17.1.
- [ ] `aws --version` runs cleanly on this machine.
- [ ] `aws sts get-caller-identity --profile <yours>` shows your non-root identity.
- [ ] You can explain in your own words, without notes: VPC, subnet, internet gateway, route table, and how a subnet becomes "public".
- [ ] Given `10.0.0.0/16`, you can work out how many `/24` subnets fit, and how many usable addresses one `/24` subnet gives in AWS.
- [ ] You can describe blue-green, canary and rolling deployments, with one risk of each.
- [ ] You wrote down which prerequisites you are weak on and where you will fix that this week.

## 5. Hints

Open one at a time, in order.

1. Account safety: the IAM best practices page has a section on the root user and one on temporary credentials. Read both before touching the console.
2. Budget: the creation page walks through a "cost budget". The setting you care about is the alert threshold and the email.
3. CIDR: the number after the slash is how many bits are fixed. The subnet sizing page tells you what AWS subtracts from the total.
4. Deployment strategies: for each one, ask what is running during the release, how you roll back, and what it costs.

## 6. Verify

| Command | Expected |
|---|---|
| `mise install && terraform version` | `Terraform v1.17.1` |
| `aws --version` | A version line, no shell errors |
| `aws sts get-caller-identity --profile <yours>` | An ARN that is not `:root` |
| `git remote -v` | HTTPS URL of this repo |

## 7. Gotchas and mistakes

Fill in as you go. One item to check first:

- During repo setup on this machine, running `aws --version` printed `compdef:153: _comps: assignment to invalid subscript range`. The cause is unknown. It looks like a zsh completion problem, not a problem with the AWS CLI, but that is unverified. Your pre-flight check should confirm the CLI works.

## 8. Cleanup

- [ ] Nothing to destroy today.
- [ ] Confirm no resources were created. The Budget is free and stays.

## 9. LinkedIn worth

The announced syllabus and the released videos differ, and the instructor's own README still reflects the announcement. Idea: how to check what a course teaches against what it shipped. Logged as a low-strength item in [LINKEDIN-IDEAS.md](../../docs/LINKEDIN-IDEAS.md).
