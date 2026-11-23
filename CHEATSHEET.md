# Cheatsheet

One line per command or concept learned so far, with the day it came from. For the reasoning behind each item, open that day's note. For rules of thumb and industry practices, see [TIPS.md](TIPS.md).

Add new lines in the same PR that finishes a day.

## Commands

| Command | What it does | Day |
|---|---|---|
| `terraform init` | Downloads providers, writes `.terraform.lock.hcl` and sets up the backend. Creates nothing in AWS. | 1 |
| `terraform fmt -recursive` | Formats every `.tf` file. Add `-check` to only report. | 1 |
| `terraform validate` | Checks syntax and types without calling AWS. Needs `init` first. | 1 |
| `terraform plan` | Shows the difference between config and state. Changes nothing. | 1 |
| `terraform apply` | Makes the changes in the plan after you type `yes`. | 1 |
| `terraform destroy` | Removes every resource the state file holds. | 1 |
| `terraform state list` | Lists the resource addresses in state. | 4 |
| `terraform state show <address>` | Shows one resource's recorded attributes. | 4 |
| `terraform state rm <address>` | Makes Terraform forget a resource. AWS is untouched. | 4 |
| `terraform state mv <from> <to>` | Renames an address in state without touching AWS. | 4 |
| `terraform plan -var 'name=value'` | Sets a variable for one run. Highest precedence. | 5 |
| `export TF_VAR_name=value` | Sets a variable from the environment. | 5 |
| `terraform output` | Prints outputs from state. Empty until something is applied. | 5 |
| `terraform graph` | Prints the dependency graph, one node per block. `A -> B` means B is created first. | 3, 8 |

## Concepts

| Concept | One line | Day |
|---|---|---|
| Infrastructure as code | Infrastructure described in files, reviewed and repeated like code. | 1 |
| Write, plan, apply | The core loop: write config, read the plan, apply it. | 1 |
| Lock file versus state file | `.terraform.lock.hcl` pins provider builds and is committed. `terraform.tfstate` records what exists and is never committed. | 1, 4 |
| `required_providers` versus `provider` block | The first says which provider and version to download; the second configures it (region, tags). | 2 |
| `~>` constraint | `~> 6.0` allows 6.x only, never 7.0. | 2 |
| `default_tags` | Provider-level tags added to every resource. A resource's own tag with the same key wins. | 2, 7 |
| Implicit dependency | A reference such as `aws_vpc.main.id` orders the two resources by itself. | 3 |
| Explicit dependency | `depends_on` forces an order when nothing in the code references the other resource. | 3, 8 |
| In-place change versus replace | A tag change is `1 to change`. An argument that cannot change in place forces destroy and create. | 3 |
| Desired, actual and recorded state | Config is what you want, AWS is what exists, state is what Terraform built last time. | 4 |
| S3 backend native locking | `use_lockfile = true` writes a `.tflock` object; no DynamoDB table needed (Terraform 1.10 and newer). | 4 |
| Variable precedence | default, then `TF_VAR_`, then `terraform.tfvars`, then `*.auto.tfvars`, then `-var` and `-var-file` last. | 5 |
| Input, local, output | Inputs come from outside, locals are computed inside, outputs are printed and stored in state. | 5 |
| File names do not matter | Terraform merges every `.tf` file in a directory; the names are for humans. | 6 |
| Conventional files | `versions.tf`, `provider.tf`, `variables.tf`, `locals.tf`, `main.tf`, `outputs.tf`. | 6 |
| Primitive types | `string`, `number`, `bool`. | 7 |
| `list` versus `set` | A list keeps order and duplicates. A set has neither, so it cannot be indexed until `tolist()`, which returns it sorted. | 7 |
| `map` versus `object` | A map has open-ended keys with one value type. An object has a fixed set of keys, each with its own type. | 7 |
| `tuple` | Fixed length and a type per position. | 7 |
| `validation` versus `precondition` | `validation` checks a variable's value. `precondition` sits in a `lifecycle` block and can also read resources and data sources. | 7 |
| Defaults are constants | A variable `default` cannot reference another variable or a local; build such values in `locals`. | 7 |
| `count` | Makes numbered copies (`[0]`, `[1]`). Removing an item from the middle shifts and replaces everything after it. | 8 |
| `for_each` | Makes copies keyed by a set or map. Removing one key removes only that copy; keys must be known at plan time. | 8 |
| Graph versus plan | The graph has one node per block; the plan counts instances after `count` and `for_each` expand. | 8 |
