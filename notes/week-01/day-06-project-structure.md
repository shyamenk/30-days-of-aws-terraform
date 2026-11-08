# Day 6: Project structure best practices

Video: [Terraform file structure](https://www.youtube.com/watch?v=QMsJholPkDY) (12 min) · Instructor code: [lessons/day06](https://github.com/piyushsachdeva/Terraform-Full-Course-Aws/tree/main/lessons/day06) (README and `task.md` only, no `code/` folder) · Verified against: Terraform 1.17.1, AWS provider 6.72.0 on 2026-11-08

Source material for this note: the video transcript, the instructor's README and `task.md`. The hands-on was plan-only (nothing applied).

## 1. Goal

After today I can split one Terraform configuration into separate files by purpose, say what each conventional file holds, and explain why the file names do not change how Terraform behaves.

## 2. Concepts

**Why split.** In Days 3 to 5 a lot lived in `main.tf`. The video says this was deliberate: start simple, then improve. One big file stops being readable once it holds the backend, the provider, variables, locals, resources and outputs together.

**Terraform does not care about file names.** In a directory, Terraform reads every file ending in `.tf` (and `.tf.json`) and merges them into one configuration. The video shows this by cutting the variables out of `main.tf`: the editor first reports undeclared variables, and the errors disappear as soon as `variables.tf` exists. Only the extension matters. The order of files, or of blocks inside them, does not decide the order in which resources are created; references between resources do that (Day 3).

**The conventional layout** (a recommendation from HashiCorp's style guide, not a rule):

```
 project-root/            <- the "root module": one directory you run terraform in
 ├── main.tf              resources (or split by service: s3.tf, vpc.tf, ec2.tf)
 ├── variables.tf         input variable declarations
 ├── locals.tf            local values
 ├── outputs.tf           output values
 ├── providers.tf         provider blocks
 ├── versions.tf          terraform { required_version, required_providers }
 ├── backend.tf           terraform { backend "s3" { ... } }
 ├── terraform.tfvars     real values (never published)
 ├── terraform.tfvars.example   template with the variable names (safe to publish)
 ├── .gitignore
 └── README.md
```

| File | Holds | Publish to GitHub? |
|---|---|---|
| `main.tf` | resource blocks | yes |
| `variables.tf` | `variable` blocks | yes |
| `outputs.tf` | `output` blocks | yes |
| `terraform.tfvars` | real values | **no** (can hold private data) |
| `terraform.tfvars.example` | names and sample values | yes |
| `.terraform/` | downloaded providers and metadata | **no** |
| `*.tfstate`, `*.tfstate.backup` | state | **no** (can hold secrets) |

**One catch from the video: the backend lives inside a `terraform` block.** When the instructor pasted the `backend "s3"` block alone into `backend.tf`, the editor flagged it. A backend setting is not a top-level block; it must sit inside `terraform { ... }`. So `backend.tf` and `versions.tf` both contain a `terraform` block, which is allowed. Terraform merges them.

**Splitting resources.** One file per resource type (`s3.tf`, `vpc.tf`, `ec2.tf`) is fine for small projects, but with hundreds of resources it becomes unmanageable. The answer to that is modules, which come later in the course.

**Two bigger layouts shown in the video (for awareness only).**

```
 A) One directory per environment        B) Same code, different values per environment
    envs/dev/     main.tf                   main code in the root (or modules/)
    envs/staging/ main.tf                   dev.tfvars, staging.tfvars, prod.tfvars
    envs/prod/    main.tf
    modules/networking, compute, security
```

The instructor says this is a lot for a beginner and promises a full end-to-end project later. Our repo already uses layout A in spirit (`infra/modules` and `infra/envs` in CLAUDE.md).

## 3. Docs to read

- [x] [Terraform style guide](https://developer.hashicorp.com/terraform/language/style) (file naming, ordering inside a block)
- [x] [Module structure](https://developer.hashicorp.com/terraform/language/modules/develop/structure) (the standard files of a module, and where a root module differs)

## 4. Challenge

The instructor's task: reorganise the Day 5 configuration into separate files. My Day 5 code in `sandbox/day-05-variables/` is already split into `provider.tf`, `variables.tf`, `locals.tf`, `main.tf`, `outputs.tf` and a tfvars example, so today is a smaller step than the instructor's. Make a copy as `sandbox/day-06-structure/` and finish the job there.

Acceptance criteria:

- [x] The `terraform` block (`required_version`, `required_providers`) is in its own `versions.tf`, and `provider.tf` holds only the `provider` block
- [x] Every file holds one kind of thing; no file mixes variables, locals and resources
- [x] `terraform fmt -check -recursive`, `terraform validate` and `tflint` pass in the new directory
- [x] `terraform plan` in the new directory shows the same resources and values as Day 5's plan (checked before the rename to Day 6 names). Moving code between files must change nothing
- [x] A short `README.md` in the directory says what each file is for
- [x] `git status` shows no `.terraform/`, state file or real `terraform.tfvars`, and the `.terraform.lock.hcl` is committed
- [x] Decide on a backend file: either add a `backend.tf` that points at a `tf30-` state bucket (you create the bucket, with versioning), or say in the README that this day stays on local state and why

## 5. Hints

Open one at a time, in order.

1. Nudge: the Terraform docs page on files and directories says which blocks may be repeated across files. Read how the `terraform` block is treated.
2. Narrower: copy first, then move one block at a time and run `terraform validate` after each move. A move that breaks validate tells you which reference you broke.
3. Last resort: the new `versions.tf` is just the `terraform` block that sits at the top of today's `provider.tf`, and `providers.tf` keeps what is left. Nothing about the resources changes.

## 6. Verify

| Command | Expected |
|---|---|
| `terraform fmt -check -recursive` | exit 0, no output |
| `terraform validate` | `Success! The configuration is valid.` |
| `tflint` | exit 0 |
| `terraform plan` | same number of resources to add as Day 5, same names and tags |
| `git status --short` | only the new directory's source files; no state, no `.terraform/`, no real tfvars |

Plan-only is enough for this day. Nothing here needs an apply.

Result on 2026-11-08: Day 5 and Day 6 both printed `Plan: 5 to add, 0 to change, 0 to destroy.` with identical resources and tags. After renaming to Day 6 names and the output to `bucket_name`, Day 6 printed the same count. `fmt`, `validate`, `tflint` and `trivy` pass.

## 7. Gotchas and mistakes

From the video and the instructor's README (found while comparing, not mistakes I made yet):

- **Backend outside a `terraform` block.** The editor flags a bare `backend "s3"` block. It has to be inside `terraform { ... }`.
- **Variables look undefined until the new file exists.** After cutting variables out of `main.tf`, the editor reports unresolved references. This is an editor timing issue, not a real error; `terraform validate` is the source of truth.
- **The README says files are loaded "in lexicographical order".** That is true of how Terraform reads them but misleading: the order does not change the result. Do not rely on file order for anything.
- **The README's `locals.tf` uses `timestamp()`** in the common tags (`CreatedDate`). `timestamp()` returns a different value on every run, so every plan would show a tag change. Avoid it in tags.
- **The README's `backend.tf` uses `dynamodb_table`** for locking and an old AWS provider (`~> 5.0`). Our Day 4 code uses S3 native locking and provider `~> 6.0`, so we follow our own pins.
- **The README sets a `Project` tag to "TerraformLearning"** in the tfvars. Ours must be `30-days-of-aws-terraform`, with names starting `tf30-`.
- **The video's `.gitignore` ignores "anything that starts with terraform".** That pattern would also hide `terraform.tfvars.example`, which we want to commit. Our repo `.gitignore` already handles this with an `!*.tfvars.example` exception, and it keeps `.terraform.lock.hcl` tracked.

My own mistakes from the Q&A (2026-11-08):

- **Q1, rename `main.tf`:** I said nothing changes but gave no reason. Reason: Terraform merges every `.tf` file into one configuration and never sees which file a block came from. The name must still end in `.tf`. (Claude's wording; restate before any post.)
- **Q4, `terraform.tfvars`:** I said it "lives in the shell". It is a normal file on disk, kept out of GitHub only by `.gitignore`. I skipped the catch: the video's "starts with terraform" pattern also hides `terraform.tfvars.example`. Our repo uses `*.tfvars` plus `!*.tfvars.example`. (Claude's wording; restate.)
- **Q5, moving a block to another file:** I said I must "call" the new file from `main.tf`. No: all `.tf` files load automatically; calling only applies to modules. State tracks the resource address (type plus label), not the file, so the plan shows no changes. Renaming the label would plan a destroy and a create. (Claude's wording; restate.)
- **Q3 and Q6:** right, with small gaps. Duplicate settings across `terraform` blocks (two `backend` blocks) are an error. The single codebase follows DRY; I wrote "avoid dry".

## 8. Cleanup

- [x] Nothing to destroy: only `plan` was run
- [x] Not applicable, no backend bucket was created: if one were, empty it: empty it (all versions), delete it, and confirm with a 404 on a head-bucket check
- [x] Billing check not needed for plan-only work

## 9. LinkedIn worth

Possibly: "Terraform doesn't care what your files are called; only the `.tf` extension matters. The file names are for the humans." Strength 2, since it is well known. Also the `timestamp()` tag trap (every plan shows a diff). Both are added to `docs/LINKEDIN-IDEAS.md`.
