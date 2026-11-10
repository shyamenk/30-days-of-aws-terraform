# Day 7: type constraints

Practice for Terraform's variable type constraints, built on the Day 6 layout. It declares EC2 instances, a VPC and two subnets, all driven by typed input variables (count, instance type, AMI, monitoring and public IP flags, a list of CIDR ranges, and two allow-lists). Nothing here has been applied, so nothing exists in AWS. An applied EC2 instance bills while it exists, so keep this plan-only unless you plan to destroy it straight after.

## Type constraints used so far

| Variable | Type | Used for |
|---|---|---|
| `environment` | `string` | name prefix and the `Environment` tag |
| `region` | `string` | provider region |
| `project` | `string` | the `Project` tag |
| `ec2_instance_type` | `string` | instance type |
| `ami` | `string` | AMI ID (region-specific, so it is an input, not hard-coded) |
| `ec2_instance_count` | `number` | `count` on the instance (default `1`) |
| `monitoring_enabled` | `bool` | detailed monitoring flag (default `true`) |
| `associate_public_ip` | `bool` | whether each instance gets a public IPv4 address (default `false`) |
| `cidr_blocks` | `list(string)` | entry 0 is the VPC range, entries 1 and 2 are the two subnets (default `10.0.0.0/16`, `10.0.1.0/24`, `10.0.2.0/24`) |
| `allowed_vm_types` | `list(string)` | allow-list of instance types; a `precondition` on the instance checks `ec2_instance_type` is in it |
| `tags` | `map(string)` | the whole map is the VPC's `tags`; defaults are literals (a default cannot read other variables) |
| `ingress_values` | `tuple([number, string, number])` | start port, protocol and end port of the one ingress rule, read by index (default `[443, "tcp", 443]`) |
| `allowed_region` | `set(string)` | allow-list of regions; a `validation` on `region` checks the value is in it |

Tasks 1 to 8 (string, number, bool, two lists, a set, a map, a tuple) are in place. Still to add from the Day 7 assignments: an `object` variable and the `deployment_summary` output. See `notes/week-01/day-07-type-constraints.md`, section 4.

## Files

| File | Holds |
|---|---|
| `versions.tf` | `terraform` block: required Terraform version and the AWS provider constraint |
| `provider.tf` | the `aws` provider block, with the default tags |
| `variables.tf` | typed input variables |
| `locals.tf` | the name prefix (`tf30-day07-<environment>`) and the common tags |
| `main.tf` | the `aws_instance`, the `aws_vpc`, a security group with one ingress rule, and two `aws_subnet` resources (labelled public and private, but with no internet gateway or route table they are only labels) |
| `outputs.tf` | `vpc_name`, the `Name` key read from the `tags` map |
| `terraform.tfvars.example` | variable names with sample values; copy to `terraform.tfvars` (git-ignored) and edit |

## State

Local state, no `backend.tf`, for the same reason as Day 6: nothing is applied, so a remote backend would only add a bucket to create and delete.

## Using it

Copy `terraform.tfvars.example` to `terraform.tfvars`. `ec2_instance_type` and `ami` have no defaults, so they must be set there or Terraform prompts for them. The other variables have defaults. Pick an AMI that exists in the region you use.

```
terraform init
terraform fmt -check -recursive
terraform validate
tflint
trivy config .
terraform plan
```

## Known issue

`trivy config .` still reports one MEDIUM finding: the VPC has no flow logs (AWS-0178). The CI gate only fails on HIGH and CRITICAL, so it passes. Flow logs need a log group and an IAM role, which is more than this type-constraints exercise needs, and nothing here is applied. The two HIGH findings (IMDS token, unencrypted root disk) are fixed with `metadata_options` and `root_block_device` on the instance.
