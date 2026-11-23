# Day 9: lifecycle rules

Practice for the `lifecycle` meta-argument, applied and destroyed one task at a time. The day was closed after Task 3 by my choice; `ignore_changes`, `replace_triggered_by`, `precondition` and `postcondition` were not practised here. Nothing is left in AWS (the Task 1 KMS key is in `PendingDeletion`, which AWS finishes on its own).

## What it showed

| Task | Code | Result |
|---|---|---|
| 1. `prevent_destroy` | A hardened bucket with a KMS key (removed after the task; the note keeps the record) | `plan -destroy` failed with `Instance cannot be destroyed`, and the whole plan was rejected. Removing the rule allowed the destroy with no apply in between |
| 2. `create_before_destroy` with a fixed `name` | A VPC and a security group named `tf30-day09-web` | A description change planned `+/-` and the apply failed with `InvalidGroup.Duplicate`. The old group was untouched |
| 3. `create_before_destroy` with `name_prefix` | The code in this folder | The replace succeeded with a new random suffix. A `~` in the description failed AWS validation first, and the old group survived that too |

Details, errors and mistakes are in `notes/week-02/day-09-lifecycle-rules.md`.

## Files

| File | Holds |
|---|---|
| `versions.tf` | required Terraform version and the AWS provider constraint |
| `provider.tf` | the `aws` provider block, with the default tags |
| `variables.tf` | `environment`, `project` and `region` |
| `locals.tf` | the common tags and the security group name prefix |
| `main.tf` | the VPC and the security group with `name_prefix` and `create_before_destroy` |

## Checks

`terraform fmt -check`, `terraform validate`, `tflint` and the `trivy config` HIGH/CRITICAL gate pass. Against empty state, `terraform plan` shows `2 to add`.
