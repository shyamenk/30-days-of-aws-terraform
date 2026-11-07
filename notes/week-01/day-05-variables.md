# Day 5: Input variables, locals and outputs

Video: [Terraform variables](https://www.youtube.com/watch?v=V-2yC39BONc) (37 min) · Instructor code: [lessons/day05](https://github.com/piyushsachdeva/Terraform-Full-Course-Aws/tree/main/lessons/day05) (README, task and `code/` with `variables.tf`, `locals.tf`, `main.tf`, `output.tf`, `provider.tf`) · Verified against: Terraform 1.17.1, AWS provider 6.72.0 on 2026-11-07

Source material for this note: the video transcript, my own key notes, the instructor's README and `task.md`, and the current Terraform docs for variable precedence. The hands-on was done as plan-only (no apply), by my choice.

## 1. Goal

After today I can pull repeated values out of my code with input variables and locals, print values with outputs, and say which value wins when a variable is set in more than one place.

## 2. Concepts

**The problem variables solve.** The video starts with one file holding a bucket, a VPC and an EC2 instance, all tagged `Environment = "dev"`. The same literal repeats in every resource. Changing to staging means editing every one, and one typo (`staging` in one place) leaves the file inconsistent. A variable holds the value once.

**Two ways to sort variables.**

```
 By purpose:  input (I set it)   local (computed inside the code)   output (printed or passed on)
 By value:    primitive: string, number, bool
              complex:   list, set, map, object, tuple
              special:   any (let Terraform infer the type), null (no value)
```

**Input variable.** Declared once with a `variable` block, read everywhere as `var.<name>`.

| Part | Meaning |
|---|---|
| `variable "environment" { ... }` | The label is the local name. I read it as `var.environment`, never as `var.dev` |
| `default` | Used when nothing else sets the value |
| `type` | Optional. The video: leaving it out is the same as `any`, and Terraform infers it from the value |

**Using a variable inside a string.** A variable on its own is `var.environment`. Inside a quoted string with other text, the value has to be resolved first, so it is written `"${var.environment}-bucket"`. Plain `var.environment` inside quotes would be literal text.

**Local value.** A `locals` block (plural) defines named values computed once from variables, other locals or resource attributes. I read them as `local.<name>` (singular). The video builds a bucket name from the channel name, the environment and a suffix, then uses `local.bucket_name` in the bucket and its tag. Use a local for a value I derive; use a variable for a value I want to supply from outside.

**Output.** An `output` block prints a value after `apply` and makes it available to other configurations. The video prints the VPC id and the instance id, which exist only after creation, so `plan` shows them as unknown.

| Command | What it shows |
|---|---|
| `terraform output` | All outputs from the state, without applying again |
| `terraform output vpc_id` | One output |
| `terraform output -json` | All outputs as JSON |

`terraform show` is a different command: it prints the state.

**Which value wins** (lowest to highest; checked against the Terraform docs on 2026-11-07):

| Order | Source | Note |
|---|---|---|
| 1 (lowest) | `default` in the variable block | |
| 2 | Environment variable `TF_VAR_<name>` | e.g. `export TF_VAR_environment=stage` |
| 3 | `terraform.tfvars` | Loaded automatically |
| 4 | `terraform.tfvars.json` | Loaded automatically |
| 5 | `*.auto.tfvars` and `*.auto.tfvars.json` | Loaded automatically, in alphabetical order |
| 6 (highest) | `-var` and `-var-file` on the command line | In the order given |

If no source sets the value and there is no default, Terraform asks for it at the prompt. The video proves the order with `plan`: `default` gave `dev`, the environment variable changed it to `stage`, a `terraform.tfvars` changed it to `pre-prod`, and `-var="environment=prod"` changed it to `prod`.

**Which source to use** (the instructor's view, with this repo's rule added):

| Case | Use |
|---|---|
| A value that rarely changes | `default` |
| Per-environment values (`dev.tfvars`, `prod.tfvars`) | A `.tfvars` file with `-var-file` |
| Something I pass for one run | `-var` |
| A secret | Never a committed file. An environment variable lands in shell history; the instructor suggests a secret manager |

This repo's `.gitignore` blocks `*.tfvars`, so a real `.tfvars` file stays local. I commit a `*.tfvars.example` with fake values instead. A variable marked `sensitive = true` hides its value in plan output, but the value is still stored in the state file.

**Code layout from the instructor's folder.** `variables.tf` for inputs, `locals.tf` for locals, `output.tf` for outputs, `main.tf` for resources and `provider.tf` for the provider. Terraform reads every `.tf` file in the folder, so the names are convention, not rules. Day 6 covers layout properly.

### Variable types, from my key notes

| Type | Purpose | Example |
|---|---|---|
| `string` | Text | `"t3.micro"` |
| `number` | Numbers | `2`, `80` |
| `bool` | True or false | `true` |
| `list` | Ordered collection | `["a", "b"]` |
| `set` | Unique collection, no order | `["dev", "prod"]` |
| `map` | Key and value pairs | `{ dev = "t3.micro" }` |
| `object` | Structured data with named, typed fields | `{ name = "web", size = 2 }` |
| `tuple` | Fixed-length collection with mixed types | `["web", 2, true]` |

The video says these are covered in a later video. My plan is Day 7.

### Passing values, from my key notes

```
terraform.tfvars          instance_type = "t3.small"
command line              terraform apply -var="instance_type=t3.small"
environment variable      export TF_VAR_instance_type="t3.small"
per environment           terraform plan -var-file="dev.tfvars"
```

### What I can now explain (checked in a Q&A, 2026-11-07)

- [x] **Input, local, output:** a variable is an external input; a local is an internal shortcut that avoids repetition; an output prints a value (and passes it on) after creation.
- [x] **`${...}` in strings:** inside a string with other text, `${var.x}` resolves the value and joins it; a reference on its own needs no braces.
- [x] **Unknown outputs:** `plan` shows `(known after apply)` for the VPC id because it does not exist until the VPC is created; it appears after `apply` or with `terraform output`.
- [x] **`-var`:** applies to one run only and is not saved in a file.
- [x] **Which value wins:** `terraform.tfvars` beats `TF_VAR_`, which beats `default`; `-var` and `-var-file` are highest because they are the explicit per-run choice. (Claude's wording; I accepted it on 2026-11-07 without restating it)
- [x] **Secrets:** a `terraform.tfvars` is plain text that is easy to commit and stays in Git history, so this repo ignores `*.tfvars`; `-var` and `export` land in shell history, so real secrets belong in a secret manager. (Claude's wording, accepted)

## 3. Docs to read

- [ ] [Input variables](https://developer.hashicorp.com/terraform/language/values/variables) (the "Variable definition precedence" section, and what `type`, `default` and `sensitive` do)
- [ ] [Output values](https://developer.hashicorp.com/terraform/language/values/outputs) (the `value` and `description` arguments)
- [ ] [Local values](https://developer.hashicorp.com/terraform/language/values/locals) (when a local is better than a variable)
- [ ] [`aws_vpc` attributes](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc) (which attributes an output can read)

## 4. Challenge

The instructor's `task.md` asks only for the video notes plus a blog and public posts, which this repo skips until the course ends. The README has practice steps. I will design a small version myself that costs nothing:

- [x] The code is in `sandbox/day-05-variables/` with `provider.tf`, `variables.tf`, `locals.tf`, `main.tf`, `outputs.tf` and `terraform.tfvars.example`
- [x] Four input variables (`environment`, `region`, `project`, `bucket_suffix`), each with a `type`, a `description` and a `default`; the provider uses `var.region`
- [x] `locals.tf` builds `name_prefix` (`tf30-day05-<environment>`), `bucket_name` (prefix plus the suffix variable) and the shared `common_tags` map
- [x] The shared tag map reaches every resource through the provider's `default_tags`; each resource adds only its own `Name`
- [x] Two outputs with descriptions: the VPC id and the bucket name (the bucket output reads the `bucket` attribute, not `bucket_namespace`)
- [x] Precedence proved with `plan` only (2026-11-07), looking at the bucket name: default gave `tf30-day05-dev-p4w9n7`; `TF_VAR_environment=stage` gave `...-stage-...`; a local `terraform.tfvars` with `pre-prod` gave `...-pre-prod-...`; and `-var="environment=prod"` gave `...-prod-...`. Each source beat the one before it. Not yet shown in one run: `TF_VAR_` against `terraform.tfvars` together (the ladder says the file wins)
- [x] `terraform.tfvars.example` holds `name = value` lines with working example values; the real `terraform.tfvars` is git-ignored
- [x] `terraform fmt -check`, `validate`, `tflint` and `trivy` HIGH/CRITICAL all pass on the folder
- [x] I chose not to apply (2026-11-07), so there is nothing to destroy and no console check. The hands-on is plan-only; the outputs and `terraform output` were not exercised against real resources
- [x] Q&A done 2026-11-07. Two of the answers are Claude's wording that I accepted; I should restate them in my own words before posting anything about Day 5

No EC2 instance today: the video's EC2 step needed extra IAM permissions and an AMI, and a running instance bills until destroyed.

**Q&A questions:**

1. What is the difference between an input variable, a local and an output? Give one use for each.
2. Why do I write `"${var.environment}-bucket"` in a string but plain `var.environment` on its own?
3. A variable has a default of `dev`, `TF_VAR_environment=stage` is exported and a `terraform.tfvars` says `pre-prod`. Which value is used, and why?
4. What makes `-var` the highest source, and why should a secret not live in `terraform.tfvars`?
5. Why can `plan` not show the VPC id output, and when does it appear?

## 5. Hints

Open one at a time, in order.

1. Nudge: the Day 5 instructor folder has `variables.tf`, `locals.tf`, `output.tf` and `main.tf`. Read them only after you try, as a comparison.
2. Narrower: a variable is read with `var.`, a local with `local.` (singular), and a locals block is written `locals` (plural). A tag map in a local can be reused with the `tags` argument of any resource.
3. Last resort, in words only: put the shared tags in one local, set `tags` on each resource from it, and let the provider's `default_tags` carry `Project`. To test precedence, export `TF_VAR_environment`, then create a `terraform.tfvars` in the folder, then add `-var` to the plan, and look at which value the plan prints.

## 6. Verify

| Command | Expected |
|---|---|
| `terraform init` | `Installed hashicorp/aws v6.72.0 (signed by HashiCorp)` |
| `terraform validate` | `Success! The configuration is valid.` |
| `terraform plan` | Shows the default environment in the bucket name and tags |
| `TF_VAR_environment=stage terraform plan` | Shows `stage` in place of the default |
| `terraform plan -var="environment=prod"` | Shows `prod`, even with `terraform.tfvars` present |
| `terraform output` | Prints the bucket name and the VPC id after apply |
| Console check after destroy | No `tf30-` bucket or VPC left |

## 7. Gotchas and mistakes

- **`aws_ec2_instance` does not exist.** The video's editor assistant suggested it and `plan` failed with "invalid resource type". The right type is `aws_instance`. The instructor's point: do not depend on an assistant, and look the type up in the provider docs.
- **A reference to something that was never declared fails.** `aws_subnet.sample.id has not been declared` appeared because the instance referred to a subnet resource that did not exist in the file.
- **`plan` did not catch the bad AMI id.** The error came at `apply`, when AWS was called. A clean plan does not prove the values are valid in AWS.
- **The video widened the IAM user's permissions to make EC2 work** by adding it to an admin group. For this course I keep the user on least privilege, which is one more reason not to use EC2 today.
- **The video calls `null` a type.** In Terraform `null` is a value that means "no value". `any` is the special type constraint. Setting `default = null` makes a variable optional.
- **The video's `terraform output show` failed.** `show` belongs to `terraform show`. The command is just `terraform output`.
- **The instructor suggests committing `terraform.tfvars` for non-sensitive values, and the README keeps one in `code/`.** This repo ignores `*.tfvars`, so I commit a `.example` file instead.
- **The README title says "Day 5/28".** The course has 30 days.
- **A wrong argument can hide while the folder has no resources.** I put `tags = local.common_tags` directly in the `provider "aws"` block. `validate` and `plan` both passed because `main.tf` was empty, but a plan with one resource failed with `Unsupported argument. An argument named "tags" is not expected here.` Provider tags belong in a `default_tags` block. A passing check on an empty folder proves little.
- **Changing a variable's default is not a way to change a prefix.** I set `project = "tf30-"` to get the prefix, which made the `Project` tag `tf30-` and the prefix `tf30--dev`. The tag value and the name prefix are separate things.
- **I read the wrong attribute for the bucket output.** `bucket_namespace` is `global`, not the bucket name. The plan could not show the mistake because both values were unknown.
- **A plan does not check bucket-name rules.** An example suffix with spaces (`some random value`) planned cleanly as `tf30-day05-dev-some random value`; AWS would reject it only at apply.
- **Hints-only exceptions on Day 5.** At my request Claude rewrote `variables.tf`, `locals.tf` and `main.tf` (including the Trivy fixes), fixed `outputs.tf`, and rewrote `terraform.tfvars.example`.
- **A bare bucket fails `trivy` again** (the same five HIGH findings as Days 3 and 4), so the folder includes a public access block, a KMS key and an encryption configuration.
- **Q&A first attempt (2026-11-07) had two gaps.** I answered "command line wins, then tfvars" to a question about default, `TF_VAR_` and `terraform.tfvars` (the answer is the `terraform.tfvars` value, `pre-prod`). And I explained `-var` as per-run but not why it is the highest source, and gave no reason a secret should stay out of `terraform.tfvars`.
- **Raw plan and apply output can contain the account ID in ARNs.** Never paste it into this repo.

## 8. Cleanup

- [x] Not needed: nothing was applied, so nothing was created in AWS
- [x] Not needed (see above)
- [x] The local `terraform.tfvars` is git-ignored (`.gitignore` line 17), so it is never committed

## 9. LinkedIn worth

Candidates, added to `docs/LINKEDIN-IDEAS.md`: the six-step variable precedence ladder, and an assistant inventing a resource type that does not exist (`aws_ec2_instance`) while the video says to read the provider docs. Nothing is posted until the course is finished.
