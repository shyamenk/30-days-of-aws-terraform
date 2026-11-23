# Day 10: conditionals, splat and dynamic blocks

Practice for the three expressions, built on the Day 9 layout with free resources only (a VPC, one security group and four subnets). Nothing here was applied, so nothing exists in AWS; every check was a plan or `terraform console`.

## What it shows

| Expression | Where | What to look for in the plan |
|---|---|---|
| Conditional value | `main.tf`, `aws_vpc.main` | `cidr_block` is `10.0.0.0/16` only for an exact `prod`, otherwise `10.1.0.0/16` |
| Conditional resource | `main.tf`, `aws_security_group.sg` | `count = var.create_sg ? 1 : 0`; `-var create_sg=false` drops the group |
| Safe output for an optional resource | `outputs.tf`, `sg_id` | `one(aws_security_group.sg[*].id)` gives the ID or `null`, never an error |
| Dynamic block | `main.tf`, `dynamic "ingress"` | One `ingress` rule per item of `var.ingress_rules`, read through `iterator = rule` |
| Splat on a `count` resource | `outputs.tf`, `count_subnet_ids` | `aws_subnet.count_subnets[*].id` |
| `for` expression on a `for_each` resource | `outputs.tf`, `for_each_subnet_ids` | A map of name to ID; a splat here fails, because a `for_each` resource is a map |

Subnet ranges come from `cidrsubnet(aws_vpc.main.cidr_block, 8, n)` (a Day 11 function), so they always fit inside the VPC. The ingress rules allow `10.1.0.0/16`, the `dev` range; in a `prod` plan they would still allow that range (a known limit, see the note).

## Files

| File | Holds |
|---|---|
| `versions.tf` | required Terraform version and the AWS provider constraint |
| `provider.tf` | the `aws` provider block, with the default tags |
| `variables.tf` | `environment`, `project`, `region`, `create_sg`, `ingress_rules` and `for_each_subnets` |
| `locals.tf` | the common tags |
| `main.tf` | the VPC, the security group with the dynamic block, and the `count` and `for_each` subnets |
| `outputs.tf` | `sg_id`, `count_subnet_ids` and `for_each_subnet_ids` |

## Checks

`terraform fmt -check`, `terraform validate`, `tflint` and the `trivy config` HIGH/CRITICAL gate pass. `terraform plan` shows `6 to add`; with `-var create_sg=false` it shows `5 to add`.
