# Day 1: How Terraform works, Infrastructure as Code

Video: [How Does Terraform Work | Intro to IAC](https://www.youtube.com/watch?v=s5fwSG_00P8) (21 min) · Instructor code: [lessons/day01](https://github.com/piyushsachdeva/Terraform-Full-Course-Aws/tree/main/lessons/day01) (README and task only, no Terraform code) · Verified against: Terraform 1.17.1 on 2026-11-06 (no provider is used today)

This is a concepts day. The only hands-on part is installing the tools and confirming they run.

## 1. Goal

After today I can explain why a team writes infrastructure as code instead of clicking in a console, name the six everyday Terraform commands and what each one does, and run `terraform` on my machine through the `tf` alias.

## 2. Concepts

**Infrastructure as code (IaC).** You describe servers, networks, buckets and rules in text files, and a tool makes the real cloud match the files. The files are the source of truth, not someone's memory of what they clicked.

**Where Terraform sits among the tools.** Terraform is vendor-neutral: one tool and one language for many clouds. Pulumi is also vendor-neutral, but you write it in a general programming language. The rest belong to one cloud each.

| Scope | Tools |
|---|---|
| Any cloud | Terraform, Pulumi |
| AWS only | CloudFormation, CDK, SAM |
| Azure only | ARM templates, Bicep |
| GCP only | Deployment Manager, Config Connector |

**Why clicking does not scale.** The instructor's arithmetic: a three-tier app (public web tier, private app tier, database tier, with load balancers, autoscaling, CDN and health checks) takes about 2 hours by hand. A company has about 6 environments per app (dev, integration test, performance test, disaster recovery, staging, production), so 12 hours per app. Multiply by hundreds of apps. The hours are his estimate, not a measurement, but the shape of the problem is real.

The seven problems he lists, each with the reason it happens:

| Problem | Why manual work causes it |
|---|---|
| Time | Every resource is created one at a time, and databases are slow |
| People | You need staff whose whole job is provisioning |
| Cost | Staff time, plus forgotten resources that keep billing after the test ends |
| Repetitive | The same steps are done again for each environment |
| Human error | A wrong database host or a skipped setting brings the app down |
| Insecure | A forgotten step, such as turning on encryption, leaves a hole |
| "Works on my machine" | Different people build dev and prod differently, so they drift apart |

There is also a waiting cost: developers and testers cannot start until the infrastructure team finishes.

**What Terraform changes.** You write the description once and reuse it for every environment. That gives consistent environments, changes tracked in Git (who changed what, and when), and cheap teardown of non-production environments when nobody is using them. The slogan is "write once, deploy many". The instructor also called it DRY (don't repeat yourself), which really arrives later with modules.

**The language.** Terraform files end in `.tf` and are written in HCL (HashiCorp Configuration Language). It is made to be read by people and by the tool. It looks like JSON but is a different language, and it is a configuration language, not a general programming language.

**How the workflow runs.**

```
 .tf files ──► Git ──► (CI pipeline or my terminal)
                              │
          terraform init      │  set up the working folder, download providers
          terraform fmt       │  tidy the formatting
          terraform validate  │  check syntax and internal consistency
          terraform plan      │  dry run: show what would be created, changed, deleted
          terraform apply     │  do it
          terraform destroy   │  remove everything Terraform manages here
                              ▼
                  provider calls the cloud's API
                              ▼
                     real resources in AWS
```

Terraform does not touch AWS itself. A **provider** (a plugin, covered on Day 2) translates the plan into AWS API calls. The console, the AWS CLI and Terraform all end up calling the same AWS API. Terraform's difference is that it remembers what it built and compares that with the files.

**Two ways to run it.** By hand from a terminal, or automatically from a pipeline such as GitHub Actions whenever the files change in Git. Day 27 builds the second one.

**What the instructor did not cover** and I should keep in mind: `terraform fmt` was not in his command list (I added it from my own notes), and he did not explain state, which is how Terraform remembers what exists. State arrives in a later day and explains why `destroy` removes what it built, not "everything in the files".

### What I can now explain (checked in a Q&A, 2026-11-06)

| Problem by hand | Terraform fix |
|---|---|
| Human error (a wrong click, a forgotten step) | I write code, and every environment is built from that same code, so they come out identical |
| Time (hours per environment) | Reuse: write once, deploy many |
| No history of changes (who changed what, and when) | `.tf` files live in remote version control, so I can see the history and go back to an older version |

- **`plan` and `apply`:** `plan` is a dry run that lists what would be created, changed or deleted. `apply` makes those changes. Run `plan` first to check the list against my intent before any real resource, or any money, is touched. In a team the plan output can be reviewed in a pull request.
- **`init`:** prepares the working folder. It downloads provider plugins into `.terraform`, sets up the backend, and writes `.terraform.lock.hcl`, which pins provider versions. It creates no AWS resources. Run it again after a provider, backend or module change, and after a fresh clone.
- **Who creates the resources:** Terraform plans the changes and hands each action to the provider plugin. The plugin makes the AWS API calls. The console and AWS CLI call the same API.
- **Why Git:** history of who changed what and when, rollback to an older version, review of a change before it is applied, and a trigger for automated pipelines (Day 27).
- **HCL and JSON:** both describe structured data as nested keys and values, and Terraform can read a JSON form of its files (`.tf.json`). HCL is built for people to write: it has comments, references between resources, and functions. Plain JSON has none of these.

## 3. Docs to read

- [ ] [Install Terraform](https://developer.hashicorp.com/terraform/install) (how the package manager route differs from a version manager such as mise)
- [ ] [Core Terraform workflow](https://developer.hashicorp.com/terraform/intro/core-workflow) (write, plan, apply: which step makes changes?)
- [ ] [Terraform CLI commands](https://developer.hashicorp.com/terraform/cli/commands) (find `init`, `fmt`, `validate`, `plan`, `apply`, `destroy` in the list)

## 4. Challenge

Tools, confirmed from the terminal output you pasted:

- [x] `terraform version` prints `Terraform v1.17.1` inside this repo
- [x] `aws --version` prints `aws-cli/2.37.9`
- [x] The alias `tf` works: `tf --version` prints `Terraform v1.17.1`

Tools I could not confirm from what was pasted (tick these once you have checked):

- [x] Tab completion is installed: `terraform -install-autocomplete` (confirmed by you, 2026-11-06)
- [x] The HashiCorp Terraform extension is installed in your editor (confirmed by you, 2026-11-06)

Concepts, answered in my own words and checked in a Q&A on 2026-11-06:

- [x] Three problems with creating infrastructure by hand, and the Terraform feature that removes each
- [x] The difference between `terraform plan` and `terraform apply`, and why `plan` comes first
- [x] What `terraform init` does, and when to run it again
- [x] What actually creates the AWS resources, and what Terraform hands over to it
- [x] Why the `.tf` files live in Git, and two things that gives
- [x] A way "HCL is just JSON" is true and a way it is not

## 5. Hints

Open one at a time, in order.

1. Nudge: the core workflow page describes write, plan and apply. The CLI commands page lists what each command is for.
2. Narrower: for the `init` question, look at what the `init` page says about providers and about what changes in the working folder.
3. Last resort: for the "who creates the resources" question, the answer is a plugin that Terraform downloads and that speaks to the cloud's API. Today's diagram has it in the middle.

## 6. Verify

| Command | Expected |
|---|---|
| `terraform version` | `Terraform v1.17.1` on `linux_amd64` |
| `tf --version` | The same output, through the alias |
| `aws --version` | `aws-cli/2.37.9 ...` |
| `type tf` (zsh) | Says `tf` is an alias for `terraform` |

## 7. Gotchas and mistakes

- **The video is on Terraform 1.13.3, we run 1.17.1.** The install steps differ too: he uses Homebrew on a Mac, we use mise on Linux. Nothing in today's concepts changed between those versions.
- **"Terraform destroy deletes all the resources in the files"** (the video's wording) is loose. It destroys what Terraform's state says it created. A resource written in a file but never applied is not touched, and one that is in state but removed from the files is destroyed. This becomes clear when state is covered.
- **`terraform init` "initializes the infrastructure"** (the video's wording) is also loose. It prepares the working folder (providers and backend). It creates no cloud resources.
- **The alias lives in my shell config.** `tf` only works in shells that load that config, and not in CI or scripts. Use the full `terraform` word in anything that is committed.
- **`.terraform.lock.hcl` is not a state lock.** I called it a "state lock file". It is the dependency lock file that pins provider versions, and it is committed. A state lock is a different thing: a temporary lock a backend holds while one `apply` runs.
- **I named four problems but only three feature fixes at first.** "Collaboration" and "version control" are one problem: no record of who changed what. I also skipped the second half of the question (which Terraform feature fixes each problem) until asked again.
- **The instructor's `submission.md` link is dead.** His Day 1 `task.md` points to a file that does not exist on `main`. See [SYNC.md](../../docs/SYNC.md).

## 8. Cleanup

Nothing was created in AWS today.

- [x] No `terraform apply` was run, so there is nothing to destroy
- [x] No AWS resources were created, so no console or Billing check is needed

## 9. LinkedIn worth

One candidate: the arithmetic of why teams stop clicking (2 hours for one app, times six environments, times hundreds of apps), with the honest caveat that the hours are an estimate. Added to `docs/LINKEDIN-IDEAS.md`. Nothing is posted until the course is finished.
