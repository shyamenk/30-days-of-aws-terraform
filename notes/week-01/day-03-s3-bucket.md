# Day 3: The first S3 bucket and resource dependencies

Video: [Terraform S3 bucket](https://www.youtube.com/watch?v=09HQ_R1P7Lw) (12 min) · Instructor code: [lessons/day03](https://github.com/piyushsachdeva/Terraform-Full-Course-Aws/tree/main/lessons/day03) (README, task and one `main.tf`) · Verified against: Terraform 1.17.1, AWS provider 6.72.0 on 2026-11-06

Source material for this note: the video transcript, the instructor's README, `task.md` and `main.tf`, and my own terminal output. Apply and destroy have **not** been run yet, so sections 4, 6 and 8 show what is still open.

## 1. Goal

After today I can write an `aws_s3_bucket` resource from the provider docs, run `init`, `plan`, `apply` and `destroy` on it, and make one resource depend on another through a reference.

## 2. Concepts

**The loop for any resource.** Find the resource page in the provider docs, copy the example, read the argument reference to see what is required and what is optional, change the values, then run the four commands. The video does this with the simplest possible resource so the loop is the lesson.

**The resource block.** `resource "aws_s3_bucket" "example" { ... }` has a keyword, a type from the docs (`aws_s3_bucket`) and a local name I choose. The local name is only for referring to the resource inside my own code, so it should say what the thing is for.

**Bucket names are global.** A bucket name must be unique across every AWS account and region. Mine is `tf30-day03-` plus a random-looking suffix, so it follows the repo's `tf30-` rule and cannot collide with an existing bucket.

**`tags` is a map.** Curly braces, a key and a value per line. It is a different data type from a plain string such as `bucket = "..."`. Types are covered on Day 7.

**The four commands.**

| Command | What it does |
|---|---|
| `terraform init` | Downloads the provider and prepares the folder. Creates nothing in AWS |
| `terraform plan` | A dry run that shows what would change. Ends with `Plan: X to add, Y to change, Z to destroy.` |
| `terraform apply` | Makes the changes. Asks for `yes` unless I pass `-auto-approve` |
| `terraform destroy` | Removes everything in the state. Also asks for `yes` |

**Changing a resource in place.** The video edits the `Name` tag and runs `apply` again. The plan says `0 to add, 1 to change, 0 to destroy`, and the bucket is updated rather than replaced. The instructor says Terraform noticed because it compared my code with the real environment using the state file. That is roughly right: the state file records what Terraform built, and a refresh checks that against AWS before the plan.

**Implicit and explicit dependencies** (the assignment).

An *implicit* dependency exists when one resource's argument uses another resource's attribute. Terraform sees the reference, creates the other resource first and destroys it last.

An *explicit* dependency is `depends_on = [...]`. It is for an ordering that Terraform cannot see because no value passes between the two resources.

```
 aws_vpc.main ──► id (known after apply) ──► aws_s3_bucket.example tags["Vpc"]
 created first                               created second, destroyed first
```

The visible sign of an implicit dependency in a plan is `(known after apply)` on the argument that uses the reference. `terraform graph` also prints an edge between the two resources.

**An S3 bucket does not live in a VPC.** S3 is a regional service with no VPC setting. The assignment's "bucket in the VPC" can therefore only mean a dependency between the two resources, and a tag is a simple place to put the reference.

### What I can now explain (checked in a Q&A, 2026-11-07)

- [x] **`init`:** downloads the provider plugin and prepares the folder; it creates nothing in AWS.
- [x] **Bucket names:** they must be globally unique.
- [x] **Explicit dependency:** written with `depends_on`.
- [x] **`plan`, `apply`, `destroy`:** `plan` is the dry run, `apply` makes the changes, `destroy` removes what the state file holds (so only `apply` and `destroy` change AWS)
- [x] **Global names:** S3 has one bucket-name namespace shared by every account and region. Repo rules: the `tf30-` prefix and the `Project` tag, and never reuse a real bucket's name. (Claude's wording; I accepted it on 2026-11-07 without restating it)
- [x] **Implicit dependency:** an argument that refers to another resource's attribute, such as `aws_vpc.main.id`; the plan shows `(known after apply)`. (Claude's wording, accepted)
- [x] **Bucket and VPC:** S3 is regional with no VPC setting, so the bucket can depend on the VPC but not live in it. KMS, IAM and Route 53 are also outside a VPC. (Claude's wording, accepted)
- [x] **`1 to change`:** a tag is editable in place; only an argument that cannot change in place forces `1 to add, 1 to destroy`. (Claude's wording, accepted)

## 3. Docs to read

- [ ] [`aws_s3_bucket`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) (the required argument is `bucket`; compare the optional ones)
- [ ] [`aws_vpc`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc) (the Attribute Reference section lists what other resources can use)
- [ ] [`depends_on`](https://developer.hashicorp.com/terraform/language/meta-arguments/depends_on) (when an explicit dependency is needed and why implicit is preferred)
- [ ] [Bucket naming rules](https://docs.aws.amazon.com/AmazonS3/latest/userguide/bucketnamingrules.html) (length, allowed characters, global uniqueness)

## 4. Challenge

The instructor's `task.md` asks for one Terraform file that creates a VPC and an S3 bucket with an **implicit dependency** between them. It also asks for a blog and public posts, which this repo skips until the course ends.

- [x] One file creates a VPC and a bucket, both named with `tf30-` and tagged `Project` through `default_tags`
- [x] The dependency is implicit: the bucket's `Vpc` tag uses `aws_vpc.main.id`, and there is no `depends_on`
- [x] `terraform fmt -check`, `terraform validate` and `tflint` pass on a scratch copy (Claude ran them with the pinned Terraform 1.17.1)
- [x] `terraform graph` shows `aws_s3_bucket.example -> aws_vpc.main`
- [x] `trivy config . --severity HIGH,CRITICAL --exit-code 1` exits 0. It exited 1 with five findings on the bare bucket (AWS-0086, AWS-0087, AWS-0091, AWS-0093, AWS-0132). Claude added a public access block, a KMS key with rotation and default bucket encryption at my request (another hints-only exception). Left over and not failing CI: AWS-0089 (LOW, no bucket logging), AWS-0090 and AWS-0178 (MEDIUM, no versioning, no VPC flow logs)
- [x] My own `terraform plan` on the final code: `Plan: 5 to add, 0 to change, 0 to destroy.` The bucket's `tags` and `tags_all` are `(known after apply)` because the `Vpc` tag uses the VPC id (2026-11-07)
- [x] `terraform apply` created all five resources: `Apply complete! Resources: 5 added, 0 changed, 0 destroyed.` The VPC and the KMS key started together (no reference between them); the bucket waited for the VPC, the public access block for the bucket, and the encryption configuration for both the bucket and the key (2026-11-07)
- [x] Console check after apply (done by me, 2026-11-07): the bucket showed the expected tags, encryption and public-access blocks. My own CLI leftover check also printed an empty array (`[]`)
- [x] Changed the `Name` tag to `tf30-day03-bucket-v2` and applied: the plan said `0 to add, 1 to change, 0 to destroy`, and the apply printed `Apply complete! Resources: 0 added, 1 changed, 0 destroyed.` The bucket was updated in place, not replaced (2026-11-07)
- [x] `terraform destroy` removed all five: `Destroy complete! Resources: 5 destroyed.` Reverse order: public access block and encryption config, then the key and bucket, then the VPC (2026-11-07)
- [x] Q&A done 2026-11-07. Four of the answers are Claude's wording that I accepted; I should restate them in my own words before posting anything about Day 3

The code is in `sandbox/day-03-s3/main.tf`. Claude wrote two fixes at my request, both exceptions to the hints-only rule: moving the reference into `tags`, and the Trivy fixes. The plan should now say `Plan: 5 to add` (VPC, bucket, public access block, KMS key, encryption configuration).

**Q&A questions** (to answer once apply and destroy are done):

1. What do `init`, `plan`, `apply` and `destroy` each do, and which of them changes AWS?
2. Why must a bucket name be unique, and what rules does this repo add to it?
3. What is the difference between an implicit and an explicit dependency, and how can I see an implicit one in a plan?
4. Why can the bucket not simply be placed in the VPC?
5. After I change one tag and apply, why does the plan say `1 to change` and not `1 to add, 1 to destroy`?

## 5. Hints

Open one at a time, in order.

1. Nudge: the `aws_vpc` docs page has an Attribute Reference section. The plan shows `(known after apply)` for values that only exist after creation.
2. Narrower: look for an argument of `aws_s3_bucket` that takes any string. A reference such as `<type>.<local name>.<attribute>` can go on the right-hand side of it.
3. Last resort, in words only: put a reference to the VPC's `id` in the value of one entry of the bucket's `tags` map, and delete `depends_on`.

For the Trivy findings:

1. Nudge: each finding's page (`https://avd.aquasec.com/misconfig/aws-0086`) says what it wants. The findings are about two settings that the provider docs list as separate resources next to `aws_s3_bucket`.
2. Narrower: search the `aws_s3_bucket` docs sidebar for "public access block" and for "server side encryption configuration". Each one points at the bucket with a reference, which is another implicit dependency.
3. Last resort, in words only: one extra resource blocks all four public-access settings, and another sets the default encryption to KMS. A customer-managed key is a third resource.

## 6. Verify

| Command | Expected |
|---|---|
| `mise exec -- terraform init` | `Installed hashicorp/aws v6.72.0 (signed by HashiCorp)` |
| `terraform validate` | `Success! The configuration is valid.` |
| `terraform plan` | `Plan: 5 to add, 0 to change, 0 to destroy.` and `"Vpc" = (known after apply)` in the bucket's `tags` |
| `terraform graph` | A line `"aws_s3_bucket.example" -> "aws_vpc.main"` |
| Console check after apply | Bucket `tf30-day03-...` with tags `Name`, `Environment`, `Vpc`, `Project` |
| Console check after destroy | No `tf30-` bucket or VPC left |

## 7. Gotchas and mistakes

- **I used `depends_on` first, but the assignment asks for an implicit dependency.** It is a valid dependency, yet no value passed from the VPC to the bucket, so the plan had nothing marked `(known after apply)`.
- **I then wrote `vpc_id = aws_vpc.main.id` on the bucket.** `aws_s3_bucket` has no such argument; the attribute list in my plan output for the bucket has none either. The reference has to go into an argument the resource actually accepts, and a tag does. I did not run that version, so I never saw Terraform's exact error text.
- **A bare bucket fails the repo's security scan.** `trivy config` reports five HIGH findings: no public access block (AWS-0086, 0087, 0091, 0093) and no customer-managed KMS key (AWS-0132). `main` passes the same scan, so the new bucket is what fails CI's `security-scan`. I chose to fix them in the code rather than ignore them. The KMS key is the one new cost: AWS bills a customer-managed key per month (prorated), so destroy it the same session. `destroy` only schedules key deletion after the 7-day minimum window, which is expected.
- **Q&A first attempt (2026-11-07) had five mistakes.** I swapped `plan` and `apply` (`plan` is the dry run, `apply` changes AWS) and left out `destroy`. I wrote that bucket names are unique "because it's a regional service" (the service is regional, but the bucket namespace is global). I described an implicit dependency as "defined inside the block" instead of "a reference to another resource's attribute", and did not say how to see one (`(known after apply)`). I said all services always live in a VPC (S3, IAM and KMS do not). And I mixed up `1 to change` (in place) with `1 to add, 1 to destroy` (replacement).
- **A typo made the tag `tf30-day03-bucketss`.** It appeared in the plan, so it was caught before apply.
- **The instructor's README does not match the video.** The README covers AWS authentication and CLI installation, while the video builds the bucket. The README's example bucket name, `my-tf-test-baiv-bucket-101`, is a fixed name that someone else could already own. I kept the `tf30-` rule and a random suffix instead.
- **My Desktop folder resolves the system Terraform 1.15.9.** My first `required_version = "~> 1.17"` would have refused it, so I loosened it to `~> 1.15`, and `mise exec --` still gives the pinned 1.17.1.
- **Raw plan and destroy output contains the account ID in ARNs** (the KMS key, bucket and VPC ARNs). I pasted the unedited destroy output into chat; it must never go into this repo. Remove the ID before pasting next time.

## 8. Cleanup

- [x] `terraform destroy` ran (see section 4)
- [x] Read-only checks (2026-11-07): `describe-vpcs` filtered on the `Project` tag printed `[]`, `head-bucket` returned 404 Not Found, no `tf30` KMS alias, and the key's state is `PendingDeletion` (expected for 7 days)

## 9. LinkedIn worth

Two candidates, both added to `docs/LINKEDIN-IDEAS.md`: implicit versus explicit dependencies (`(known after apply)` is how to see one), and why an S3 bucket cannot be placed "in a VPC". Nothing is posted until the course is finished.
