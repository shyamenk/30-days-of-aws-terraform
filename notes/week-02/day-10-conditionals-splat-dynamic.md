# Day 10: Conditionals, splat and dynamic blocks

Video: [AWS Terraform Conditional Expressions, Splat Expressions and Dynamic Block](https://www.youtube.com/watch?v=R4ShnFDJwI8) (39 min) · Instructor code: [lessons/day10](https://github.com/piyushsachdeva/Terraform-Full-Course-Aws/tree/main/lessons/day10) (`readme.md`, `task.md`, and a `code/` folder with `main.tf`, `variables.tf`, `outputs.tf`, `provider.tf`) · Verified against: Terraform 1.17.1 (pinned), AWS provider 6.73.0 (the Day 9 lock), and the conditionals, splat, dynamic blocks and `aws_security_group` docs read on 2026-11-23

Source material for this note: the video transcript, the instructor's readme, `task.md` and `code/`, and the four doc pages above (checked on 2026-11-23). No key notes pasted yet. Hands-on and Q&A not started.

## 1. Goal

After today I can pick a value with a conditional expression, switch a resource on or off with `count`, generate repeated nested blocks with `dynamic`, and collect one attribute from many instances with a splat, and I know where each one stops working.

## 2. Concepts

**What these are.** Expressions, not functions. The video calls them "a replacement of functions", which is loose: functions (Days 11 and 12) are named built-ins such as `upper()`. These are syntax that produces a value (`? :`, `[*]`) or generates blocks (`dynamic`).

```
 Conditional    var.environment == "prod" ? "large" : "small"     pick one of two values
 Splat          aws_instance.web[*].id                              one attribute from every instance
 Dynamic        dynamic "ingress" { for_each = ... content {...} }  one nested block per item
```

**Conditional expression.** `condition ? true_value : false_value`. The condition must be a `bool`. The two results must have the same type, or Terraform converts them to one it can use for both: `var.example ? 12 : "hello"` always returns a string. The docs suggest converting explicitly (`tostring()`) instead of relying on that. Two common uses:

- Pick a value: `instance_type = var.environment == "prod" ? "t3.large" : "t3.micro"`.
- Switch a resource on or off: `count = var.create_item ? 1 : 0`. The resource is then a list of zero or one, so you refer to it as `resource.name[0]`.

**Dynamic block.** Some resources take repeated nested blocks (a security group's `ingress`). A `dynamic` block writes one of them per item of a collection:

```
dynamic "ingress" {              # the label is the nested block's type
  for_each = var.ingress_rules   # a list, set or map
  iterator = rule                # optional; the default name is the label ("ingress")
  content {                      # the body of each generated block
    from_port = rule.value.from_port
  }
}
```

Inside `content`, the current item is `<iterator>.value`, and `<iterator>.key` is the list index or the map key. For a set, `key` is the same as `value`. It is **not** `each.value`; `each` belongs to a resource's own `for_each` (Day 8). A dynamic block cannot generate meta-argument blocks such as `lifecycle` or `provisioner`, because Terraform reads those before it evaluates expressions (the Day 9 rule again). The docs warn against overuse: "Always write nested blocks out literally where possible."

**Splat expression.** `list[*].attr` is shorthand for `[for o in list : o.attr]`. It works on lists, sets and tuples, so on a resource made with `count`. It does **not** work on maps or objects, so not on a resource made with `for_each`, which is a map of instances. Use `[for k, v in resource.name : v.id]` or `values(resource.name)[*].id` there. On a single non-null value, a splat wraps it into a one-item list; on `null` it returns an empty list. The old `.*` form still works but is not recommended.

```
 count resource                       for_each resource
 aws_instance.web    (a list)          aws_s3_bucket.b    (a map)
   [0] { id = "i-a" }                    ["logs"] { id = "logs" }
   [1] { id = "i-b" }                    ["data"] { id = "data" }
 aws_instance.web[*].id                aws_s3_bucket.b[*].id    -> error
   -> ["i-a", "i-b"]                   values(aws_s3_bucket.b)[*].id -> works
```

**Why `aws_instance.example.id` fails with `count`.** With `count` set, the address is a list of instances, so Terraform asks which one: `Missing resource instance key`. The video then tried `aws_instance.example.id[0]`, which fails with "does not have indices" because the index went on the ID string, not on the resource. The working forms are `aws_instance.example[0].id` for one instance and `aws_instance.example[*].id` for all of them.

**Locals are `local.`, not `locals.`.** The block is `locals { }`, but a reference is `local.all_instance_ids`. The video's `locals.all_instance_id` failed with an error that a managed resource with that name "has not been declared in the root module", because Terraform read `locals` as a resource type.

**Security group rules: inline versus separate.** The video's dynamic block generates inline `ingress` blocks. The provider docs now say to avoid inline rules and to use one `aws_vpc_security_group_ingress_rule` (or `_egress_rule`) resource per rule, with one CIDR block each. They also warn never to mix the two styles on one group: "rule conflicts, perpetual differences, and ... rules being overwritten". The dynamic-block pattern is still worth learning for resources that have no separate rule resource.

## 3. Docs to read

- [ ] [Conditional expressions](https://developer.hashicorp.com/terraform/language/expressions/conditionals) (the syntax, both results the same type, the `count = var.enabled ? 1 : 0` switch)
- [ ] [Splat expressions](https://developer.hashicorp.com/terraform/language/expressions/splat) (`[*]` as shorthand for `for`, a single non-list value, why it fails on maps and `for_each` resources, the old `.*`)
- [ ] [Dynamic blocks](https://developer.hashicorp.com/terraform/language/expressions/dynamic-blocks) (`for_each`, `content`, `iterator`; no meta-argument blocks such as `lifecycle`; the overuse warning)
- [ ] [for expressions](https://developer.hashicorp.com/terraform/language/expressions/for) (Day 8 refresher: when a splat is enough and when you need `for` with `if` or maps)
- [ ] [terraform console](https://developer.hashicorp.com/terraform/cli/commands/console) (test expressions with nothing created in AWS)
- [ ] [aws_security_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) (the notes near the top: what the provider recommends instead of inline `ingress` rules)

## 4. Challenge

The instructor's `task.md` asks for one configuration that shows all three expressions, plus a blog and posts, which we skip until the course ends. The video and the instructor code use EC2 instances, which bill. This challenge uses free resources instead: a VPC, subnets and security groups.

Work in `sandbox/day-10-expressions/`, copying the Day 9 file layout. Local state. Every name starts with `tf30-day10-`, every resource gets the `Project` tag, and the region comes from a variable. One task at a time, each starting from empty state. Tasks 1, 2 and 5 need only a plan; Task 3 and 4 are free to apply if I want to see real IDs.

Acceptance criteria:

- [ ] **Task 1, conditional value:** a VPC whose `Environment`-dependent setting (for example its CIDR or a tag) comes from `var.environment == "prod" ? ... : ...`. `terraform plan -var environment=prod` and the default plan show the two different values
- [ ] **Task 2, conditional resource:** a security group created only when a `bool` variable is true (`count = ... ? 1 : 0`). The plan adds it when true and does not when false. An output reads it with `[0]` and does not fail when it is switched off
- [ ] **Task 3, dynamic block:** one security group whose `ingress` rules come from a `list(object)` variable through a `dynamic` block with a named `iterator`. Adding a third rule to the variable changes the plan with no other edit. Rules use a private CIDR, not `0.0.0.0/0`
- [ ] **Task 4, splat versus for_each:** two subnets made with `count` and two made with `for_each`. One output collects the `count` subnet IDs with `[*]`. I try the same splat on the `for_each` subnets, see the error, and fix it without `[*]` on the map
- [ ] **Task 5, console:** in `terraform console`, I evaluate a conditional with mixed result types, a splat on a single object and on `null`, and say what each returns
- [ ] `terraform fmt -check -recursive`, `terraform validate`, `tflint` and `trivy config .` pass in the directory (HIGH/CRITICAL gate)
- [ ] Anything applied is destroyed, and the CLI checks show no `tf30-day10-` resources
- [ ] The directory README says what it does and what was applied

## 5. Hints

Open one at a time, in order.

1. Nudge: each task maps to one docs page: conditionals (Tasks 1 and 2), dynamic blocks (Task 3), splat (Task 4). The splat page has a sentence about `for_each` resources near the end.
2. Narrower: for Task 2, an output that reads a switched-off resource needs a conditional of its own, or a splat (a splat on an empty list is an empty list). For Task 3, the `iterator` name replaces the label in `<name>.value`. For Task 4, ask what type a `for_each` resource is when you refer to it whole.
3. Last resort, in words only: Task 2's output can use `one()` or `length(...) > 0 ? ... : null`. Task 4's fix is a `for` expression over the map, or the `values()` function before the splat.

## 6. Verify

| Command | Expected |
|---|---|
| `terraform plan` and `terraform plan -var environment=prod` (Task 1) | The two plans show different values for the conditional setting |
| `terraform plan -var create_sg=false` (Task 2; my variable name may differ) | The security group is gone from the plan, and the output is `null` or empty, with no error |
| `terraform plan` (Task 3) | One `ingress` block per item in the variable, inside one `aws_security_group` |
| Splat on the `for_each` subnets (Task 4) | An error; the docs say `for_each` resources "appear in expressions as a map of objects" |
| `terraform console` (Task 5) | `true ? 12 : "hello"` gives `"12"` (a string); `{a = 1}[*]` gives a one-item tuple; `null[*]` gives `[]` |

Expected outputs are from the docs, not from a run of this code yet. Correct them here after the hands-on.

## 7. Gotchas and mistakes

**Traps in the video and the instructor material** (checked against the docs on 2026-11-23):

- **"t3.micro is a bigger instance type" than t2.micro (video).** Only partly. Both are `micro` size with 1 GiB of memory; t3.micro has 2 vCPUs to t2.micro's 1, because t3 is the newer generation. The size is the part after the dot (`micro`, `large`), so a prod-sized pick is something like the instructor code's `t3.large`. Check the instance type page before relying on these numbers.
- **`protocol = "HTTP"` (video).** `protocol` takes an IP protocol (`tcp`, `udp`, `icmp`, `-1` for all, or a number), not an application protocol. The video's error came from missing quotes; the value itself is wrong too, and a plan would not catch it, because only AWS checks it. HTTP runs over `tcp` on port 80.
- **`ingress = { ... }` versus `ingress { ... }` (video).** With `=`, the video assigned an attribute and got "set of object required". A nested block has no `=`. The video found this by trial.
- **`locals.` versus `local.` (video).** See section 2. The video gave up on `locals.all_instance_id` in the output and moved the splat.
- **"the counter will go from one and two" (video).** A list index starts at 0, so `<iterator>.key` is 0 and 1.
- **The readme's dynamic-block syntax says "using each.key and each.value".** Inside `content` it is `<label or iterator>.key` and `.value`. The readme's own next bullet says so; the code example uses `ingress.value`, which is right.
- **Inline `ingress` rules.** The video and the instructor code both use inline rules. The provider docs say to avoid them and to use `aws_vpc_security_group_ingress_rule` resources, and never to mix both styles on one group.
- **Open to the world.** The instructor rules allow `0.0.0.0/0` on ports 80 and 443, and the egress allows all traffic to `0.0.0.0/0`. `trivy` flags both as HIGH or CRITICAL. Use a private CIDR in the sandbox.
- **Default VPC.** The video omits `vpc_id`, so the group lands in the region's default VPC (the docs confirm the default). In a shared account, create your own VPC.
- **Amazon Linux 2 is past end of support.** The instructor's `aws_ami` filter looks for `amzn2-ami-hvm-*`. AWS's FAQ says AL2 reached end of support on 2026-06-30. Use Amazon Linux 2023 if an AMI is ever needed.
- **Example 1 is not commented out.** The instructor code says "uncomment to test", but the conditional `aws_instance` is live, so a plain `apply` of `code/` creates an EC2 instance.
- **Provider pin `~> 5.0`.** Same as earlier days; our `~> 6.0` wins.

My own mistakes: none yet (hands-on not started).

## 8. Cleanup

- [ ] `terraform destroy` (you run it), if anything was applied
- [ ] CLI checks: no `tf30-day10-` VPCs, subnets or security groups
- [ ] Billing check

## 9. LinkedIn worth

Candidates, logged in `docs/LINKEDIN-IDEAS.md`: a splat does not work on a `for_each` resource; `locals.` versus `local.`; inline security group rules are no longer the recommended way. Confirm each with my own output before posting.
