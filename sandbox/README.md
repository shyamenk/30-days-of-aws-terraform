# Sandbox

First attempts for the concept days (Days 2 to 13), one folder per day. Each folder is its own root module with local state, so you can run `terraform init` and `terraform plan` in it on its own. Messy is fine here, but every folder still passes the repo gate (`fmt`, `validate`, `tflint`, `trivy`).

From Day 14 (the first project day) the work moves into `infra/` as modules and environments. See [infra/README.md](../infra/README.md).

| Folder | Day | What it holds | Applied? |
|---|---|---|---|
| `day-02-provider/` | 2 | One VPC with provider `default_tags` | Applied and destroyed |
| `day-03-s3/` | 3 | A VPC and a hardened bucket (public access block, KMS) linked by an implicit dependency | Applied, changed in place, destroyed |
| `day-04-remote-backend/` | 4 | S3 backend with native locking and a hardened demo bucket | Applied and destroyed. The state bucket it names is deleted; create a new versioned `tf30-` bucket before running `init` |
| `day-05-variables/` | 5 | Input variables, locals, outputs and a `terraform.tfvars.example` | Plan only |
| `day-06-structure/` | 6 | Day 5 split into `versions.tf`, `provider.tf`, `variables.tf`, `locals.tf`, `main.tf`, `outputs.tf` | Plan only |
| `day-07-types/` | 7 | Every type constraint, a precondition and a validation, an EC2 instance, a VPC, subnets and a security group | Plan only (the instance bills if applied) |
| `day-08-meta-arguments/` | 8 | `count`, `for_each` and `depends_on` buckets with a KMS key and per-bucket protections | Plan only (the KMS key bills if applied) |
| `day-09-lifecycle/` | 9 | `prevent_destroy` on a bucket, then a VPC and a security group for `create_before_destroy` with a fixed `name` and with `name_prefix` | Applied and destroyed, one task at a time (Tasks 1 to 3) |

Rules:

- One folder per day, named `day-NN-topic/`. Add a row to the table above in the same PR.
- Destroy anything you apply before you leave the folder, then check the console.
- Commit `.terraform.lock.hcl`; never commit state or `*.tfvars`.
