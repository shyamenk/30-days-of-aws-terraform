# LinkedIn-worthy material

Nothing is posted until the course is finished. This file collects what is worth posting, so the post is easy to write later. Add a row whenever a day produces one of these:

- A mistake that cost real time, with the error text and the cause
- A concept that clicked, with the explanation that finally worked
- A comparison between the video and the current docs (something that changed)
- A cost surprise
- A diagram or short excerpt from my own code that teaches something

| Day | Type | The idea in one line | Evidence (note section, error text, commit) | Strength (1-3) |
|---|---|---|---|---|
| 0 | Lesson | The announced syllabus differed from the released videos, and the instructor's README still follows the announcement. Check a course's real content against its outline. | `docs/SYNC.md` known differences | 1 |
| 0 | Concept | What actually makes a subnet public: a route to the internet gateway plus a public IP. The gateway attaches to the VPC, not a subnet, and private subnets still reach out through NAT. | Day 0 note, section 2 and 7 | 2 |
| 1 | Concept | Why teams stop clicking: about 2 hours for one app by hand, times 6 environments, times hundreds of apps. The hours are the instructor's estimate, so say that. | Day 1 note, section 2 | 1 |
| 1 | Lesson | The video's loose wording on `destroy` and `init`: `destroy` removes what state says Terraform built, not "everything in the files", and `init` prepares the folder without creating cloud resources. | Day 1 note, section 7 | 2 |
| 2 | Lesson | A version constraint copied from an older course can block the current provider: `~> 5.0` allows only 5.x, while 6.72.0 is current. Read what `~>` allows before pasting it. | Day 2 note, section 7 | 2 |
| 2 | Mistake | My first working Terraform still failed my own CI: no `required_version` (`tflint` exit 2) and an untagged resource in a shared account. | Day 2 note, section 7 | 2 |
| 3 | Concept | Implicit versus explicit dependencies: a reference such as `aws_vpc.main.id` shows up as `(known after apply)` in the plan and orders the resources, while `depends_on` orders them with no value passing. | Day 3 note, section 2 | 2 |
| 3 | Mistake | An S3 bucket cannot be "in a VPC". My first attempt used `depends_on`, then a `vpc_id` argument the bucket does not have; a tag was the place where the reference fit. | Day 3 note, section 7 | 2 |
| 4 | Concept | Lock file versus state file in one table: `.terraform.lock.hcl` says which provider versions to use, `terraform.tfstate` says which resources exist. One is committed, the other never. | Day 4 note, section 2 | 2 |
| 4 | Lesson | S3 native locking (`use_lockfile`, Terraform 1.10 and newer) replaced the DynamoDB lock table, and the video itself first typed the old setting. | Day 4 note, section 7 | 2 |
| 4 | Mistake | A state bucket made in five seconds with the CLI still missed versioning, tags and my own naming rule. Check the boring bucket as hard as the code. | Day 4 note, section 4 | 2 |
| 5 | Concept | Which value wins when a Terraform variable is set in six places: default, `TF_VAR_`, `terraform.tfvars`, `.auto.tfvars`, then `-var` last. A short ladder with a plan that proves each step. | Day 5 note, section 2 | 2 |
| 5 | Lesson | An assistant suggested a resource type that does not exist (`aws_ec2_instance`); the video's fix is the provider docs, and `plan` caught it before anything was created. | Day 5 note, section 7 | 2 |
| 6 | Concept | Terraform does not care what your files are called: it merges every `.tf` file in the directory, so the names are only for humans. | Day 6 note, section 2 | 2 |
| 6 | Lesson | `timestamp()` in a tags local (as in the instructor README) makes every plan show a tag change, because the value differs on each run. | Day 6 note, section 7 | 2 |
| 7 | Concept | A Terraform `set` cannot be indexed: with no order and no duplicates there is no "element 2", so you convert it with `tolist()` first. | Day 7 note, sections 2 and 7 | 2 |
| 7 | Lesson | The instructor's `task.md` asks for a `/8` VPC CIDR with two subnets outside it; AWS only accepts `/16` to `/28`, and subnets must sit inside the VPC range. | Day 7 note, section 7 | 2 |
| 7 | Mistake | `terraform plan` said 6 to add and looked fine, but the subnets sat outside the VPC range and overlapped. Plan cannot see AWS range rules; the apply would have failed. The wrong count (6, not 4) was the clue. | Day 7 note, section 7 | 3 |
| 7 | Concept | `tolist()` on a string set returns it sorted, not in the order you wrote it: I typed `us-east-1` first and `[0]` gave `eu-west-1`. A set has no "first". | Day 7 note, section 7 | 2 |
| 7 | Mistake | A "check" that did nothing: `-var ec2_instance_type=m5.24xlarge` planned fine because the resource read a different variable. Test a guard with a value that must fail. | Day 7 note, section 7 | 2 |
| 7 | Mistake | A variable `default` cannot reference another variable or a local: `validate` says "Variables may not be used here". Defaults are literals; build dynamic values in `locals`. | Day 7 note, section 7 | 2 |
| 7 | Gotcha | A resource's own `tags` win over provider `default_tags`, so a `Project` key in your tags map silently replaces the default `Project`. | Day 7 note, section 7 | 2 |
| 7 | Mistake | I folded three variables into one `object`, and the `allowed_region` check stayed on the old, now-unused variable. A bad region planned fine. A plan with a good value cannot show that a guard is gone; test with a value that must fail. | Day 7 note, section 7 | 3 |
| 7 | Concept | A tuple's length and order are part of its type: four values for `tuple([number, string, number])` is a type error, and so is `["tcp", 443, 443]`. A list only cares about the element type. | Day 7 note, section 7 | 2 |
| 8 | Concept | Remove the first item from a `count` list and every later resource shifts address and is replaced; with `for_each` only the removed one goes. Reasoned on 2026-11-20, not seen: a plan against empty state only shows adds, so apply first to capture the `must be replaced` lines before posting. | Day 8 note, sections 2 and 6 | 2 |
| 8 | Mistake | `terraform graph` showed 10 nodes and the plan said `16 to add`. I guessed the plan counts destroys too; it had none. The graph draws one node per block, the plan counts instances after `count` and `for_each` expand. | Day 8 note, section 7 (Q&A) | 2 |
| 8 | Mistake | I said `depends_on` is for when you need an ID from another resource. Needing an ID means a reference, which already orders the two. `depends_on` is only for a dependency the code cannot show. | Day 8 note, section 7 (Q&A) | 2 |
| 8 | Gotcha | A plan cannot prove `depends_on` works: it lists resources by address, not in order. `terraform graph` shows the edge (`A -> B`, B first). | Day 8 note, section 6 | 1 |
| 8 | Gotcha | A plan with `13 to add` passed, but `trivy` still reported 20 HIGH findings: writing the public access block once over a merged map of buckets hid the link from the scanner. One protection per bucket block, each referring to its own block, cleared it. | Day 8 note, section 7 | 2 |

