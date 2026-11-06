# Day 2: Terraform providers and the AWS provider

Video: [Terraform AWS Provider explained](https://www.youtube.com/watch?v=JFiMmaktnuM) (31 min) · Instructor code: [lessons/day02](https://github.com/piyushsachdeva/Terraform-Full-Course-Aws/tree/main/lessons/day02) (README and task only, no `.tf` files) · Verified against: Terraform 1.17.1, AWS provider 6.72.0 on 2026-11-06

Source material for this note: the video transcript, my rough notes, my own terminal output, and the instructor's README. Where the instructor said something that does not hold up against the docs or my own output, it is in section 7.

## 1. Goal

After today I can explain what a provider is and why its version is pinned separately from Terraform's, write a `terraform` block and an AWS `provider` block, read a plan, and create and destroy one VPC safely in the shared account.

## 2. Concepts

**What a provider is.** Terraform itself knows nothing about AWS. A provider is a plugin that does. Terraform core reads my files and builds a plan, then hands each action to the provider, and the provider calls the target service's API (for AWS, the AWS API). This is the same flow as the Day 1 diagram, now with the middle piece named.

```
 Terraform (own version)  ◄──►  Provider plugin (own version)  ◄──►  Target API
                                  downloaded from the Registry         AWS, Azure, GCP,
                                                                       Docker, Kubernetes,
                                                                       Datadog, Prometheus ...
```

**Types of provider** (from the video's slide and the Registry's tiers):

| Tier | Who maintains it | Example |
|---|---|---|
| Official | HashiCorp | `hashicorp/aws` |
| Partner | The vendor, verified by HashiCorp | Datadog |
| Community | Anyone | Third-party and hobby providers |

The instructor describes official as the big clouds (AWS, Azure, GCP), partner as maintained by a third party, and community as open source. I could not confirm his claim that the AWS provider is not maintained by HashiCorp: the Registry lists it in the `hashicorp` namespace. The Registry is [registry.terraform.io](https://registry.terraform.io). The AWS provider docs there are the page I will use most.

**Two version numbers.** Terraform core has a version and each provider has its own, and they move independently. Today: Terraform 1.17.1 and AWS provider 6.72.0.

**Why pin the provider version.** Without a constraint, `init` installs the newest provider. A newer provider can rename or remove arguments, so a configuration that worked yesterday can break. The rule the video gives: use the version you developed and tested against. A constraint plus the lock file make every run use the same one.

**Version constraints** (operators as in the video, checked against the Terraform docs):

| Written | Meaning |
|---|---|
| `= 6.72.0` or `6.72.0` | Exactly this version |
| `!= 6.72.0` | Anything except this |
| `>= 6.0` | This or newer, with no upper limit |
| `< 7.0` | Older than this |
| `~> 6.0` | At least 6.0 and below 7.0 (only the right-most number may rise) |
| `~> 6.72.0` | At least 6.72.0 and below 6.73.0 |
| `>= 6.0, < 7.0` | Both conditions together |

The video's own examples of `~>`: `~> 1.0.4` allows 1.0.5 and 1.0.10 but not 1.1.0, and `~> 1.1` allows 1.2 up to 1.10 but not 2.0. The rule: only the right-most number you wrote may rise.

**The blocks I wrote, and what each one is for.**

| Block | Job |
|---|---|
| `terraform { required_providers { aws = { source, version } } }` | Which provider to download, from which address (`hashicorp/aws`), and which versions are acceptable |
| `terraform { required_version }` | Which Terraform versions may run this code |
| `provider "aws" { region }` | Settings for the provider, such as the region |
| `resource "aws_vpc" "example" { ... }` | One thing to create. `aws_vpc` is the type, `example` is my local name |

Another resource refers to this one as `aws_vpc.example.id`. That is how resources link to each other, and the video's VPC-ID example (19:54) shows this.

**The lock file.** `terraform init` wrote `.terraform.lock.hcl`, which records the exact provider version chosen (6.72.0) and its checksums. It is committed, so everyone and CI get the same plugin. The `.terraform` folder holds the downloaded plugin and is not committed.

**Credentials.** The AWS provider finds credentials the same way the AWS CLI does, so `aws configure` or a profile is enough. The video hit an authentication error at 23:19 (the plan could not fetch the account identity) and fixed it by creating a new IAM user with S3 full access and long-lived access keys. Mine was already set up on Day 0, so it worked first time. Keys never go into `.tf` files.

**Reading a plan.** `+` means create. `(known after apply)` means AWS decides the value (the ID, the ARN). The last line, `Plan: 1 to add, 0 to change, 0 to destroy.`, is the summary to check. In my plan, `cidr_block = "10.0.0.0/16"` was the value I set and `enable_dns_support = true` and `instance_tenancy = "default"` were provider defaults.

### What I can now explain (checked in a Q&A, 2026-11-06)

- **Provider:** a plugin that translates Terraform's planned actions into API calls for one platform, such as AWS. Terraform decides what should exist and hands each action to the provider, and the provider makes the API call. `terraform init` downloads the plugin.
- **Two versions:** Terraform core and each provider have separate versions and release schedules, so they must stay compatible. Without a constraint, `init` installs the newest provider, which may rename or drop arguments and break working code. I pin the version I developed and tested with, and test an upgrade in non-production before production.
- **Constraints:** `~> 6.0` allows 6.0 up to but not including 7.0 (minor and patch updates, no new major). `~> 6.72.0` allows only patch updates, 6.72.x. Only the right-most number I wrote may rise.
- **The two blocks:** `required_providers` (inside `terraform`) declares which plugin, its source address and the allowed versions, and `init` uses it to download. The `provider "aws"` block configures the installed plugin (region, default tags). The block is technically optional, but I keep it so the region is in the code.
- **Lock file:** `.terraform.lock.hcl` records the exact provider version `init` chose and checksums of the plugin. It locks providers only, not Terraform itself, and it is not a state lock. It is committed so everyone and CI install the same plugin. `.terraform` is large, holds the downloaded plugin and is recreated by `init`, so it is not committed.
- **Reading a plan:** `(known after apply)` marks values AWS assigns only when the resource exists (ID, ARN, owner). Values I write (CIDR block, tags) and provider defaults (`enable_dns_support`, `instance_tenancy`) are known at plan time. Outputs, covered later, read the assigned values back.

## 3. Docs to read

- [ ] [Provider requirements](https://developer.hashicorp.com/terraform/language/providers/requirements) (the difference between `required_providers` and a `provider` block)
- [ ] [Version constraints](https://developer.hashicorp.com/terraform/language/expressions/version-constraints) (what `~> 6.0` allows and blocks)
- [ ] [AWS provider docs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs) (the `region` and `default_tags` settings)
- [ ] [`aws_vpc` resource](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc) (which arguments are required, which are optional)
- [ ] [Dependency lock file](https://developer.hashicorp.com/terraform/language/files/dependency-lock) (what it records and why it is committed)

## 4. Challenge

Done so far, from my terminal output:

- [x] `terraform init` installed `hashicorp/aws` v6.72.0 for the constraint `~> 6.0` and wrote the lock file
- [x] `terraform plan` showed `Plan: 1 to add, 0 to change, 0 to destroy.`
- [x] `terraform apply` created one VPC (`Apply complete! Resources: 1 added`)
- [x] `terraform destroy` removed it (`Destroy complete! Resources: 1 destroyed.`)

My first version worked but broke this repo's rules and its CI. I asked Claude to make the fixes directly (an exception to the hints-only rule), and they are in `sandbox/day-02-provider/main.tf`:

- [x] The code lives in its own folder under `sandbox/` named for the day, not in the repo root
- [x] `tflint` exits 0 (it exited 2 with `terraform_required_version` before)
- [x] The `terraform` block limits which Terraform versions may run it: `~> 1.17`, the same major version as the pinned 1.17.1
- [x] The VPC name starts with `tf30-` and the resource carries the tag `Project = 30-days-of-aws-terraform`. My `terraform plan` shows `Name = "tf30-day02-vpc"` in `tags` and both `Name` and `Project` in `tags_all`
- [ ] `.terraform.lock.hcl` is committed. No state file or `.terraform` folder is (the ignore rules cover both)
- [ ] Console check: no VPC with `10.0.0.0/16` is left over
- [x] Explain in my own words the answers to the Q&A questions below (done 2026-11-06)

**Q&A questions** (answered in my own words, checked with Claude):

1. What is a provider, and what does Terraform hand over to it?
2. Terraform and the provider each have a version. Why are they separate, and why pin the provider?
3. What does `~> 6.0` allow, and what does it block? What would `~> 6.72.0` do differently?
4. What is the difference between `required_providers` and a `provider "aws"` block?
5. What is in `.terraform.lock.hcl`, and why is it committed while `.terraform` is not?
6. In the plan, why did most arguments say `(known after apply)`?

## 5. Hints

Open one at a time, in order.

1. Nudge, layout: `sandbox/README.md` says where experiments go and how to name the folder. Nudge, `tflint`: the rule page linked in its output explains what it wants. Nudge, tags: `README` of the AWS provider mentions `default_tags`.
2. Narrower: `required_version` sits in the same `terraform` block as `required_providers`. The VPC resource has an argument called `tags`, and a `Name` tag is what the console shows as the name.
3. Last resort, in words only: the `terraform` block gets one more line that names an allowed range of Terraform versions. The VPC gets a map of tags with two keys, `Name` and `Project`. Either put that map on the resource, or set it once for every resource in the provider block.

## 6. Verify

| Command | Expected |
|---|---|
| `terraform init` | `Installed hashicorp/aws v6.72.0 (signed by HashiCorp)` |
| `terraform validate` | `Success! The configuration is valid.` |
| `terraform fmt -check -recursive` | No output, exit code 0 |
| `tflint --recursive --format compact; echo $?` | Exit code 0 |
| `trivy config . --severity HIGH,CRITICAL --exit-code 1` | Exit code 0 (the VPC flow-log finding is MEDIUM, so it does not fail CI) |
| `terraform plan` | `Plan: 1 to add, 0 to change, 0 to destroy.` and the name and tag visible in the plan |
| `aws ec2 describe-vpcs --filters Name=cidr,Values=10.0.0.0/16 --query 'Vpcs[].VpcId'` (read-only) | `[]` once destroyed |

## 7. Gotchas and mistakes

- **The instructor's README is on provider 5.x, but his video uses 6.x.** The README pins `>= 5.0` and `~> 5.0`. In the video he locks `~> 6.0`, which matches what I ran (6.72.0). A `~> 5.0` constraint copied from the README would block 6.x entirely.
- **The plan shows `region = "us-east-1"` on the VPC itself.** The video's docs page lists `region` as an optional argument of the resource, so this matches the video. I have not tested overriding it.
- **The video says `plan` only compares files with the state file and makes no API call.** Not quite: it failed at 23:19 with a credentials error, which means the provider already called AWS (to get the account identity) before planning. His credentials only allowed S3, and he predicted the VPC would fail on apply, not on plan. I did not test that.
- **The video says `aws configure` took its default region from `main.tf`.** I do not believe that: the AWS CLI does not read Terraform files. Unverified; I did not repeat it.
- **The video makes a new IAM user with long-lived access keys.** My Day 0 setup already has an IAM user on the default profile. Keys stay out of every file in this repo.
- **I mixed up the lock file with a state lock again** (also on Day 1). I said it "prevents requests from other developers" and that it locks both Terraform and the provider. It is a record of provider versions and checksums only; Terraform's own version is limited by `required_version`.
- **I swapped the two blocks at first.** I said the `provider "aws"` block sets the exact version. Versions belong to `required_providers`; the provider block holds settings such as the region.
- **My own `required_version` check caught a wrong Terraform.** My tool shell resolved the system Terraform 1.15.9, and `init` refused it because `~> 1.17` excludes it. Your terminal and CI use 1.17.1, so only that shell needed `mise exec --`.
- **First version broke three repo rules.** Code in the repo root instead of `sandbox/`; no `required_version`, so `tflint` exits 2 and CI would fail; and the VPC had no `tf30-` name and no `Project` tag (the destroy output shows `tags = {}`), so it would be impossible to tell from the console that it was mine. It was destroyed, so nothing is left behind.
- **Raw `destroy` output contains the account ID** inside the resource ARN. It must never be pasted into this repo. Quote output with the ID removed.
- **`trivy` reports a MEDIUM finding (AWS-0178, no VPC flow logs).** CI only fails on HIGH and CRITICAL, so this passes. Flow logs cost money and are out of scope for a throwaway VPC.

## 8. Cleanup

- [x] `terraform destroy` ran: `Destroy complete! Resources: 1 destroyed.` (my terminal output)
- [x] Console check that no `10.0.0.0/16` VPC is left over: the read-only `describe-vpcs` command printed `[]` (2026-11-06)

## 9. LinkedIn worth

Two candidates, both added to `docs/LINKEDIN-IDEAS.md`: the 5.x versus 6.x constraint trap (an old `~> 5.0` copied from a course blocks the current provider), and how my first working Terraform still failed my own CI. Nothing is posted until the course is finished.
