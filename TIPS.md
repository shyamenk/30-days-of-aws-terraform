# Tips and best practices

Two lists. **From the course** are lessons I learned on a day and checked myself; each links to that day's note. **Industry practices** are widely used rules from the official docs, linked to the source. Some are taught later in the course; when I reach that day, I move the item up and link the note.

## From the course

### State and plan

- **Config vs state.** Config (your `.tf` files) is what you want. State (`terraform.tfstate`, written by Terraform after each apply) is what was created last time, with its real AWS IDs. A plan is the difference between them:

  ```
  in config, not in state  -> create   (+)
  in state, not in config  -> destroy  (-)
  in both, different       -> update   (~) or replace (-/+)
  in both, same            -> nothing
  ```

  Before the first apply the state is empty, so every plan only adds. ([Day 8](notes/week-02/day-08-meta-arguments.md))

- **Graph vs plan.** `terraform graph` draws one node per resource **block**. `terraform plan` counts **instances**, after `count` and `for_each` expand. On Day 8, 10 nodes became `16 to add`: four single blocks, plus six blocks with two instances each. Once resources exist, the plan counts only the instances that change. ([Day 8](notes/week-02/day-08-meta-arguments.md))

- **A plan does not show order.** It lists resources by address. To see the order, use `terraform graph` (`A -> B` means A depends on B, so B is created first) or watch the "Creating..." lines during an apply. ([Day 8](notes/week-02/day-08-meta-arguments.md))

### Ordering

- **Reference first, `depends_on` last.** If one resource references another, Terraform orders them by itself (implicit). If there is no reference but one resource still must exist first, force the order with `depends_on` (explicit). Prefer a reference when one is possible. ([Day 8](notes/week-02/day-08-meta-arguments.md))

### count and for_each

- **`count` list:** add or remove items only at the end. Removing from the start or middle replaces everything after it. ([Day 8](notes/week-02/day-08-meta-arguments.md))
- **`for_each` keys:** never rename a key casually. A new key means a new bucket, and the old one is destroyed. ([Day 8](notes/week-02/day-08-meta-arguments.md))

### Lifecycle rules

- **`prevent_destroy` rejects the whole plan, not one resource.** On Day 9, `plan -destroy` computed `4 to destroy` and then failed on the one protected bucket, so the three unprotected resources were not destroyed either. ([Day 9](notes/week-02/day-09-lifecycle-rules.md))
- **`prevent_destroy` lives in the code, not in state.** Remove the line and the very next `destroy` is allowed, with no apply in between. Delete the whole block and the resource is destroyed, because the rule went with it. For anything that must survive, add a guard that lives in AWS, such as RDS `deletion_protection`. ([Day 9](notes/week-02/day-09-lifecycle-rules.md))
- **`create_before_destroy` needs room for two copies.** With a fixed security group `name`, the replace failed with `InvalidGroup.Duplicate`. With `name_prefix`, AWS added a random suffix and the replace worked. ([Day 9](notes/week-02/day-09-lifecycle-rules.md))
- **A local called `prefix` is not a prefix.** `name = local.prefix` still sends one fixed name. Only the `name_prefix` argument makes AWS add the random part. Read the plan: `+ name_prefix = "..."` with `+ name = (known after apply)` is the shape you want. ([Day 9](notes/week-02/day-09-lifecycle-rules.md))
- **Create-first also protects you from a bad apply.** An invalid character in a description failed the create, and the old group kept running. With the default destroy-first order, nothing would have been left. ([Day 9](notes/week-02/day-09-lifecycle-rules.md))
- **A clean plan can still fail on apply.** Terraform does not know AWS rules such as unique names or allowed characters; only the apply finds them. ([Day 7](notes/week-02/day-07-type-constraints.md), [Day 9](notes/week-02/day-09-lifecycle-rules.md))

### Expressions

