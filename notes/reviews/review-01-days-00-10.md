# Review 1: Days 0 to 10

Started 2026-11-26. Spaced revision of Days 0 to 10: Q&A one at a time, then small plan-only tasks, then a capstone in `sandbox/review-01/`.

## Scoreboard

| Item | Day | Topic | Grade |
|---|---|---|---|
| A1 | 0 | What makes a subnet public; where the IGW attaches | half right (repeat of Day 0 mistakes) |
| A2 | 1 | `plan` vs `apply`, what removes everything | right (Day 3 first try had them swapped) |
| A3 | 2 | `~> 6.0` range; what `.terraform.lock.hcl` does | half right (range right in spirit; lock file confused with state locking) |
| A4 | 4 | The three states, where each lives, which wins | right (Day 4 first try said actual state is "in Git") |
| A5 | 3 | Taken bucket name: does plan catch it, how to avoid | half right (prefix marks ownership, does not make a name unique) |
| A6 | 4 | Why no variables in `backend`; why the state bucket is made outside | half right (how right, why missing) |

**Round A: 2 right, 4 half right, 0 wrong.**

| Item | Day | Topic | Grade |
|---|---|---|---|
| B1 | 5 | Variable precedence, five sources | half right (winner right; `TF_VAR_` placed above `terraform.tfvars`, `*.auto.tfvars` missing) |
| B2 | 7 | list vs set vs tuple: indexing, mixed types, why no set index | half right (1 and 2 right; set described as key/value) |
| B3 | 8 | Predict: remove first item, `count` vs `for_each` | half right (B right; A's churn right but not the actions, and no why) |
| B4 | 9 | Replace order; `create_before_destroy` with a fixed name; fix | right (Day 9 Task 2 was half right) |
| B5 | 10 | `count = 0`: splat result, `[0]` result, safe output | wrong (said `0` and "same"; no expression for 3) |
| B6 | 10 | `dynamic` iterator; when `dynamic` is the wrong choice | half right (`.value.port` right, missed `[ ]` around the CIDR; when-not-to only partly) |

**Round B: 1 right, 4 half right, 1 wrong.**

**Round C (capstone in `sandbox/review-01/`): paused 2026-11-26 before C1, to start Day 11.** C1 is VPC and subnets with `for_each` over a `map(string)`, an `env` validation, and `prefix`/`common_tags` locals. C2 to C4 were planned as a security group with `dynamic` ingress and `name_prefix` with `create_before_destroy`, a conditional EIP with a `one()` output, and testing each guard with a value that must fail.

## Lessons learned

- **A subnet is private by default.** A new subnet in a custom VPC uses the main route table, which has only the `local` route. Adding a route `0.0.0.0/0` to the internet gateway in its route table is what makes it public. Instances also need a public IP (`map_public_ip_on_launch`) to be reachable from outside. Two exceptions: subnets in the default VPC are public from the start, and if someone adds the IGW route to the main route table, every subnet without its own route table becomes public.
- **The internet gateway attaches to the VPC, not to a subnet.** Subnets reach it only through a route in their route table.
- **`~> 6.0` means at least 6.0 and below 7.0.** The operator lets only the last number given move, so `~> 6.0.0` would allow 6.0.x only.
- **The lock file and state locking are two different things.** `.terraform.lock.hcl` records the exact provider versions and checksums that `init` picked, so every machine and CI run gets the same provider. It is committed, and only `terraform init -upgrade` moves it. State locking (`use_lockfile` on the S3 backend, Day 4) stops two `apply` runs writing the state at the same time.
- **The `tf30-` prefix is for ownership, not uniqueness.** Anyone in any account can create `tf30-day03-bucket`. Uniqueness comes from a random suffix (`random_id`) or `bucket_prefix`, which lets AWS add one. `plan` never checks name availability or naming rules; only `apply` does.
- **The backend is set up at `init`, before variables exist.** So the `backend` block takes only literals. Values that change per environment go in at init with `-backend-config`.
- **The state bucket is a chicken-and-egg problem.** `init` needs the bucket before any resource can be created, and a configuration that managed its own state bucket could `destroy` the place its state lives. So it is made outside, by the CLI or a separate bootstrap configuration, with versioning on.
- **Variable precedence, lowest to highest:** `default`, then `TF_VAR_` environment variables, then `terraform.tfvars`, then `*.auto.tfvars` (in name order), then `-var` and `-var-file` on the command line (later flags win). The environment variable is the weakest outside source, below both files.
- **A set is not key/value; a map is.** A set is a bag of unique values with no order, so "element 0" has no meaning and a set is read only by its values. That same property is why `for_each` takes a set or a map: each instance gets a stable name (the value or the key) instead of a position.
- **`count` tracks by position, `for_each` by key.** Removing `alice` from `["alice", "bob", "carol"]` with `count` shifts every later item down one slot: `u[0]` changes alice to bob, `u[1]` changes bob to carol, and `u[2]` is destroyed. So the plan destroys carol's slot, not alice's. Whether a shifted slot is updated in place or replaced depends on the argument: an IAM user's `name` can be updated in place, while an S3 bucket's name forces a replacement. In-place renames can also collide at apply (renaming to `bob` while `bob` still exists). With `for_each`, only `u["alice"]` is destroyed, because the other keys did not change.
- **A resource with `count = 0` is an empty list.** `aws_eip.this[*].public_ip` returns `[]`, not `0`. `aws_eip.this[0].public_ip` fails at plan with an invalid index error, because there is no element 0. The safe output is `one(aws_eip.this[*].public_ip)`: `null` for an empty list, the value for one element, and an error for more than one. `try(aws_eip.this[0].public_ip, null)` also works, but it hides other errors too.
- **`dynamic` iterator and limits.** The iterator is named after the block label (`ingress.value.port`) unless `iterator =` renames it. `cidr_blocks` takes a list, so a single string needs `[ingress.value.cidr]`. `dynamic` is the wrong choice for a fixed number of blocks (write them out), and it hurts readability when overused. For security groups, separate `aws_vpc_security_group_ingress_rule` resources with `for_each` are now the AWS provider's recommended pattern.
- **The pattern across this review:** I recall *what* happens but skip *why*. Answer every question with the reason.
