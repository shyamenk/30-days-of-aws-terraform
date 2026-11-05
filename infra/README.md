# infra

The production-style codebase that grows through the course.

```
modules/   reusable, versioned building blocks. No hardcoded regions, accounts or environment names.
envs/dev   root module for dev: backend config, provider config, calls modules
envs/prod  root module for prod, same modules with different inputs
```

Rules for everyone working here:

- Remote state in S3 with locking, one state per environment. Never commit state.
- Every module has `variables.tf`, `outputs.tf`, `main.tf` and a README with inputs and outputs.
- Pin `required_version` and provider versions. Commit `.terraform.lock.hcl`.
- Tag every resource (`Project`, `Environment`, `Owner`, `ManagedBy = "terraform"`).
- No secrets in code. Use a profile, SSO, or a secrets manager.
- Least-privilege IAM, encryption on by default, no public access unless the task says so.

Empty until about Day 5 to 8.
