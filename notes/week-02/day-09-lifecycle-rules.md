# Day 9: Lifecycle rules

Video: [AWS Terraform Lifecycle Rules Explained](https://www.youtube.com/watch?v=60tOSwpvldY) (35 min) · Instructor code: [lessons/day09](https://github.com/piyushsachdeva/Terraform-Full-Course-Aws/tree/main/lessons/day09) (README, `task.md`, and a `code/` folder with `main.tf`, `variables.tf`, `locals.tf`, `outputs.tf`, `provider.tf`, `backend.tf`) · Verified against: Terraform 1.17.1 (pinned), AWS provider 6.73.0 (the Day 8 lock), [lifecycle docs](https://developer.hashicorp.com/terraform/language/meta-arguments/lifecycle) read on 2026-11-23

Source material for this note: the video transcript, the instructor's README, `task.md` and `code/`, and the Terraform lifecycle docs. My lifecycle key notes from Day 8 listed the four settings before the video. Hands-on and Q&A not started.

## 1. Goal

After today I can say what each `lifecycle` setting changes about create, update, replace and destroy, pick the right one for a situation, and name the trap in each.

## 2. Concepts

**What `lifecycle` is.** A meta-argument block inside any resource. The normal arguments say what the resource looks like; `lifecycle` says how Terraform is allowed to change it. Its values must be literals, because Terraform reads them before it evaluates expressions.

```
 Normal replace (default)        create_before_destroy = true
 1. destroy old                  1. create new
 2. create new                   2. move dependents to the new one
    (gap: nothing exists)        3. destroy old
    (create fails: nothing left)    (create fails: old one still running)
```

**The six settings.**

| Setting | What it changes | Typical use | The trap |
|---|---|---|---|
| `create_before_destroy` | On a replace, the new object is created before the old one is destroyed | Instances behind a load balancer, launch templates | Two objects exist at once, so a fixed unique name (bucket, security group name, table name) collides. It also spreads to every resource this one depends on |
| `prevent_destroy` | Any plan that destroys this resource fails, including a replace | State buckets, databases | Deleting the whole resource block bypasses it, because the rule lives in the block you deleted |
| `ignore_changes` | Listed attributes are used at create, then ignored on update, so drift in them is not reverted | ASG `desired_capacity`, tags added by other tools | Ignored drift is invisible in every later plan. `all` means Terraform never proposes an update at all |
| `replace_triggered_by` | Replaces this resource when another resource changes | Rebuild an instance when its config source changes | A whole resource reference fires on any update or replace of it. An attribute such as `.id` fires only when that value changes, and a security group's ID does not change when you edit its rules |
| `precondition` | A check that must be true before Terraform acts on the resource | Allowed region, required tags on an input | It can read other resources and data sources; a variable `validation` (Day 7) can only read variables |
| `postcondition` | A check on the resource's own result, through `self` | The bucket really has a `Compliance` tag | It runs after the object exists. A failure blocks the resources that depend on it, but does not undo the one it checks |

**`replace_triggered_by` only takes resources.** A variable or local has no planned action of its own, so it cannot trigger a replace directly. The docs' answer is to pass the value through a `terraform_data` resource and reference that.

**Condition blocks.** Both have `condition` (must be true) and `error_message`. `self` means "this resource's own attributes" and only makes sense in a postcondition. A check written against a variable, as in the video's demo, is really a precondition in a postcondition block.

**What is stored in state.** Only `create_before_destroy` is recorded in state. The other rules are read from the code every run, which is why removing `prevent_destroy` from the code is enough to allow a destroy; no apply is needed first.

## 3. Docs to read

- [ ] [lifecycle meta-argument](https://developer.hashicorp.com/terraform/language/meta-arguments/lifecycle) (all six settings, the three reference cases under `replace_triggered_by`, and what happens when a block with `prevent_destroy` is removed)
- [ ] [Custom conditions](https://developer.hashicorp.com/terraform/language/expressions/custom-conditions) (precondition versus postcondition versus variable validation, and what `self` can read)
- [ ] [terraform_data](https://developer.hashicorp.com/terraform/language/resources/terraform-data) (the stand-in resource for triggering a replace from a plain value)
- [ ] [aws_security_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) (which arguments force a replacement, and `name_prefix`)
- [ ] [aws_region data source](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) (`region` is the current attribute; `name` is deprecated)

## 4. Challenge

The instructor's `task.md` only asks for a blog and posts, which we skip until the course ends. The video builds an EC2 instance and an Auto Scaling Group with five instances, which bill. This challenge tests every setting with free resources instead: empty S3 buckets, a VPC with security groups, and `terraform_data`. The one KMS key the bucket encryption needs costs cents.

Work in `sandbox/day-09-lifecycle/`, copying the Day 8 file layout. Local state. Every name starts with `tf30-day09-`, every resource gets the `Project` tag, and the region comes from a variable.

Most of these behaviours only show on an apply, so this day is meant to be applied and destroyed. You run every `apply` and `destroy`.

Acceptance criteria:

- [ ] **prevent_destroy:** a bucket with `prevent_destroy = true`. `terraform plan -destroy` fails with an error that names the rule. I can say what happens if I delete the whole block instead, and why
- [ ] **create_before_destroy collision:** a security group with a fixed `name` and `create_before_destroy = true`. Change an argument that forces a replacement. Before running it, I write down what I expect; then the apply shows the duplicate-name error
- [ ] **create_before_destroy fixed:** the same group with `name_prefix` instead of `name`, so the replace succeeds, and the apply output shows "Creating" before "Destroying"
- [ ] **ignore_changes:** a resource ignores changes to `tags`. I change a tag in the console, and `terraform plan` shows no changes. With the rule removed, the plan shows the update
- [ ] **replace_triggered_by, two ways:** a `terraform_data` resource that references a security group with `.id` and a second one that references the whole group. Editing one ingress rule in place replaces only the second one. I can explain why from the plan text
- [ ] **precondition:** a resource checks that the current region (from the `aws_region` data source, using `region`, not the deprecated `name`) is in an allowed set. A plan in a region outside the set fails with my error message
- [ ] **postcondition:** a bucket checks `self.tags` for a `Compliance` key. I can say whether a failure would leave the bucket created
- [ ] `terraform fmt -check -recursive`, `terraform validate`, `tflint` and `trivy config .` pass in the directory (HIGH/CRITICAL gate)
- [ ] After `destroy` (with `prevent_destroy` removed first), the console shows no `tf30-day09-` resources
- [ ] The directory README says what it does and what was applied

## 5. Hints

Open one at a time, in order.

1. Nudge: every setting is on one docs page, the lifecycle meta-argument. For the security group, the provider page marks which arguments force a new resource.
2. Narrower: for the collision, think about which argument AWS requires to be unique per VPC, and what exists at the moment the new group is created. For `replace_triggered_by`, read the three bullets that start "If the reference is to...". For the region, the data source with no arguments describes the provider's current region.
3. Last resort, in words only: a security group's description cannot change in place. `name_prefix` lets AWS add a random suffix so two groups can exist at once. A rule edit is an update to the group, not a replacement, so its ID stays the same. `contains()` checks whether a set holds a value, and `keys()` turns a map into a list of its keys.

## 6. Verify

| Command | Expected |
|---|---|
| `terraform plan -destroy` (prevent_destroy on) | Error: `Instance cannot be destroyed`, naming the resource and the `lifecycle.prevent_destroy` rule |
| `terraform apply` after forcing a security group replace with a fixed `name` and `create_before_destroy` | Fails with a duplicate group name error (`InvalidGroup.Duplicate`); the old group is still there |
| The same with `name_prefix` | `1 to add, 0 to change, 1 to destroy`; "Creation complete" for the new group comes before "Destruction complete" for the old one |
| `terraform plan` after a console tag change, with `ignore_changes = [tags]` | `No changes. Your infrastructure matches the configuration.` |
| `terraform plan` after an in-place rule edit | Only the whole-resource `terraform_data` shows `will be replaced, due to changes in replace_triggered_by` |
| `terraform plan -var region=<not allowed>` | My precondition `error_message` |
| Console, after destroy | No `tf30-day09-` buckets or security groups |

Expected error texts are from memory of the docs and earlier runs, not from a run of this code yet. Correct them here after the hands-on.

## 7. Gotchas and mistakes

**Traps in the video and the instructor material** (checked against the lifecycle docs on 2026-11-23):

- **`replace_triggered_by` with `.id` does not fire on "any change".** The video and the README reference `aws_security_group.app_sg.id` and say any change to the group replaces the instance. The docs say an attribute reference fires only when that value changes. Editing a rule updates the group in place and keeps its ID, so nothing is replaced. Referencing the whole resource fires on any update or replace.
- **"create_before_destroy should always be true" (video).** The default is destroy-then-create for a reason: many resources need a unique name, and two of them exist at once during a create-before-destroy replace. The instructor's own code shows the trap. Example 7 sets it on S3 buckets with fixed names, the DynamoDB table has a fixed name, and the security group is named `app-security-group`. Each of those replaces would fail on the name. The setting also spreads to every resource it depends on.
- **Removing `prevent_destroy` (README).** The README says to comment it out, run `terraform apply` "to update the state", then destroy. The rule is not stored in state (only `create_before_destroy` is), so removing it from the code is enough. The bigger catch, missing from both: deleting the whole resource block destroys the resource even with `prevent_destroy`, because the rule went with the block.
- **README "Pattern 1": `prevent_destroy` plus `create_before_destroy` for RDS.** `prevent_destroy` blocks a replace too, because a replace includes a destroy. The video shows this when it says an AMI change is blocked. So the pair does not give a zero-downtime replacement; it stops the replacement.
- **The video's postcondition reads `var.tags`, not `self.tags`.** That checks the input, so it works like a precondition. The video also says the bucket is only created if the check passes. A real postcondition runs after the object exists, and a failure stops the resources that depend on it, not the creation of that bucket. The README's version uses `self.tags`, which is right.
- **"ignore changes will not do any changes on the resource" (video).** Only the listed attributes are ignored, and only on update. They are still used at create.
- **`data.aws_region.current.name` is deprecated** in AWS provider 6. The instructor's code uses it in four places. Use `region`.
- **Auto Scaling Group availability zones.** The video says `availability_zones` is mandatory. My reading of the docs is that you give either `availability_zones` or `vpc_zone_identifier` (subnets). Unverified; check the resource page before relying on it.
- **The `tolist()` region puzzle.** The video gets `eu-west-1` from `tolist(var.allowed_region)[0]` and leaves the reason as homework. It is the Day 7 lesson: `tolist()` on a set of strings returns it sorted, and `eu-west-1` sorts first.
- **A hard-coded password default.** `variables.tf` sets `db_password` to `"ChangeMe123!"`. A secret default ends up in Git and state; mark it `sensitive` with no default, or use a secrets manager.
- **Cost and cleanup in the video.** The demo creates an EC2 instance, a launch template and an ASG that scaled to five instances, in an account that also runs other instances. It also destroys with `-auto-approve`. We avoid both.

My own mistakes: none yet (hands-on not started).

## 8. Cleanup

- [ ] Remove `prevent_destroy` from the code, then `terraform destroy` (you run it)
- [ ] Console check: no `tf30-day09-` buckets or security groups; the KMS key is `PendingDeletion`
- [ ] Billing check

## 9. LinkedIn worth

Yes, three candidates, logged in `docs/LINKEDIN-IDEAS.md`: `replace_triggered_by` with `.id` versus the whole resource; `prevent_destroy` does not survive deleting the block; `create_before_destroy` plus a fixed name is a guaranteed failure. Confirm each with my own apply output before posting.
