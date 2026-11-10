# Day 7: Type constraints

Video: [Terraform type constraints](https://www.youtube.com/watch?v=gu2oCJ9DQiQ) (52 min) · Instructor code: [lessons/day07](https://github.com/piyushsachdeva/Terraform-Full-Course-Aws/tree/main/lessons/day07) (README, `task.md`, and a `main.tf`, `variables.tf`, `locals.tf`, `outputs.tf`, `provider.tf`) · Verified against: Terraform 1.17.1, AWS provider 6.72.0 (from `sandbox/day-07-types/.terraform.lock.hcl`) on 2026-11-09

Source material for this note: the video transcript, my key notes, the instructor's README and `task.md`. Hands-on is in progress (Tasks 1 to 8 of 10 done, plan-only); the Q&A is not done yet.

## 1. Goal

After today I can name every Terraform type constraint, pick the right one for a variable, declare it with a `type` argument, and read a value out of each one (directly, by index, by key, or by attribute).

## 2. Concepts

**Two ways to classify variables.** By purpose (Days 5 and 6): input, output, local. By value: the type constraint, which says what kind of value a variable may hold. A type constraint is the `type` argument of a `variable` block. Leave it out and the type is `any`, so Terraform accepts whatever you give it. The video recommends always setting it.

```
 Type constraints
 ├── Primitive (one value)
 │    ├── string     "ap-south-1", "full name with spaces"   (double quotes)
 │    ├── number     35, 1, 443                              (no quotes)
 │    └── bool       true / false                            (no quotes)
 ├── Complex (many values)
 │    ├── list(T)    ordered, duplicates allowed, one element type
 │    ├── set(T)     unordered, no duplicates, one element type
 │    ├── map(T)     key/value pairs, one value type
 │    ├── tuple([T1, T2, ...])   ordered, a fixed type at each position
 │    └── object({k1 = T1, ...}) key/value pairs, a type for each key
 └── Special
      ├── any        no constraint (the default if `type` is missing)
      └── null       "no value"; makes an argument behave as if it were not set
```

**Primitives.** `count` wants a number, so a `number` variable feeds it. `monitoring` and `associate_public_ip_address` on `aws_instance` are booleans, so `bool` variables feed them. The video's rule of thumb for spotting a boolean: if the docs phrase the argument as a yes/no question ("whether to associate a public IP"), it is a bool. The type of each argument is shown in the provider docs, so read it there rather than guessing.

**Collections and how to read them.**

| Type | Reads like | Access | Duplicates | Order |
|---|---|---|---|---|
| `list(string)` | `["a", "b", "a"]` | `var.x[0]` (index from 0) | allowed | fixed |
| `set(string)` | `["a", "b"]` | not by index; convert first: `tolist(var.x)[0]` | removed silently | none |
| `map(string)` | `{ env = "dev" }` | `var.x["env"]` or `var.x.env` | keys are unique | by key |
| `tuple([number, string, number])` | `[443, "tcp", 443]` | `var.x[1]` | allowed | fixed, and each position has its own type |
| `object({ region = string, monitoring = bool, instance_count = number })` | `{ region = "us-east-1", ... }` | `var.x.region` | n/a | n/a |

**Why a set cannot be indexed.** If a set may drop duplicates and has no order, "element 2" has no meaning. The error says "Elements of a set are identified only by their values and don't have any separate index or key". `tolist()` turns the set into a list first. The video notes the order after `tolist()` is not something to depend on; Terraform sorts string sets, so it is stable in practice, but a set is the wrong choice when position matters.

**Map versus object.** Both are key/value pairs. A `map(string)` has one type for every value. An `object` declares a type for each key, so it can hold a string, a bool and a number together. Use a map for things like tags; use an object to group the settings of one thing.

**Tuple versus list.** The video says a tuple is "similar to a set". That is wrong: a tuple is ordered like a list, and differs from it only in allowing a different type at each position. Position and type must both match the declaration.

**List versus set, in one sentence.** Pick a list when order or repeated values matter; pick a set when you only care about "is it in there" and uniqueness.

**Rules the video ran into.**

- A `default` must be a literal. It cannot use `var.` or `local.` (error: "Variables may not be used here").
- `count` on a resource changes its addresses to `aws_instance.example[0]`, so an output that says `aws_instance.example.id` fails with "Missing resource instance key". The video removed `outputs.tf` for the day and promised to cover `count.index` later (Day 8).
- Each argument takes one type. The ingress rule resource wants a single `cidr_ipv4` string, so a list will not fit there. To use a list of CIDR blocks you use the older `aws_security_group_rule` resource, whose `cidr_blocks` takes a list.

## 3. Docs to read

- [ ] [Type constraints](https://developer.hashicorp.com/terraform/language/expressions/type-constraints) (the table of types, and the `optional()` section)
- [ ] [Input variables](https://developer.hashicorp.com/terraform/language/values/variables) (the `type`, `default`, `description` arguments and custom validation)
- [ ] [`tolist` function](https://developer.hashicorp.com/terraform/language/functions/tolist) (why a set needs it before indexing)

## 4. Challenge

The instructor's `task.md` has ten small tasks, one per type, plus a `deployment_summary` output. The video itself builds an EC2 instance and a security group. My Day 6 sandbox is the starting point: copy it as `sandbox/day-07-types/` and change it there. Every name starts with `tf30-` and the `Project` tag stays.

Acceptance criteria:

- [ ] One variable of each of these types exists and is used by a resource: `string`, `number`, `bool`, `list(string)` (done), `set(string)` (done), `map(string)` (done), `tuple` (done), `object`
- [x] Every `variable` block has `type` and `description`
- [ ] The instance count comes from a `number` variable (done), and the tags come from one `map(string)` variable (done: the VPC's `tags = var.tags`)
- [ ] One list element is read by index (done: `cidr_blocks[0]` to `[2]`) and one object attribute is read by key (not yet)
- [x] A `set(string)` is read through `tolist()`, and I can explain why the direct index failed (checked in `terraform console`: `Invalid index`, then `tolist(...)[0]` works)
- [x] `terraform fmt -check -recursive`, `terraform validate`, `tflint` and `trivy config .` pass in the directory (HIGH/CRITICAL gate; one MEDIUM, VPC flow logs, left on purpose)
- [ ] `terraform plan` shows the values I expect (count and monitoring: done; tags and the tuple's port and protocol: not yet)
- [x] No `.terraform/`, state file or real `terraform.tfvars` is staged, and `.terraform.lock.hcl` is committed
- [x] The README in the directory says what the directory does and whether anything was applied (to be updated as tasks 7 to 10 land)

**Where I stopped (2026-11-10):** Tasks 1 to 8 of 10 are done (string, number, bool, list x2, set, map, tuple). Next is Task 9 (object `config`) and Task 10 (`deployment_summary` output).

## 5. Hints

Open one at a time, in order.

1. Nudge: the "Type constraints" page has a section for each of the three collection types and one for structural types. Read the one that matches the argument you are feeding.
2. Narrower: the provider docs for the resource tell you the type of each argument. Match your variable's type to that, and use `terraform console` to try an expression before you put it in a resource.
3. Last resort: for a set you need a function that turns it into a list before you index it. For a value that must be one of several allowed values, a `validation` block on the variable takes a condition and an error message.

## 6. Verify

| Command | Expected |
|---|---|
| `terraform fmt -check -recursive` | exit 0, no output |
| `terraform validate` | `Success! The configuration is valid.` |
| `tflint` | exit 0 |
| `trivy config .` | HIGH/CRITICAL gate exits 0 |
| `terraform plan` | the resource count and attribute values match the variables; an instance count of 1 plans one instance |
| `terraform console` then `var.<name>` | prints the value in the shape of its type |

Result so far (2026-11-09, plan only, run by Claude at my request): `fmt`, `validate` and `tflint` pass; `Plan: 4 to add, 0 to change, 0 to destroy.` (instance, VPC, two subnets; VPC `10.0.0.0/16`, subnets `10.0.1.0/24` and `10.0.2.0/24`). `-var ec2_instance_type=m5.24xlarge` fails with `Resource precondition failed` and `-var region=ap-south-1` fails with `Invalid value for variable`; `t2.small` and `eu-west-1` plan fine. `trivy` passes the HIGH/CRITICAL gate; one MEDIUM finding (AWS-0178, VPC flow logs) is left on purpose (see section 7).

Applying is optional. Anything with an EC2 instance bills (see section 8), so plan-only is enough to prove the types.

## 7. Gotchas and mistakes

From the video and the instructor's files (found while comparing, not mistakes I made yet):

- **`count` plus an unindexed output.** `aws_instance.example.id` fails with "Missing resource instance key" once `count` is set. Use an index (`aws_instance.example[0].id`) or the splat form `aws_instance.example[*].id`.
- **A list into a single-string argument.** `cidr_ipv4 = var.cidr_block` fails with "string required but have list of string". Take one element, or use a resource whose argument is a list.
- **A set indexed directly.** `var.allowed_region[0]` fails with "Elements of a set are identified only by their values". Use `tolist(var.allowed_region)[0]`, with the index outside the function call (the video first put the bracket inside and got "Invalid index").
- **Variables inside a variable default.** Not allowed. Build the value in a `locals` block instead.
- **The video calls the object a "dictionary" for a while** and then corrects itself. Terraform has no dictionary type; it is `map` or `object`.
- **The video says a tuple is "similar to a set".** It is ordered, so it is closer to a list.
- **`task.md` Task 4 is not valid on AWS.** It asks for a VPC on `10.0.0.0/8` with subnets on `192.168.0.0/16` and `172.16.0.0/12`. AWS accepts a VPC CIDR only between `/16` and `/28`, and a subnet must sit inside the VPC's CIDR, so `/8` is rejected and the two subnets are not inside it. Expect the apply (not the plan) to fail. This is the same CIDR math as Day 0.
- **The instructor's `main.tf` hard-codes an AMI ID.** AMI IDs differ per region and get retired, so a copied ID can fail. Look up a current Amazon Linux AMI in the console or with a data source instead.
- **The instructor's `main.tf` sets `availability_zone` from a set of zones** (`tolist(var.availability_zones)[0]`). That works but ties the instance to one zone by string; not a pattern to copy.
- **`task.md` Task 6 asks for a validation that reads another variable** (`contains(var.allowed_region, var.region)`). Referencing a different variable inside a `validation` block needs Terraform 1.9 or later. We run 1.17.1, so it works for us.
- **README mentions validation blocks and type conversion** but the video covers neither. They are in the docs pages listed in section 3.

My own mistakes from the hands-on:

- **`associate_public_ip` declared as `string`.** It worked in a plan because Terraform converts `"true"` to a bool, but `-var associate_public_ip=yes` then failed at the resource with "Incorrect attribute value type" instead of at the variable. With `type = bool` it fails at the variable: "Invalid value for input variable ... a bool is required". Claude changed the type and synced the example file and README at my request (an exception to the hints-only rule, 2026-11-09).

- **Task 4 first version could not apply.** The plan said `Plan: 6 to add` and looked fine, but the private subnets used `20.0.0.0/16`, outside the VPC's `10.0.0.0/16`, and `count = 2` on each subnet made two identical ranges, which overlap. A plan cannot see either problem; the apply would have failed with `InvalidSubnet.Range` or `InvalidSubnet.Conflict`. The list values `20.x` and `30.x` are also public internet ranges, not private ones. Fixed by making the list `[VPC /16, subnet /24, subnet /24]` inside one range and dropping `count`. A plan of `6 to add` instead of the expected `4` was the clue.
- **"Public" and "private" subnets are only names here.** There is no internet gateway or route table, so neither is public.
- **`trivy` findings on the instance.** AWS-0028 (IMDS token not required, HIGH) and AWS-0131 (root disk not encrypted, HIGH) blocked the CI `security-scan` check, which fails on HIGH and CRITICAL. Claude fixed both at my request (2026-11-09): `metadata_options { http_tokens = "required" }` and `root_block_device { encrypted = true }` on the instance. AWS-0178 (VPC flow logs off, MEDIUM) is left, because the gate ignores MEDIUM and flow logs need a log group and an IAM role.

- **Task 5, the check did nothing at first.** I ran `terraform plan -var ec2_instance_type=m5.24xlarge` and got no error. The instance read `var.allowed_vm_types[2]` (a fixed list entry), not `var.ec2_instance_type`, and there was no `precondition`, so the `-var` was ignored. The list's own `validation` only checked it was not empty. Claude fixed it at my request: the instance reads `ec2_instance_type` and has a `lifecycle` `precondition` using `contains`. A plain `plan` then failed with "No value for required variable" because `ec2_instance_type` was commented out in my local tfvars.
- **Task 6, three bugs in the first version.** The `region` validation hard-coded its own list (with `eu-west-1`) instead of reading the set; the set was named `allowed_regions` (plural) with a different default (`us-west-1`) and was unused, so `tflint` exited 2; and the example file used the singular name. My console test of the set index used the singular name, so it printed "undeclared input variable" instead of the set error. Claude fixed all of it at my request; the validation now reads `var.allowed_region`.
- **`tolist()` sorts a string set.** I wrote `us-east-1` first, but `tolist(var.allowed_region)[0]` is `eu-west-1`. The order is alphabetical, not the order I typed.

- **Task 7, variables inside a default.** My first `tags` default used `"${var.environment}"` and `"${local.name_prefix}"`; `validate` failed with `Variables not allowed` / `Variables may not be used here`, the same error the video shows. A `default` has to be a literal. Dynamic values go in `locals` (and later `merge()`). Other slips in that draft: the map had no `Name` key, so `var.tags["Name"]` would have failed with `Invalid index`; a `Project` key in the map would have overwritten the provider's `default_tags` `Project`, because a resource tag wins over a default tag; the VPC built its own inline tags instead of using the map, so `ManagedBy` never reached it; the output's description was copy-pasted from another resource. Claude fixed it at my request (2026-11-10): literal defaults (`Environment`, `Name = tf30-day07-dev-vpc`, `created_by`), `tags = var.tags` on the VPC, output renamed `vpc_name`.

- **Task 8, tuple length is part of the type.** My `ingress_value` default was `[443, "tcp", 0, 443]` (four values) for `tuple([number, string, number])` (three slots); `validate` failed with "This default value is not compatible with the variable's type constraint: tuple required". Also: the variable was named `ingress_value` while the task and my example file said `ingress_values`, it had no `description`, and the group's description said HTTP for port 443. Claude fixed it at my request (2026-11-10). Checked: a plan gives `Plan: 6 to add` with `from_port = 443`, `ip_protocol = "tcp"`, `to_port = 443`; `-var 'ingress_values=["tcp",443,443]'` fails with `Invalid value for input variable ... a number is required`, because the check is on position and type. The rule's source is the private subnet range (`cidr_blocks[2]`), not `0.0.0.0/0`, which keeps the `trivy` gate green.

My own mistakes from the Q&A:

- **Task 5, `precondition` versus `validation`:** I said `precondition` is for choosing from a list "not from AWS" and `validation` "just looks at the type". Gap: `validation` checks any condition on the input value, not only the type. The real difference is where they live and what they can see: `validation` sits on a variable and reads variables (other variables since Terraform 1.9); `precondition` sits in a resource, data or output `lifecycle` and can also read other resources and data sources. Here both values are variables, so `validation` would also work and would fail earlier. (Claude's wording; restate before any post.)
- **Task 6, set index:** correct. A set has no order and no duplicates, so there is no element 0; `tolist()` makes it indexable.
- **Task 2, `count` and `.id`:** I said `aws_instance.ec2_instance.id` "provides the instance ID after creation". True for one instance, but with `count` set the plain address fails with `Missing resource instance key` ("its attributes must be accessed on specific instances"). Use `[0].id` or `[*].id`. (Claude's wording; restate before any post.)
- **Task 4, `cidr_blocks[3]`:** correct, `Invalid index` (index is greater than or equal to the length of the collection; the list has indexes 0 to 2).

## 8. Cleanup

- [x] Nothing applied so far, so nothing to destroy. If anything is applied: `terraform destroy` (you run it), then a console check that no instance is left
- [ ] Billing check: **an EC2 instance bills while it exists**, and with `monitoring = true` the detailed monitoring is an extra charge per instance. A public IPv4 address on the instance is also billed per hour. Plan-only costs nothing.

## 9. LinkedIn worth

Possibly: "A Terraform `set` cannot be indexed. The error tells you why: with no order and no duplicates, there is no 'element 2'." Also the `task.md` Task 4 trap: a `/8` VPC CIDR is rejected by AWS. Both are added to `docs/LINKEDIN-IDEAS.md`.
