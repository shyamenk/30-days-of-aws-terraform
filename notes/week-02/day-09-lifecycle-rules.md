# Day 9: Lifecycle rules

Video: [AWS Terraform Lifecycle Rules Explained](https://www.youtube.com/watch?v=60tOSwpvldY) (35 min) · Instructor code: [lessons/day09](https://github.com/piyushsachdeva/Terraform-Full-Course-Aws/tree/main/lessons/day09) (README, `task.md`, and a `code/` folder with `main.tf`, `variables.tf`, `locals.tf`, `outputs.tf`, `provider.tf`, `backend.tf`) · Verified against: Terraform 1.17.1 (pinned), AWS provider 6.73.0 (the Day 8 lock), [lifecycle docs](https://developer.hashicorp.com/terraform/language/meta-arguments/lifecycle) read on 2026-11-23

Source material for this note: the video transcript, the instructor's README, `task.md` and `code/`, the Terraform lifecycle docs, and my key notes (a revision table, five concepts and a production scenario, in section 2). Hands-on: Tasks 1 to 3 applied and destroyed on 2026-11-23; I closed the day there, so Tasks 4 to 7 and the Q&A were skipped by my choice.

## 1. Goal

After today I can say what each `lifecycle` setting changes about create, update, replace and destroy, pick the right one for a situation, and name the trap in each.

## 2. Concepts

**What `lifecycle` is.** A meta-argument block inside a resource. The normal arguments say what the resource looks like; `lifecycle` says how Terraform is allowed to change it. The settings that shape the dependency graph (`create_before_destroy`, `prevent_destroy`, `ignore_changes`) take literal values only, because Terraform processes them before it evaluates expressions. `replace_triggered_by` takes resource references, and the conditions in `precondition` and `postcondition` are full expressions.

```
 Normal replace (default)        create_before_destroy = true
 1. destroy old                  1. create new
 2. create new                   2. move dependents to the new one
    (gap: nothing exists)        3. destroy old
    (create fails: nothing left)    (create fails: old one still running)
```

**The six settings the video covers.**

| Setting | What it changes | Typical use | The trap |
|---|---|---|---|
| `create_before_destroy` | On a replace, the new object is created before the old one is destroyed | Instances behind a load balancer, launch templates | Two objects exist at once, so a fixed unique name (bucket, security group name, table name) collides; Terraform cannot turn on a provider's random-suffix option for you. It also spreads to every resource this one depends on, and stops destroy-time provisioners (Day 19) from running |
| `prevent_destroy` | Any plan that destroys this resource fails, including a replace and `terraform destroy` | State buckets, databases | Deleting the whole resource block bypasses it, because the rule lives in the block you deleted. The docs say to use it sparingly |
| `ignore_changes` | Listed attributes are used at create, then ignored on update, so drift in them is not reverted | ASG `desired_capacity`, tags added by other tools | Ignored drift is invisible in every later plan. `all` means Terraform can still create and destroy the object but never proposes an update. One map key or list item works too: `tags["Name"]`, `list[0]`. Only the resource type's own attributes count, not meta-arguments |
| `replace_triggered_by` | Replaces this resource when another resource changes | Rebuild an instance when its config source changes | A reference to a whole resource or one instance fires on any planned update or replace of it. A reference to one attribute, such as `.id`, fires only when that value changes. A security group's ID changes when the group is replaced, but not when you edit its rules in place |
| `precondition` | A check that must be true before Terraform acts on the resource | Allowed region, required tags on an input | It can read any object in the same scope (other resources, data sources, variables) unless that makes a cycle; a variable `validation` (Day 7) can only read variables |
| `postcondition` | A check on the resource's own result, through `self` | The bucket really has a `Compliance` tag | It runs after the object exists. A failure blocks the resources that depend on it, but does not undo the one it checks |

**Two more settings on the docs page that the video skips.**

- `destroy = false`: removes a resource from state without destroying the real object. The docs link it to "Remove a resource from state". I have not checked which blocks accept it.
- `action_trigger`: runs provider "actions" on events such as `before_create`, `after_update` or `after_destroy`, with an optional `condition` and an `on_failure` choice (`halt` is the default, then `continue` or `taint`). The page gives no example and no version note.

**`replace_triggered_by` only takes managed resources.** It accepts resources, instances or instance attributes. Inside a `count` or `for_each` block, `count.index` or `each.key` picks the matching instance of the other resource. A variable or local has no planned action of its own, so it cannot trigger a replace directly; pass the value through a `terraform_data` resource and reference that. The docs' own example references `aws_ecs_service.svc.id`, which works because it is meant to fire when the service is replaced and gets a new ID.

**Condition blocks.** Both have `condition` (must be true) and `error_message`, both required. They work in `resource`, `data` and `ephemeral` blocks. A precondition runs before Terraform evaluates the resource's own arguments, but after `count` and `for_each`, so `count.index` and `each.key` are available. `self` means "this resource's own attributes" and only makes sense in a postcondition. A check written against a variable, as in the video's demo, is really a precondition in a postcondition block. The docs warn not to put conditions on both a `resource` and a `data` block that describe the same object.

**What is stored in state.** Of the rules, only `create_before_destroy` is recorded, including when it was turned on by spreading from a dependent resource. Condition results are recorded too, but not the conditions themselves. The other rules are read from the code every run, which is why removing `prevent_destroy` from the code is enough to allow a destroy; no apply is needed first.

### My key notes (2026-11-23)

Lifecycle rules control how Terraform creates, updates, replaces and deletes infrastructure.

| Rule | Simple meaning |
|---|---|
| `create_before_destroy` | Create new, then delete old |
| `prevent_destroy` | Block accidental destruction |
| `ignore_changes` | Ignore selected attribute changes |
| `replace_triggered_by` | Replace when another resource changes |
| `precondition` | Validate before the operation |
| `postcondition` | Validate after the operation |
| `action_trigger` | Run provider actions on lifecycle events |
| `destroy` | Remove from state without deleting the infrastructure |

Concepts to remember:

1. Lifecycle rules are defined inside resource blocks. (Checked against the docs: the two conditions also work in `data` and `ephemeral` blocks.)
2. Not every lifecycle rule is supported by every configuration block.
3. Lifecycle configuration is processed early, so lifecycle settings generally need literal values, not dynamic expressions. (Checked: true for `create_before_destroy`, `prevent_destroy` and `ignore_changes`. `replace_triggered_by` takes references and conditions are full expressions.)
4. `prevent_destroy` is not permanent protection. Removing the resource's configuration also removes the protection.
5. Always read `terraform plan` before applying a lifecycle change.

**Practical scenario: a production SaaS app on AWS.** EC2 instances run the app, RDS PostgreSQL holds the data, S3 stores customer documents, plus ECS services and Auto Scaling. Three requirements, three rules:

```hcl
# 1. EC2: minimize downtime during replacement (availability)
resource "aws_instance" "app" {
  ami           = "ami-123456"
  instance_type = "t3.medium"

  lifecycle {
    create_before_destroy = true
  }
}

# 2. RDS: protect the production database (protection)
resource "aws_db_instance" "production" {
  identifier        = "production-db"
  engine            = "postgres"
  instance_class    = "db.t3.medium"
  allocated_storage = 50

  lifecycle {
    prevent_destroy = true
  }
}

# 3. S3: ignore a tag managed by an external system (shared ownership)
resource "aws_s3_bucket" "documents" {
  bucket = "production-customer-documents"

  lifecycle {
    ignore_changes = [
      tags["Owner"]
    ]
  }
}
```

Review of the scenario against this day's lessons:

- **EC2 and `create_before_destroy`:** safe here because an instance has no unique name. Adding the same rule to the RDS instance would fail, because `identifier` must be unique and two databases would exist at once.
- **RDS and `prevent_destroy`:** this guards against a plan only. Because of point 4, a second layer that lives in AWS is common practice: the database's `deletion_protection` setting, which stays on even if the Terraform block is deleted.
- **S3 and `tags["Owner"]`:** this uses the map-key form from the docs, so only the `Owner` tag is ignored and the other tags are still enforced.
- **The other two services fit the remaining rules:** `ignore_changes = [desired_capacity]` on the Auto Scaling Group (as in the video), and `replace_triggered_by` on anything that must be rebuilt when an ECS service is replaced (the docs' own example).

## 3. Docs to read

- [ ] [lifecycle meta-argument](https://developer.hashicorp.com/terraform/language/meta-arguments/lifecycle) (the "State" and "Usage" sections first, then all eight settings, the three reference cases under `replace_triggered_by`, and the four example use cases at the bottom). Claude read it for this note on 2026-11-23; read it yourself before the hands-on
- [ ] [Custom conditions](https://developer.hashicorp.com/terraform/language/expressions/custom-conditions) (precondition versus postcondition versus variable validation, and what `self` can read)
- [ ] [terraform_data](https://developer.hashicorp.com/terraform/language/resources/terraform-data) (the stand-in resource for triggering a replace from a plain value)
- [ ] [aws_security_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) (which arguments force a replacement, and `name_prefix`)
- [ ] [aws_region data source](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) (`region` is the current attribute; `name` is deprecated)

## 4. Challenge

The instructor's `task.md` only asks for a blog and posts, which we skip until the course ends. The video builds an EC2 instance and an Auto Scaling Group with five instances, which bill. This challenge tests every setting with free resources instead: empty S3 buckets, a VPC with security groups, and `terraform_data`. The one KMS key the bucket encryption needs costs cents.

Work in `sandbox/day-09-lifecycle/`, copying the Day 8 file layout. Local state. Every name starts with `tf30-day09-`, every resource gets the `Project` tag, and the region comes from a variable.

Most of these behaviours only show on an apply, so this day is meant to be applied and destroyed. You run every `apply` and `destroy`.

Acceptance criteria:

- [x] **prevent_destroy:** a bucket with `prevent_destroy = true`. `terraform plan -destroy` fails with an error that names the rule. I can say what happens if I delete the whole block instead, and why (done 2026-11-23)
- [x] **create_before_destroy collision:** a security group with a fixed `name` and `create_before_destroy = true`. Change an argument that forces a replacement. Before running it, I write down what I expect; then the apply shows the duplicate-name error (done 2026-11-23)
- [x] **create_before_destroy fixed:** the same group with `name_prefix` instead of `name`, so the replace succeeds, and the apply output shows "Creating" before "Destroying" (done 2026-11-23; the replace succeeded, but the apply output was not pasted, so the create-first order itself is unverified)
- [ ] (skipped: day closed after Task 3) **ignore_changes:** a resource ignores changes to `tags`. I change a tag in the console, and `terraform plan` shows no changes. With the rule removed, the plan shows the update
- [ ] (skipped: day closed after Task 3) **replace_triggered_by, two ways:** a `terraform_data` resource that references a security group with `.id` and a second one that references the whole group. Editing one ingress rule in place replaces only the second one. I can explain why from the plan text
- [ ] (skipped: day closed after Task 3) **precondition:** a resource checks that the current region (from the `aws_region` data source, using `region`, not the deprecated `name`) is in an allowed set. A plan in a region outside the set fails with my error message
- [ ] (skipped: day closed after Task 3) **postcondition:** a bucket checks `self.tags` for a `Compliance` key. I can say whether a failure would leave the bucket created
- [x] `terraform fmt -check -recursive`, `terraform validate`, `tflint` and `trivy config .` pass in the directory (HIGH/CRITICAL gate)
- [x] After `destroy` (with `prevent_destroy` removed first), the CLI checks show no `tf30-day09-` resources
- [x] The directory README says what it does and what was applied

## 5. Hints

Open one at a time, in order.

1. Nudge: every setting is on one docs page, the lifecycle meta-argument. For the security group, the provider page marks which arguments force a new resource.
2. Narrower: for the collision, think about which argument AWS requires to be unique per VPC, and what exists at the moment the new group is created. For `replace_triggered_by`, read the three bullets that start "If the reference is to...". For the region, the data source with no arguments describes the provider's current region.
3. Last resort, in words only: a security group's description cannot change in place. `name_prefix` lets AWS add a random suffix so two groups can exist at once. A rule edit is an update to the group, not a replacement, so its ID stays the same. `contains()` checks whether a set holds a value, and `keys()` turns a map into a list of its keys.

## 6. Verify

| Command | Expected |
|---|---|
| `terraform plan -destroy` (prevent_destroy on, after an apply; against empty state there is nothing to destroy, so it cannot fail) | Error: `Instance cannot be destroyed`, naming the resource and the `lifecycle.prevent_destroy` rule |
| `terraform apply` after forcing a security group replace with a fixed `name` and `create_before_destroy` | Fails with a duplicate group name error (`InvalidGroup.Duplicate`); the old group is still there |
| The same with `name_prefix` | `1 to add, 0 to change, 1 to destroy`; "Creation complete" for the new group comes before "Destruction complete" for the old one |
| `terraform plan` after a console tag change, with `ignore_changes = [tags]` | `No changes. Your infrastructure matches the configuration.` |
| `terraform plan` after an in-place rule edit | Only the whole-resource `terraform_data` shows `will be replaced, due to changes in replace_triggered_by` |
| `terraform plan -var region=<not allowed>` | My precondition `error_message` |
| Console, after destroy | No `tf30-day09-` buckets or security groups |

Expected error texts are from memory of the docs and earlier runs, not from a run of this code yet. Correct them here after the hands-on.

Task 1 result (2026-11-23): I ran `apply` (`4 added`; outputs `bucket_id` and `bucket_name` are the same string, because an S3 bucket's ID is its name). `terraform plan -destroy` computed `0 to add, 0 to change, 4 to destroy` and then failed: `Error: Instance cannot be destroyed` on `main.tf` line 1, "Resource aws_s3_bucket.protected has lifecycle.prevent_destroy set, but the plan calls for this resource to be destroyed". The whole plan is rejected, so the three unprotected resources are not destroyed either. The error offers two ways out: disable the rule or narrow the plan with `-target`.

Task 1 cleanup (2026-11-23, my choice, before Task 2): removed `prevent_destroy` from `main.tf` (Claude made the edit at my request); the next `plan -destroy` passed at once with `4 to destroy`, which proves no apply is needed after removing the rule. I ran `terraform destroy`: `Destroy complete! Resources: 4 destroyed.` `head-bucket` returned `404 Not Found`. The KMS key still shows in the tagging API, which lists keys during their 7-day deletion window; `describe-key` confirmed `PendingDeletion`. Task 1 files (`main.tf`, `security.tf`, `outputs.tf`) then deleted at my request; this note is the Task 1 record.

Task 2 result (2026-11-23): a VPC (`10.0.0.0/16`) and a security group with the fixed `name = "tf30-day09-web"` and `create_before_destroy = true`; I applied them (`2 added`). Changing only the description planned `# aws_security_group.web must be replaced`, shown as `+/-` (create first), with `description ... # forces replacement` and `1 to add, 0 to change, 1 to destroy`. The apply printed `Creating...` and failed at once: `api error InvalidGroup.Duplicate: The security group 'tf30-day09-web' already exists for VPC`. No `Destroying...` line: the old group was untouched, because Terraform only destroys after the create succeeds. The plan already listed `+ name_prefix = (known after apply)`. Cleanup (my choice, before Task 3): I ran `terraform destroy`; `state list` was empty and both `describe-vpcs` and `describe-security-groups` returned `[]`.

Task 3 result so far (2026-11-23): with `name_prefix = local.prefix` (`tf30-day09-web-`), I applied the VPC and group; `state show` gave `name = "tf30-day09-web-449ea3e7..."`. My first description change added a `~`. The plan was a clean `+/-` replace, but the apply failed on the create: `InvalidParameterValue: Invalid security group description` (allowed characters are `a-zA-Z0-9. _-:/()#,@[]+=&;{}!$*`). No duplicate-name error this time (the new group had a different suffix). Because the create failed first, the old group was never destroyed: `create_before_destroy` kept a working group in place. A plan cannot see AWS validation rules, as with the Day 7 subnets. With a valid description (`...test.....`) the replace succeeded: `state list` held only the VPC and the group (no deposed object), the group had a new ID and the name `tf30-day09-web-5d9121d3...` (a new suffix), and the next `plan` said `No changes`. Cleanup: I ran `terraform destroy` (`2 to destroy`); local state empty, `describe-vpcs` and `describe-security-groups` both `[]`.

## 7. Gotchas and mistakes

**Traps in the video and the instructor material** (checked against the lifecycle docs on 2026-11-23):

- **`replace_triggered_by` with `.id` does not fire on "any change".** The video and the README reference `aws_security_group.app_sg.id` and say any change to the group replaces the instance. The docs say an attribute reference fires only when that value changes. Editing a rule updates the group in place and keeps its ID, so nothing is replaced. Referencing the whole resource fires on any update or replace.
- **"create_before_destroy should always be true" (video).** The default is destroy-then-create for a reason: many resources need a unique name, and two of them exist at once during a create-before-destroy replace. The instructor's own code shows the trap. Example 7 sets it on S3 buckets with fixed names, the DynamoDB table has a fixed name, and the security group is named `app-security-group`. Each of those replaces would fail on the name. The setting also spreads to every resource it depends on.
- **Removing `prevent_destroy` (README).** The README says to comment it out, run `terraform apply` "to update the state", then destroy. The rule is not stored in state (only `create_before_destroy` is), so removing it from the code is enough. The bigger catch, missing from both: deleting the whole resource block destroys the resource even with `prevent_destroy`, because the rule went with the block.
- **README "Pattern 1": `prevent_destroy` plus `create_before_destroy` for RDS.** `prevent_destroy` blocks a replace too, because a replace includes a destroy. The video shows this when it says an AMI change is blocked. So the pair does not give a zero-downtime replacement; it stops the replacement.
- **The video's postcondition reads `var.tags`, not `self.tags`.** That checks the input, so it works like a precondition. The video also says the bucket is only created if the check passes. A real postcondition runs after the object exists, and a failure stops the resources that depend on it, not the creation of that bucket. The README's version uses `self.tags`, which is right.
- **"ignore changes will not do any changes on the resource" (video).** Only the listed attributes are ignored, and only on update. They are still used at create.
- **`data.aws_region.current.name` is deprecated** in AWS provider 6. The instructor's code uses it in four places. Use `region`.
- **The docs page contradicts itself once.** Its encrypted-root-volume example says the check belongs in a postcondition "in the resource", but the example puts it on a `data "aws_ebs_volume"` block. Both places are valid; the prose is just out of step with the code.
- **Auto Scaling Group availability zones.** The video says `availability_zones` is mandatory. My reading of the docs is that you give either `availability_zones` or `vpc_zone_identifier` (subnets). Unverified; check the resource page before relying on it.
- **The `tolist()` region puzzle.** The video gets `eu-west-1` from `tolist(var.allowed_region)[0]` and leaves the reason as homework. It is the Day 7 lesson: `tolist()` on a set of strings returns it sorted, and `eu-west-1` sorts first.
- **A hard-coded password default.** `variables.tf` sets `db_password` to `"ChangeMe123!"`. A secret default ends up in Git and state; mark it `sensitive` with no default, or use a secrets manager.
- **Cost and cleanup in the video.** The demo creates an EC2 instance, a launch template and an ASG that scaled to five instances, in an account that also runs other instances. It also destroys with `-auto-approve`. We avoid both.

My own mistakes:

- **Task 1, first draft (2026-11-23):** I copied the whole Day 8 folder, so the plan was `16 to add` (five buckets from `count`, `for_each` and `depends_on`) instead of one protected bucket. `prevent_destroy` sat on the `count` block, so it guarded both buckets.
- **Task 1, second draft:** trimmed to one bucket, but the old label `depends_buckets`, a keyboard-mash name (`tf30-day09-hsdhsdf6`), plural output names and misspelled descriptions remained, and two unused Day 8 variables failed `tflint` (`terraform_unused_declarations`). Claude renamed the labels, bucket name, outputs and descriptions at my request (waiver of hints-only, names and strings only), then removed the two unused variables at my request (second waiver). Gate passes, plan `4 to add`.
- **Task 2 drafts (2026-11-23):** first draft used `name = "allow_tls"` copied from the docs example (the `Name` tag held `tf30-day09-web`, but AWS checks the `name` argument, not the tag), a description promising rules the group did not have, and an empty `output.tf`. Fixed by me after hints.
- **Task 2 prediction:** half right. I said the new group is created and then the old one destroyed (right order), but missed that the create fails on the duplicate name while the old group still exists.
- **Task 2 recall, why the default succeeds:** wrong at first (I said `false` makes no changes). `false` still replaces; it only changes the order. Restated in my own words: "default deletes old first so name is free, then creates".
- **Task 3 drafts (2026-11-23):** four tries. I kept the `name` argument and changed only its value: `"${local.prefix}-test"`, then the hyphen moved into the local, then `local.prefix` alone. Each plan still showed `+ name = "tf30-day09-..."`, a fixed name that would collide again. Lesson: a local called `prefix` is just a value; what makes AWS add a random suffix is the argument `name_prefix`. Fixed by me on the fourth try after the hints narrowed to the word before `=`.
- **Task 3 recall, what `name_prefix` costs:** half right. I said it avoids name conflicts, which is the gain. The cost: the full name is unknown until apply and changes on every replace, so scripts, policies and console searches cannot use a fixed name; read it from `.name` or an output. (Claude's wording; restate before any post.)
- **Task 1 answers (2026-11-23), both right:** removing `prevent_destroy` needs no apply before `destroy`, because the rule is not in state (only `create_before_destroy` is). Deleting the whole block destroys the bucket, because the rule goes with the block. Added by Claude: the public access block and encryption config still reference the bucket, so `validate` fails until they are removed too; a guard that lives in AWS (RDS `deletion_protection`, a bucket policy denying `s3:DeleteBucket`) survives a deleted block.

## 8. Cleanup

- [x] Remove `prevent_destroy` from the code, then `terraform destroy` (you run it)
- [x] CLI check (state list, `head-bucket`, `describe-vpcs`, `describe-security-groups`, `describe-key`): no `tf30-day09-` buckets or security groups; the KMS key is `PendingDeletion`
- [ ] Billing check (not done; the only billable item was one KMS key for about an hour, now `PendingDeletion`)

## 9. LinkedIn worth

Yes, logged in `docs/LINKEDIN-IDEAS.md`. Seen in my own output: `create_before_destroy` plus a fixed name failing with `InvalidGroup.Duplicate` (Task 2); create-first keeping the old group alive when the new one failed AWS validation (Task 3); a local called `prefix` that was still a fixed `name` (Task 3). Reasoned or from the docs only, so confirm before posting: `replace_triggered_by` with `.id`; `prevent_destroy` not surviving a deleted block.