- **Make the risky case the explicit one.** `var.environment == "prod" ? prod_value : safe_value` sends a typo such as `Dev` to the safe side. Testing `== "dev"` instead sent `Dev` and `staging` to prod. ([Day 10](notes/week-02/day-10-conditionals-splat-dynamic.md))
- **A conditional's two results share one type.** `true ? 12 : "hello"` returns `"12"`, a string, whichever side comes first. Use `tostring()` to say it out loud. ([Day 10](notes/week-02/day-10-conditionals-splat-dynamic.md))
- **`count = var.flag ? 1 : 0` switches a resource on and off.** `count` needs a number and a `bool` never converts to one. Read the resource with `one(resource.name[*].attr)`, which gives the value or `null`; `[0]` errors when it is off. ([Day 10](notes/week-02/day-10-conditionals-splat-dynamic.md))
- **Splat walks lists, not maps.** `[*]` works on a `count` resource and fails on a `for_each` resource, because that is a map. Use `{ for k, v in resource.name : k => v.id }`. `validate` missed this; `plan` caught it. ([Day 10](notes/week-02/day-10-conditionals-splat-dynamic.md))
- **The console only sees the folder it starts in.** Started in the repo root, every `var.` was "undeclared". It also shows unapplied resource values as `(known after apply)`, so it cannot prove resource expressions; `plan` can. ([Day 10](notes/week-02/day-10-conditionals-splat-dynamic.md))

### Functions

- **Read the arguments, not the name.** `trim` only touches the ends, `substr`'s third argument is a length, and `formatdate` verbs are case-sensitive (`mm` is minutes). I got all three wrong by guessing. ([Day 11](notes/week-02/day-11-functions.md))
- **Trim before you convert.** `split(",", "80, 443")` keeps the space, and `tonumber(" 443")` fails. ([Day 11](notes/week-02/day-11-functions.md))
- **In `merge`, the last map wins.** Put defaults first and overrides last. ([Day 11](notes/week-02/day-11-functions.md))

## Industry practices

### Reading plans

