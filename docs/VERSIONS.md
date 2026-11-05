# Versions

Checked on **2026-11-05** against the official sources below. Re-check at the start of each week (commands at the bottom).

| Tool | Pinned here | Latest on 2026-11-05 | Your machine | Source |
|---|---|---|---|---|
| Terraform | 1.17.1 | 1.17.1 (released 2026-10-28) | 1.17.1 installed with mise on 2026-11-05. A plain `terraform` outside mise may still resolve to the older 1.15.9, so check `which terraform` inside this repo | [releases.hashicorp.com](https://releases.hashicorp.com/terraform/), [HashiCorp checkpoint API](https://checkpoint-api.hashicorp.com/v1/check/terraform) |
| AWS provider | `~> 6.0`, lock file records the exact version | 6.72.0 (released 2026-11-04) | n/a. AWS CLI is aws-cli 2.37.9 | [Registry](https://registry.terraform.io/providers/hashicorp/aws/latest) |
| TFLint | 0.65.0 | 0.65.0 (2026-10-22) | 0.65.0 installed with mise | [GitHub releases](https://github.com/terraform-linters/tflint/releases) |
| Trivy | 0.76.1 | 0.76.1 (2026-10-21) | 0.76.1 installed with mise | [GitHub releases](https://github.com/aquasecurity/trivy/releases) |
| OpenTofu | not used | 1.13.8 | n/a | [GitHub releases](https://github.com/opentofu/opentofu/releases) |

GitHub Actions used in CI: `actions/checkout` v7, `hashicorp/setup-terraform` v4, `terraform-linters/setup-tflint` v6, `aquasecurity/trivy-action` v0.36.0. Tags were the latest releases on 2026-11-05. Pin to commit SHAs once the repo has real activity.

## Why the course may not match these versions

The instructor's repo states no versions and was last pushed on 2026-04-27. The videos were recorded earlier still. Expect small differences: renamed arguments, deprecated resources (for example, S3 website and ACL settings moved into separate resources in provider 4.x and later), and new defaults. When the video and the docs disagree, the docs for your pinned version win. Write the difference in the day's Gotchas section.

## Install pinned tools

```
mise install        # reads .mise.toml
terraform version   # should print v1.17.1
```

## Re-check commands

```
curl -s https://checkpoint-api.hashicorp.com/v1/check/terraform | jq -r .current_version
curl -s https://registry.terraform.io/v1/providers/hashicorp/aws | jq -r '.version, .published_at'
gh api repos/terraform-linters/tflint/releases/latest --jq .tag_name
gh api repos/aquasecurity/trivy/releases/latest --jq .tag_name
```

When a version moves, change `.mise.toml`, `.github/workflows/ci.yml` and this table in one PR.
