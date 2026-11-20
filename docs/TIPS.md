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

  Before the first apply the state is empty, so every plan only adds. ([Day 8](../notes/week-02/day-08-meta-arguments.md))

- **Graph vs plan.** `terraform graph` draws one node per resource **block**. `terraform plan` counts **instances**, after `count` and `for_each` expand. On Day 8, 10 nodes became `16 to add`: four single blocks, plus six blocks with two instances each. Once resources exist, the plan counts only the instances that change. ([Day 8](../notes/week-02/day-08-meta-arguments.md))

- **A plan does not show order.** It lists resources by address. To see the order, use `terraform graph` (`A -> B` means A depends on B, so B is created first) or watch the "Creating..." lines during an apply. ([Day 8](../notes/week-02/day-08-meta-arguments.md))

### Ordering

- **Reference first, `depends_on` last.** If one resource references another, Terraform orders them by itself (implicit). If there is no reference but one resource still must exist first, force the order with `depends_on` (explicit). Prefer a reference when one is possible. ([Day 8](../notes/week-02/day-08-meta-arguments.md))

### count and for_each

- **`count` list:** add or remove items only at the end. Removing from the start or middle replaces everything after it. ([Day 8](../notes/week-02/day-08-meta-arguments.md))
- **`for_each` keys:** never rename a key casually. A new key means a new bucket, and the old one is destroyed. ([Day 8](../notes/week-02/day-08-meta-arguments.md))

## Industry practices

### Reading plans

- **Read the summary line before `yes`.** If `X to destroy` is not what you meant, stop. Search the plan for `must be replaced` and `forces replacement`.
- **Apply the plan you reviewed.** `terraform plan -out=tfplan` then `terraform apply tfplan` applies exactly that plan, not a new one that may differ. ([plan command](https://developer.hashicorp.com/terraform/cli/commands/plan))

### count, for_each and refactoring

- **Default to `for_each`.** Use `count` only for identical copies or an on/off switch (`count = 0` or `1`). ([count docs, "When to use for_each instead of count"](https://developer.hashicorp.com/terraform/language/meta-arguments/count))
- **Rename or restructure with `moved` blocks.** Renaming a resource, renaming a `for_each` key or switching from `count` to `for_each` changes addresses. A `moved` block tells Terraform it is the same resource, so nothing is destroyed. ([Refactoring](https://developer.hashicorp.com/terraform/language/modules/develop/refactoring))
- **Protect what must never die.** `lifecycle { prevent_destroy = true }` makes any plan that would destroy the resource fail. (Day 9; [lifecycle](https://developer.hashicorp.com/terraform/language/meta-arguments/lifecycle))

### State

- **Remote state with locking for anything shared.** Keep state in a remote backend with locking so two applies cannot run at once. The S3 backend supports native locking with `use_lockfile = true`. (Day 4; [S3 backend](https://developer.hashicorp.com/terraform/language/backend/s3), [state locking](https://developer.hashicorp.com/terraform/language/state/locking))
- **State holds secrets in plain text.** Never commit it; encrypt the backend and limit who can read it. ([Sensitive data in state](https://developer.hashicorp.com/terraform/language/state/sensitive-data))
- **Never edit state by hand.** Use `terraform state mv`, `state rm` or `moved` and `import` blocks. ([state command](https://developer.hashicorp.com/terraform/cli/commands/state))

### Versions and code

- **Pin versions and commit the lock file.** Set `required_version` and provider constraints, and commit `.terraform.lock.hcl` so every machine and CI uses the same provider build. ([Version constraints](https://developer.hashicorp.com/terraform/language/expressions/version-constraints), [Dependency lock file](https://developer.hashicorp.com/terraform/language/files/dependency-lock))
- **Run the gate before every commit.** `terraform fmt`, `validate`, a linter (`tflint`) and a security scanner (`trivy config`) catch most mistakes before a plan. ([Style guide](https://developer.hashicorp.com/terraform/language/style))
- **No hardcoded account IDs, regions or secrets.** Pass them in as variables or read them with data sources, and mark secret variables `sensitive = true`. ([Style guide](https://developer.hashicorp.com/terraform/language/style))
- **Tag everything from one place.** The AWS provider's `default_tags` block applies tags to every resource, so nothing is missed. ([AWS provider, default_tags](https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block))
