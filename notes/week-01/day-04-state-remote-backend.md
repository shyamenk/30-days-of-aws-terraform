# Day 4: Terraform state and the S3 remote backend

Video: [Terraform state and remote backend](https://www.youtube.com/watch?v=YsEdrl9O5os) (17 min) · Instructor code: [lessons/day04](https://github.com/piyushsachdeva/Terraform-Full-Course-Aws/tree/main/lessons/day04) (README, task, `main.tf` and `test.sh` in `code/`) · Verified against: Terraform 1.17.1, AWS provider 6.72.0 on 2026-11-07

Source material for this note: the video transcript, my key notes, the instructor's README and `task.md`, my own terminal output, and read-only AWS CLI checks of the backend bucket. Where the video or my code does not hold up, it is in section 7.

## 1. Goal

After today I can explain what the state file is and why it must not live on a laptop, set up an S3 remote backend with native locking and versioning, and use the `terraform state` commands safely.

## 2. Concepts

**Desired state versus actual state.** The `.tf` files are the *desired* state: what I want to exist. The cloud account is the *actual* state: what exists. `apply` changes the actual state until it matches the desired one. My own insight, checked: the desired state is the authority, and the real world follows it. If someone edits a resource in the console (drift), the next `apply` puts it back to what the code says. The exceptions are deliberate: `ignore_changes`, `-refresh-only`, and `import`.

**The state file is the memory in between.** Terraform cannot ask AWS about every resource on every run, so it keeps `terraform.tfstate`: a JSON record of what it built, with every attribute AWS returned. A plan reads the state, refreshes it against AWS, then compares it with my code. The state holds secrets and ARNs, so it never goes into Git.

```
 main.tf (desired) ──┐
                     ├─► terraform plan ─► diff ─► apply ─► AWS (actual)
 state (memory) ◄────┘                                         │
        ▲                                                      │
        └────────────── refresh reads AWS ◄────────────────────┘
```

**Lock file versus state file** (the difference I asked about).

| | `.terraform.lock.hcl` | `terraform.tfstate` |
|---|---|---|
| Records | Which provider version and checksums to use | Which resources Terraform built and their attributes |
| Example line | `hashicorp/aws` pinned to `6.72.0` | `aws_s3_bucket.example` has id `tf30-day03-...` |
| Answers | "Which tools?" | "Which things?" |
| In Git? | Yes | Never |
| Locking | Not a lock at all | Separate: the *state lock* stops two runs at once |

**Files Terraform creates by itself** (local backend, one line each):

| File or folder | What it is |
|---|---|
| `.terraform/` | Downloaded provider plugins and a cached copy of the backend settings. Its `terraform.tfstate` is the backend pointer, not the real state |
| `.terraform.lock.hcl` | Provider versions and checksums |
| `terraform.tfstate` | The state (local backend only; with S3 it lives in the bucket) |
| `terraform.tfstate.backup` | The previous state, written before each change (local backend only) |
| `.terraform.tfstate.lock.info` | Temporary lock while a command runs (local backend only) |
| `<key>.tflock` in the bucket | Temporary lock object during an operation (S3 backend with `use_lockfile`) |

Also possible: `crash.log` after a crash, and a plan file if I use `-out`.

**What goes in Git.** Commit: the `.tf` files, `.terraform.lock.hcl`, `*.tfvars.example`. Never commit: `.terraform/`, `*.tfstate`, `*.tfstate.*`, `*.tfvars`, plan files, `crash.log`. This repo's `.gitignore` already covers all of them.

**Regular (local) backend versus S3 remote backend.**

| | Local backend | S3 remote backend |
|---|---|---|
| State lives | In the project folder | In a bucket, under the `key` path |
| Team use | One machine only; can be lost or overwritten | Shared; everyone reads the same state |
| Secrets | Plain JSON on the laptop | Encrypted in the bucket, access by IAM |
| Locking | A lock file on that disk | `.tflock` object in the bucket |
| Recovery | The `.backup` file at best | Bucket versioning keeps old versions |

**S3 native locking.** From Terraform 1.10, `use_lockfile = true` makes the S3 backend lock with a second object, `<key>.tflock`, using S3's conditional writes. DynamoDB is no longer needed and is discouraged. The instructor's README says versioning must be on for this to work properly.

**The bucket must exist first.** `terraform init` failed with a missing-bucket error when the bucket was not there. The state bucket cannot be created by the configuration it stores, so it is made separately (console, CLI or a script) and is not managed by this Terraform. Backend blocks cannot use variables, so values are written in or passed with `-backend-config`.

**Isolation.** The `key` is a path (`dev/terraform.tfstate`), so each environment gets its own state file in the same bucket.

### The commands, with examples (my resource is `aws_s3_bucket.example`)

| Command | What it does | Changes? |
|---|---|---|
| `terraform state list` | Lists every resource in the state. Prints `aws_s3_bucket.example` | No |
| `terraform state show aws_s3_bucket.example` | Prints one resource's attributes (arn, tags, id) | No |
| `terraform show` | Prints the whole state in readable form; `terraform show -json` is machine-readable | No |
| `terraform state pull > backup.json` | Writes the raw remote state to a local file. It holds secrets: never commit it | No |
| `terraform plan -refresh-only` | Shows how the state differs from AWS without changing AWS; `apply -refresh-only` then updates only the state | State only |
| `terraform state mv aws_s3_bucket.example aws_s3_bucket.assets` | Renames a resource in the state so it is not destroyed and recreated | State only |
| `terraform state rm aws_s3_bucket.example` | Makes Terraform forget a resource without destroying it. The next plan wants to create it again | State only |
| `terraform init -migrate-state` | Copies the state to a newly configured backend | Backend |
| `terraform init -reconfigure` | Switches to the new backend settings and does not copy the old state | Backend |
| `terraform force-unlock <LOCK_ID>` | Removes a stuck lock after a crashed run. Only when no run is active | Lock |

Rule from the video: never edit the state file by hand. The `state` subcommands are the safe way.

### What I can now explain (checked in a Q&A, 2026-11-07)

- [x] **Desired state:** the code; it is what I control.
- [x] **Lock file versus state file, first half:** `.terraform.lock.hcl` pins provider versions.
- [x] **State bucket:** it must exist before `init`, because `init` reads the state from it.
- [x] **`use_lockfile`:** stops two runs at once; the lock is removed when the run ends.
- [x] **Versioning:** lets me go back to an earlier state if something goes wrong.
- [x] **Three states:** desired = my code, actual = the real resources in AWS, state file = Terraform's record of what it built. The desired state wins; `apply` changes AWS to match it. (Claude's wording; I accepted it on 2026-11-07 without restating it)
- [x] **State file's job:** it records which resources Terraform built and their attributes; it is not a lock (the `.tflock` object is). (Claude's wording, accepted)
- [x] **`encrypt = true`:** encrypts the state file at rest in the bucket. (Claude's wording, accepted)
- [x] **`terraform state rm`:** forgets one resource, AWS is untouched, and the next plan wants to create it again; it beats hand editing because Terraform locks, validates and backs up. (Claude's wording, accepted)

## 3. Docs to read

- [ ] [State](https://developer.hashicorp.com/terraform/language/state) (what the state stores and why it is sensitive)
- [ ] [S3 backend](https://developer.hashicorp.com/terraform/language/backend/s3) (`use_lockfile`, `encrypt`, the permissions the bucket needs)
- [ ] [`terraform state` commands](https://developer.hashicorp.com/terraform/cli/commands/state) (`list`, `show`, `mv`, `rm`, `pull`)
- [ ] [Dependency lock file](https://developer.hashicorp.com/terraform/language/files/dependency-lock) (what it records, to compare with the state)

## 4. Challenge

The instructor's `task.md`: create an S3 bucket with **versioning and encryption** to store state, then initialize the backend with it. It also asks for a blog and public posts, which this repo skips until the course ends.

Done so far, from my terminal output:

- [x] `terraform init` configured the `s3` backend and reused provider 6.72.0 from the lock file
- [x] `plan` and `apply` created one bucket (`Apply complete! Resources: 1 added`); both printed `Releasing state lock.`
- [x] `destroy` removed it (`Destroy complete! Resources: 1 destroyed.`)
- [x] Backend settings: `use_lockfile = true`, `encrypt = true`, key `dev/terraform.tfstate`

Review findings (checked 2026-11-07). The code is in `sandbox/day-04-remote-backend/main.tf`; Claude wrote the fixes at my request:

- [x] The new state bucket was created with the CLI with versioning on and a `Project` tag: `get-bucket-versioning` printed `"Status": "Enabled"` and `get-bucket-tagging` shows `Project = 30-days-of-aws-terraform` (2026-11-07). The old one had versioning `None`
- [x] The backend block names a `tf30-` bucket, which now exists and is tagged
- [x] The `provider "aws"` block with the region and `default_tags` is in (`validate` and `tflint` pass)
- [x] `terraform fmt -check` passes (exit 0)
- [x] `trivy` HIGH/CRITICAL exits 0: Claude added a public access block, KMS key and encryption config to the demo bucket at my request (a hints-only exception, as on Day 3)
- [x] The demo bucket is now `tf30-day04-` plus a suffix with a Day 4 `Name` tag; `head-bucket` returned 404 for both new names, so they were free on 2026-11-07
- [x] Remove the backend bucket (done, see section 8)
- [x] With the fixed code in `sandbox/day-04-remote-backend/`, `init` configured the new backend, `plan` showed `Plan: 4 to add` with `Project` in `tags_all`, `apply` printed `Apply complete! Resources: 4 added`, and `destroy` printed `Destroy complete! Resources: 4 destroyed.` (2026-11-07). The lock was released each time
- [x] Q&A done 2026-11-07. Four of the answers are Claude's wording that I accepted; I should restate them in my own words before posting anything about Day 4

**Q&A questions:**

1. What is the difference between the desired state, the state file and the actual state? Which one wins?
2. How is `.terraform.lock.hcl` different from `terraform.tfstate`, with one line from each?
3. Why can a state bucket not be created by the Terraform that uses it?
4. What do `use_lockfile`, `encrypt` and bucket versioning each protect against?
5. What does `terraform state rm` do, and why is it safer than editing the file?

## 5. Hints

Open one at a time, in order.

1. Nudge: the Day 4 task says "versioning and encryption". The `aws s3api` subcommands for a bucket include one that sets versioning, and another that sets tags.
2. Narrower: the provider settings (region, `default_tags`) live in a `provider "aws"` block, as on Day 2. For `fmt`, run it and read its diff.
3. Last resort, in words only: add the provider block with the region and the `Project` tag; rename the backend bucket with the `tf30-` prefix when you recreate it; turn on versioning on that bucket and tag it; run `terraform fmt`.

## 6. Verify

| Command | Expected |
|---|---|
| `terraform init` | `Successfully configured the backend "s3"!` |
| `terraform state list` | `aws_s3_bucket.example` while it exists |
| `aws s3api get-bucket-versioning --bucket <backend bucket>` (read-only) | `Status: Enabled` |
| `aws s3api list-objects-v2 --bucket <backend bucket> --query 'Contents[].Key'` (read-only) | `dev/terraform.tfstate`, plus `dev/terraform.tfstate.tflock` only during a run |
| `terraform fmt -check -recursive` | No output, exit 0 |
| `terraform plan` | `tags_all` includes `Project` |

## 7. Gotchas and mistakes

- **The video says the S3 feature does the locking.** Closer: Terraform's S3 backend does the locking by writing `<key>.tflock` with S3's conditional writes (Terraform 1.10 and newer). The video also first typed `lock table` (the old DynamoDB setting) and corrected it to `use_lockfile` at 9:33.
- **The video shows a file with only the bucket name and calls it the state.** In my folder the matching file is `.terraform/terraform.tfstate`, the backend pointer. The real state is in the bucket.
- **The video says a `plan` is blocked by the lock too.** That holds: plan takes the lock unless `-lock=false` is passed.
- **The video created the backend bucket in the console, and its README uses a `test.sh` script.** I used `aws s3api create-bucket`, which made a bucket with no versioning, no tags and a name outside the repo's rule.
- **Console and CLI defaults.** My CLI-created bucket still had default encryption (AES256) and the four public-access blocks on, as S3 does for new buckets. Versioning is not on by default.
- **No `provider` block.** Terraform ran anyway because the profile supplied the region. Tags set in a provider block were not applied, so the Day 4 bucket missed the `Project` tag.
- **The destroy output contains the bucket's canonical owner id** (in the `grant` block). Like account ids, it must not go into this repo.
- **Q&A first attempt (2026-11-07) had four mistakes.** I said the actual state is "in Git" (Git holds the code, the desired state; the actual state is the real AWS resources). I described the state file as something that "locks" (it records what Terraform built; the lock file pins provider versions). I said `encrypt` protects the lock file (it encrypts the state file). And I said `state rm` deletes the state (it removes one resource's entry, the resource stays in AWS, and the next plan wants to create it again).
- **Versioning showed the history.** After the destroy, `list-object-versions` on the state bucket listed the current `dev/terraform.tfstate` (181 bytes, empty) and the previous version (7315 bytes, the four resources). The lock object `dev/terraform.tfstate.tflock` appeared as versions with delete markers, as the README describes. The older version is the recovery copy that an unversioned bucket would not have.
- **The state file after `destroy` is not deleted.** It stays in the bucket with an empty resource list (181 bytes). The bucket must be emptied before it can be deleted.

## 8. Cleanup

- [x] `terraform destroy` removed the Day 4 bucket (`Destroy complete! Resources: 1 destroyed.`)
- [x] Removed the backend bucket (2026-11-07): `aws s3 rm --recursive`, then `delete-bucket`; `head-bucket` returned `404 Not Found`, and Claude's own read-only `head-bucket` check agreed. I skipped the pre-check that the state was empty (`terraform state pull`), but `destroy` had reported `1 destroyed` and the state object was 181 bytes
- [x] Deleted the local `.terraform/` folder in the Day 4 folder (2026-11-07)
- [x] Read-only checks (2026-11-07): the Day 4 demo bucket returns 404, its KMS key is `PendingDeletion` (7 days, expected)
- [x] Deleted the state bucket `tf30-tfstate-m4r8h2` (2026-11-07): `terraform state pull`-style check printed `[]`, then all five object versions and three delete markers were deleted with `delete-objects`, the list showed `[null, null]`, `delete-bucket` succeeded and `head-bucket` returned `404 Not Found`. The local `.terraform/` in the sandbox folder was removed
- [x] (reminder for later) When a later day needs a remote backend, recreate a state bucket with the `tf30-` prefix, versioning on and the `Project` tag (the `main.tf` here still names the deleted bucket, so `init` against it fails until it is recreated; CI uses `-backend=false`)

## 9. LinkedIn worth

Candidates, added to `docs/LINKEDIN-IDEAS.md`: the lock file versus state file in one table, S3 native locking replacing DynamoDB, and how a five-second CLI-created state bucket still missed versioning, tags and the naming rule. Nothing is posted until the course is finished.