- **Read the summary line before `yes`.** If `X to destroy` is not what you meant, stop. Search the plan for `must be replaced` and `forces replacement`.
- **Apply the plan you reviewed.** `terraform plan -out=tfplan` then `terraform apply tfplan` applies exactly that plan, not a new one that may differ. ([plan command](https://developer.hashicorp.com/terraform/cli/commands/plan))

### count, for_each and refactoring

- **Default to `for_each`.** Use `count` only for identical copies or an on/off switch (`count = 0` or `1`). ([count docs, "When to use for_each instead of count"](https://developer.hashicorp.com/terraform/language/meta-arguments/count))
- **Rename or restructure with `moved` blocks.** Renaming a resource, renaming a `for_each` key or switching from `count` to `for_each` changes addresses. A `moved` block tells Terraform it is the same resource, so nothing is destroyed. ([Refactoring](https://developer.hashicorp.com/terraform/language/modules/develop/refactoring))

### Lifecycle rules

- **Two layers for data that must never die.** `prevent_destroy` stops a Terraform plan; a setting in AWS (RDS `deletion_protection`, a bucket policy that denies `s3:DeleteBucket`, a backup) still holds when someone deletes the block or works outside Terraform. ([lifecycle](https://developer.hashicorp.com/terraform/language/meta-arguments/lifecycle), [aws_db_instance](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance))
- **Check the name rules before `create_before_destroy`.** Use the resource's `name_prefix` (or a random suffix) wherever the name must be unique. Terraform cannot turn that on for you. ([lifecycle, create_before_destroy](https://developer.hashicorp.com/terraform/language/meta-arguments/lifecycle))
- **Keep `ignore_changes` narrow.** List the exact attributes, down to one key with `tags["Owner"]`, and avoid `all`. Every ignored attribute is drift you will never see in a plan. ([lifecycle, ignore_changes](https://developer.hashicorp.com/terraform/language/meta-arguments/lifecycle))
- **`replace_triggered_by`: reference the resource, not `.id`, to react to any change.** An attribute fires only when its value changes, and an ID stays the same through an in-place update. To trigger from a variable, route it through `terraform_data`. ([lifecycle, replace_triggered_by](https://developer.hashicorp.com/terraform/language/meta-arguments/lifecycle), [terraform_data](https://developer.hashicorp.com/terraform/language/resources/terraform-data))
- **Validate inputs early, results late.** Use a variable `validation` when the rule only needs the input, a `precondition` when it needs other resources or data sources, and a `postcondition` on `self` to check what was really created. ([Custom conditions](https://developer.hashicorp.com/terraform/language/expressions/custom-conditions))
- **`-target` is for emergencies.** It narrows a plan to named resources, which is how you work around a blocked plan, but the docs advise against routine use because the rest of the configuration is not checked. ([plan, resource targeting](https://developer.hashicorp.com/terraform/cli/commands/plan#resource-targeting))
- **Comment every lifecycle rule.** Each one changes how Terraform treats a resource, so say why it is there; the next reader cannot tell from the plan.

### Expressions

- **Write nested blocks out literally where you can.** Use `dynamic` only when the number of blocks really varies; the docs warn that overuse makes configuration hard to read. ([Dynamic blocks](https://developer.hashicorp.com/terraform/language/expressions/dynamic-blocks))
- **Name the iterator.** `iterator = rule` reads better than the block label, and it is needed to tell nested dynamic blocks apart. ([Dynamic blocks](https://developer.hashicorp.com/terraform/language/expressions/dynamic-blocks))
- **Prefer separate security group rule resources.** The AWS provider advises against inline `ingress`/`egress` and recommends one `aws_vpc_security_group_ingress_rule` per rule; never mix the two styles on one group. ([aws_security_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group))
- **Cut subnets from the VPC range, not by hand.** `cidrsubnet(vpc_cidr, newbits, netnum)` keeps every subnet inside the VPC and free of overlaps. ([cidrsubnet](https://developer.hashicorp.com/terraform/language/functions/cidrsubnet))
- **Keep logic out of long conditionals.** One `? :` is readable; a chain of them belongs in a `locals` map lookup. ([Conditional expressions](https://developer.hashicorp.com/terraform/language/expressions/conditionals))

### Functions

- **Put function chains in `locals`.** One named local is readable, testable in `terraform console` and reused; the same chain inline in three resources drifts apart. ([Functions](https://developer.hashicorp.com/terraform/language/functions))
- **Reject bad input instead of silently fixing it.** A `validation` block with a clear message beats a `replace()` chain that hides a wrong value. ([Custom conditions](https://developer.hashicorp.com/terraform/language/expressions/custom-conditions))
- **Never put `timestamp()` in a resource argument.** The docs say it "will cause a diff to be detected on every Terraform run". Use `plantimestamp()` in an output or the Time provider. ([timestamp](https://developer.hashicorp.com/terraform/language/functions/timestamp))
- **Use a map index when every key must exist, `lookup` when it may not.** `var.sizes[var.env]` fails loudly on a missing environment; `lookup(var.sizes, var.env, "t3.micro")` falls back quietly. ([lookup](https://developer.hashicorp.com/terraform/language/functions/lookup))

### State

- **Remote state with locking for anything shared.** Keep state in a remote backend with locking so two applies cannot run at once. The S3 backend supports native locking with `use_lockfile = true`. (Day 4; [S3 backend](https://developer.hashicorp.com/terraform/language/backend/s3), [state locking](https://developer.hashicorp.com/terraform/language/state/locking))
- **State holds secrets in plain text.** Never commit it; encrypt the backend and limit who can read it. ([Sensitive data in state](https://developer.hashicorp.com/terraform/language/state/sensitive-data))
- **Never edit state by hand.** Use `terraform state mv`, `state rm` or `moved` and `import` blocks. ([state command](https://developer.hashicorp.com/terraform/cli/commands/state))

### Versions and code

- **Pin versions and commit the lock file.** Set `required_version` and provider constraints, and commit `.terraform.lock.hcl` so every machine and CI uses the same provider build. ([Version constraints](https://developer.hashicorp.com/terraform/language/expressions/version-constraints), [Dependency lock file](https://developer.hashicorp.com/terraform/language/files/dependency-lock))
- **Run the gate before every commit.** `terraform fmt`, `validate`, a linter (`tflint`) and a security scanner (`trivy config`) catch most mistakes before a plan. ([Style guide](https://developer.hashicorp.com/terraform/language/style))
- **No hardcoded account IDs, regions or secrets.** Pass them in as variables or read them with data sources, and mark secret variables `sensitive = true`. ([Style guide](https://developer.hashicorp.com/terraform/language/style))
- **Tag everything from one place.** The AWS provider's `default_tags` block applies tags to every resource, so nothing is missed. ([AWS provider, default_tags](https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block))