| 9 | Gotcha | `replace_triggered_by = [aws_security_group.app_sg.id]` does not replace the instance when you edit a rule: the edit is in place and the ID never changes. Reference the whole resource to fire on any change. The course video and README both get this wrong. Not yet seen in my own plan. | Day 9 note, section 7 | 3 |
| 9 | Gotcha | `prevent_destroy` does not protect a resource whose block you delete: the rule goes with the block, so the next apply destroys it. Not yet seen in my own plan. | Day 9 note, section 7 | 3 |
| 9 | Gotcha | `create_before_destroy` on anything with a fixed unique name (a bucket, a security group name, a table) fails on the replace, because two copies must exist at once. Use `name_prefix` where the resource has it. Not yet seen in my own apply. | Day 9 note, section 7 | 2 |
| 9 | Concept | Three lifecycle rules, three production needs: `create_before_destroy` for availability (EC2), `prevent_destroy` for protection (RDS), `ignore_changes = [tags["Owner"]]` for shared ownership (S3). The twist: `prevent_destroy` dies with the block, so pair it with RDS `deletion_protection`. | Day 9 note, section 2 (my key notes) | 2 |
Strength 3 means a stranger would learn something real from it. Strength 1 is a note to myself.

## Restate before posting

These Q&A answers use Claude's wording, which I accepted without restating it. Rewrite each one in my own words before it goes into any post. Delete the row once the note holds my version.

| Day | Answer | Where |
|---|---|---|
| 3 | S3 bucket names are global across every account and region | [Day 3](../notes/week-01/day-03-s3-bucket.md), section 2 |
| 3 | What an implicit dependency is and why the plan shows `(known after apply)` | [Day 3](../notes/week-01/day-03-s3-bucket.md), section 2 |
| 3 | A bucket can depend on a VPC but cannot live in one | [Day 3](../notes/week-01/day-03-s3-bucket.md), section 2 |
| 3 | Why a tag change is `1 to change` and not a replace | [Day 3](../notes/week-01/day-03-s3-bucket.md), section 2 |
| 4 | Desired state, actual state and the state file | [Day 4](../notes/week-01/day-04-state-remote-backend.md), section 2 |
| 4 | The state file's job, and that it is not the lock | [Day 4](../notes/week-01/day-04-state-remote-backend.md), section 2 |
| 4 | What `encrypt = true` does in the S3 backend | [Day 4](../notes/week-01/day-04-state-remote-backend.md), section 2 |
| 4 | What `terraform state rm` does and why it beats hand editing | [Day 4](../notes/week-01/day-04-state-remote-backend.md), section 2 |
| 5 | Which variable value wins | [Day 5](../notes/week-01/day-05-variables.md), section 2 |
| 5 | Where secrets should and should not live | [Day 5](../notes/week-01/day-05-variables.md), section 2 |
| 6 | Why renaming `main.tf` changes nothing | [Day 6](../notes/week-01/day-06-project-structure.md), section 7 |
| 6 | `terraform.tfvars` is a file kept out of Git by `.gitignore`, and the `.example` catch | [Day 6](../notes/week-01/day-06-project-structure.md), section 7 |
| 6 | Moving a block to another file needs no "call"; state tracks addresses, not files | [Day 6](../notes/week-01/day-06-project-structure.md), section 7 |
| 7 | `precondition` versus `validation` | [Day 7](../notes/week-02/day-07-type-constraints.md), section 7 |
| 7 | With `count`, read attributes as `[0].id` or `[*].id` | [Day 7](../notes/week-02/day-07-type-constraints.md), section 7 |
| 7 | Object versus map | [Day 7](../notes/week-02/day-07-type-constraints.md), section 7 |
| 7 | Why a variable `default` must be a constant (mostly mine, tightened by Claude) | [Day 7](../notes/week-02/day-07-type-constraints.md), section 7 |
| 8 | Graph nodes count blocks; the plan counts instances | [Day 8](../notes/week-02/day-08-meta-arguments.md), section 7 |
