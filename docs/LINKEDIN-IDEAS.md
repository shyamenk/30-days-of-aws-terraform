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

Strength 3 means a stranger would learn something real from it. Strength 1 is a note to myself.
