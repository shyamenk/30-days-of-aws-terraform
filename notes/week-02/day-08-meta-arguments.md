# Day 8: Meta-arguments

Video: [Terraform meta-arguments](https://www.youtube.com/watch?v=XMMsnkovNX4) (29 min) · Instructor code: [lessons/day08](https://github.com/piyushsachdeva/Terraform-Full-Course-Aws/tree/main/lessons/day08) (README, `task.md`, and a `code/` folder with `main.tf`, `variables.tf`, `local.tf`, `output.tf`, `provider.tf`, `backend.tf`) · Verified against: Terraform 1.17.1 (pinned; 1.17.2 is out), AWS provider 6.73.0 (`~> 6.0` in `sandbox/day-08-meta-arguments/versions.tf`, locked in `.terraform.lock.hcl`)

Source material for this note: the video transcript, my pasted lifecycle key notes, and the instructor's README, `task.md` and `code/`. The hands-on is done as plan only: Tasks 1 to 3, the `depends_on` bucket and the removal test (reasoned, not run). The five-question Q&A is done (see section 7).

## 1. Goal

After today I can name the five meta-arguments, create several resources from one block with `count` and with `for_each`, say when to pick which, and force an order between resources with `depends_on`.

## 2. Concepts

**What a meta-argument is.** A resource has two kinds of arguments. The provider defines the normal ones (for `aws_s3_bucket`: `bucket`, `tags`). Terraform itself defines the meta-arguments, and they work on any resource type, whatever the provider. They change how Terraform treats the resource, so you get loops and ordering without a wrapper script.

```
 Meta-arguments (work on any resource)
 ├── depends_on   force an order the references do not show        (today)
 ├── count        N copies from a whole number, addressed [0], [1] (today)
 ├── for_each     one copy per item of a map or set, addressed ["key"] (today)
 ├── provider     pick an alternate provider configuration (alias)  (named only)
 └── lifecycle    prevent_destroy, create_before_destroy,
                  ignore_changes, replace_triggered_by             (Day 9)
```

**`depends_on`.** Terraform builds a dependency graph from references. If the instance uses `aws_vpc.main.id`, the VPC is created first (an implicit dependency, which Day 3 covered). `depends_on = [aws_s3_bucket.bucket1]` adds an explicit edge when nothing in the code references the other resource. It waits for the other resource to be created, not for it to be "healthy". Two resources with no edge between them are created in parallel, so the order you wrote them in a file does not decide the order of the apply.

**`count`.** Takes a whole number and makes that many instances. Inside the block, `count.index` is the instance number starting at 0. With a list, the usual pattern is `count = length(var.bucket_names)` and `var.bucket_names[count.index]`, so adding a name needs no second edit. Instances are addressed `aws_s3_bucket.bucket1[0]`, `[1]`. A set has no index, so `count.index` cannot read one.

**`for_each`.** Takes a map or a set of strings (not a list, not a number) and makes one instance per item. Inside the block, `each.key` and `each.value` are the current item. For a set they are the same string. For a map, `each.key` is the key and `each.value` is the value. Instances are addressed by key: `aws_s3_bucket.bucket2["tf30-day08-a"]`. A list goes through `toset()` first.

```
 count (list)                          for_each (set)
 names = ["a","b","c"]                 names = ["a","b","c"]
   bucket[0] = a                         bucket["a"]
   bucket[1] = b                         bucket["b"]
   bucket[2] = c                         bucket["c"]
 remove "a": b moves to [0],           remove "a": only bucket["a"] goes;
 c moves to [1], [2] is destroyed      the others keep their address
```

**Which one.** `count` fits identical copies or an on/off switch (`count = 0 or 1`). `for_each` fits copies that each have a name, and anything long-lived, because the address does not shift when the input changes. The instructor's README says to prefer `for_each` in production.

> [!WARNING]
> **`count` tracks by position, so removing from the start or middle rebuilds everything after it.** With `names = ["A", "B", "C"]`, removing "A" shifts B to `[0]` and C to `[1]`. A bucket name cannot change in place, so `[0]` and `[1]` are replaced and `[2]` is destroyed: one removal, three buckets destroyed, two recreated empty. Removing from the end is safe. Use `count` only for identical, throwaway copies or an on/off switch (`count = 0` or `1`).
>
> **`for_each` is safer, not always safe.** Removing a key destroys only that instance, because the other addresses do not move. But:
> - Changing a key (renaming `"A"` to `"A2"`) is still a destroy and a create, because the key is the address.
> - Keys must be known at plan time, so they cannot come from an attribute that is only known after apply (such as a bucket ID).
> - Switching an existing block from `count` to `for_each` changes every address. Without [`moved` blocks](https://developer.hashicorp.com/terraform/language/modules/develop/refactoring) (not in the syllabus), the plan destroys and recreates all of them.

## 3. Docs to read

- [ ] [count](https://developer.hashicorp.com/terraform/language/meta-arguments/count) (`count.index`, and the section on when to use `for_each` instead)
- [ ] [for_each](https://developer.hashicorp.com/terraform/language/meta-arguments/for_each) (the type it accepts, `each.key` and `each.value`, and the "known at plan time" limit)
- [ ] [depends_on](https://developer.hashicorp.com/terraform/language/meta-arguments/depends_on) (when an explicit dependency is justified)
- [ ] [for expressions](https://developer.hashicorp.com/terraform/language/expressions/for) (Task 3 needs them and the video does not cover them)
- [ ] [`toset` function](https://developer.hashicorp.com/terraform/language/functions/toset) (turning a list into something `for_each` accepts)

## 4. Challenge

The instructor's `task.md` has three tasks. Work in `sandbox/day-08-meta-arguments/`. Copy the `provider.tf` and `versions.tf` pattern from `sandbox/day-07-types/` and use local state (no `backend.tf`). Every name starts with `tf30-` and has a suffix I choose, because S3 bucket names are global. The `Project` tag stays.

Acceptance criteria:

- [x] Task 1: one `aws_s3_bucket` block with `count` makes two buckets from a `list(string)` variable, and the names come from `count.index`
- [x] The count is not hard-coded: adding a third name to the list changes the plan to three buckets with no other edit (checked with a temporary `-var`)
- [x] Task 2: a second block with `for_each` makes two buckets from a `set(string)` variable, and the names come from `each.value`
- [x] I can read the plan and point out the two address styles (`[0]` against `["name"]`)
- [x] Task 3: one output lists all bucket names and one lists all bucket IDs, both built with a `for` expression (plan shows the names; the IDs are `known after apply`; `terraform output` needs an apply, which I have not done)
- [x] `depends_on`: a third bucket depends on one of the others, and the plan or apply shows it comes after (shown with `terraform graph`, because a plan does not show order)
- [x] Removal test (plan only): remove the first name from the list and from the set, and I can say which resources the plan changes in each case (reasoned, not run; see below)
- [x] `terraform fmt -check -recursive`, `terraform validate`, `tflint` and `trivy config .` pass in the directory (HIGH/CRITICAL gate)
- [x] No `.terraform/`, state file or real `terraform.tfvars` is staged, and `.terraform.lock.hcl` is committed
- [x] The directory README says what it does and whether anything was applied

## 5. Hints

Open one at a time, in order.

1. Nudge: the `count` and `for_each` pages each have a section on how to refer to one instance and on what the argument accepts. Start with the type each one accepts.
2. Narrower: for Task 3, a `for` expression is square brackets around `for x in <collection> : <something about x>`. A resource that uses `count` or `for_each` is itself a collection, so you can loop over it. For the removal test, `terraform plan` prints each address it would destroy or replace.
3. Last resort, in words only: the `for_each` input must be a set or map, so if your variable is a list, convert it where you use it. A `for` expression over a resource made with `for_each` gives you each instance, and an attribute of each instance (`bucket` or `id`) is the thing you collect. The `depends_on` list takes the resource, not one instance of it.

## 6. Verify

| Command | Expected |
|---|---|
| `terraform fmt -check -recursive` | exit 0, no output |
| `terraform validate` | `Success! The configuration is valid.` |
| `tflint` | exit 0 |
| `trivy config .` | HIGH/CRITICAL gate exits 0 |
| `terraform plan` | adds one bucket per name in each variable, plus the `depends_on` bucket; addresses end in `[0]`, `[1]` for count and `["name"]` for for_each |
| `terraform output` | the name list and the ID list (IDs are known only after apply, so plan shows them as "known after apply") |

Result so far (2026-11-16, plan only, run by Claude at my request): `fmt`, `validate` and `tflint` pass; `Plan: 13 to add, 0 to change, 0 to destroy.` (four buckets, one KMS key, four public access blocks, four encryption configurations). The names output shows the four names and the IDs output shows four `(known after apply)`. `trivy` passes the HIGH/CRITICAL gate.

Result for the `depends_on` bucket (2026-11-20, plan only): the gate passes and `Plan: 16 to add, 0 to change, 0 to destroy.` (five buckets, one KMS key, five public access blocks, five encryption configurations). `terraform graph` shows the explicit edge `aws_s3_bucket.depends_buckets -> aws_s3_bucket.count_buckets`. Every other edge is implicit and comes from a reference (`bucket = ...id`, `kms_master_key_id = ...arn`).

How to read `terraform graph`: `A -> B` means A depends on B, so B is created first and A is destroyed first. One node stands for one resource block, so a `count` or `for_each` block shows once, not once per instance. That is why the graph has 10 nodes while the plan adds 16. The creation order is three waves:

```
Wave 1  kms_key   count_buckets   for_each_buckets        (no edges, in parallel)
Wave 2  depends_buckets (only because of depends_on)
        pab.count  sse.count  pab.for_each  sse.for_each
Wave 3  pab.depends  sse.depends
```

`destroy` walks the same graph in reverse. To draw it: `terraform graph | dot -Tsvg > /tmp/day08-graph.svg` (needs Graphviz).

**Removal test (2026-11-20, reasoned, not run).** Remove the first name from both variables, so the list `[A, B]` becomes `[B]` and the set `{A, B}` becomes `{B}`.

| | What the plan would do, once the buckets exist |
|---|---|
| `count` (by position) | `[0]` was A and is now B. A bucket name cannot change in place, so `count_buckets[0]` **must be replaced** (A destroyed, B created at `[0]`), and its public access block and encryption configuration are replaced with it. `[1]` no longer exists and is **destroyed**. B is destroyed and recreated although I never touched it, and any data in it would be lost. |
| `for_each` (by key) | Only `for_each_buckets["A"]` and its two protection resources are destroyed. `["B"]` keeps its address and is untouched. |

Expected plan after an apply of all 16: `Plan: 3 to add, 0 to change, 9 to destroy.` I did not apply, so this is reasoned from the addressing rules, not seen.

**Where I stopped (2026-11-20):** Tasks 1 to 3, the `depends_on` bucket and the removal test are done, plan only, and the five-question Q&A is done (see section 7). Left: the end-of-day sync, the `SYLLABUS.md` tick, push and the PR.

## 7. Gotchas and mistakes

From the video and the instructor's files (found while comparing, not mistakes I made yet):

- **`for_each` takes no number.** At 15:24 to 18:25 the video writes `for_each = length(var.bucket_name_set)` and then says `for_each = 2` also works. It does not, and the video's own plan fails with "The for_each argument must be a map or set of strings, and you have provided a value of type number." The fix, which he reaches at about 19:35, is to pass the set itself. `for_each` is not a counter and needs no length.
- **`count` is not a function.** The video says it "works as a function but it's not a function". It is a meta-argument that takes a whole number. The instructor README's table says its input is "Number or list"; a list only comes in through `length()` and the index.
- **A list is not accepted by `for_each`.** The video says that for a list or set "key and value are the same". That holds for a set. A list is rejected, so a list goes through `toset()` first.
- **File order is not creation order.** The video says Terraform "loads files in alphabetical order" and that you need `depends_on` because it cannot know what to create first. Files are merged into one configuration, and the order comes from references in the graph. Resources with no edge between them are created in parallel, which is why his apply at 25:58 showed `bucket_1[0]` being created and then `bucket_2` before the second `bucket_1`, which did not match the order he wrote. `depends_on` adds the edge; the plan listing order proves nothing.
- **`depends_on` waits for "created", not "healthy".** The video says "once resource A is healthy". It only means the other resource's create finished.
- **The video hard-codes `count = 2`.** It then says you can add more names. Without `length(var.bucket_names)` the list and the count drift apart. The instructor's `code/main.tf` uses `length(...)`, which is the right form.
- **Task 3 needs `for` expressions the video does not teach.** `task.md` asks for outputs built with a `for` loop. The README lists "Output transformations with `for` expressions"; the video never shows one. Day 10 covers splat (`[*]`), which is the short form.
- **The video copies `backend.tf` from Day 7.** We use local state (no `backend.tf`) and no state bucket exists right now.
- **Instructor `code/` traps.** Bucket names are fixed strings with a date (`tf-day08-...-20251016`) that another account could own, and none carry `tf30-` or the `Project` tag. The default region is `ca-central-1`, `variables.tf` carries an EC2 `ami_id` default, and the README asks for Terraform >= 1.9.0.
- **A plan does not show order.** The plan lists resources alphabetically by address, so it cannot prove that `depends_on` works. `terraform graph` shows the edge, and an apply shows it in the "Creating..." and "Creation complete" lines.
- **A removal test against empty state shows nothing.** With no state, every plan only adds. Removing a name just gives a smaller "to add" count, and the `count` shift is invisible. You only see "must be replaced" when the buckets already exist in state.
- **`task.md` asks for a blog, social posts and a tag.** Skipped until the course ends (see `docs/SYNC.md`).

My own mistakes (Tasks 1 to 3, all fixed at my request on 2026-11-16):

- **Task 1 used `for_each`.** My first `main.tf` used `toset(var.bucket_names)` with `for_each`, which is Task 2, so the addresses were `["name"]`, not `[0]`. Task 1 needs `count` with `count.index`.
- **A stale name left in `locals.tf`.** An unused `name_prefix` still said `tf30-day07-`; `tflint` flagged it (`terraform_unused_declarations`).
- **Same bucket names in both variables.** The list and the set had identical defaults. The plan passes, but an apply would fail on the second create, because bucket names are global. Plan cannot catch a name clash; check by eye.
- **A misleading block name.** The `count` block was called `set_buckets` and read the list. Renamed to `count_buckets`.
- **Task 3 pointed at the old block name.** `outputs.tf` still referenced `set_buckets` after the rename, so `validate` failed. `tflint` still exited 0, so run `validate` as well. The outputs were also ARN maps; the task asks for names and IDs, now two lists built with `for` expressions and `concat()`.
- **`trivy` failed with 20 HIGH findings** on the bare buckets (public access block and customer-managed KMS key), the same as Days 3 and 7. A first fix that wrote the protections once over a merged map did not clear them: `trivy` could not follow the map back to the buckets. One protection resource per bucket block, each referring to its own block, clears the gate.

My own answers from the Q&A (2026-11-20):

- **Q1, what `count` and `for_each` accept:** right (`count` a number, `for_each` a set or map, `toset()` for a list). Added: a list is not converted silently; the plan stops with `the "for_each" argument must be a map, or set of strings`. `toset()` also drops duplicates and order.
- **Q2, remove "B" from `["A", "B", "C"]` with `count`:** right (`[0]` no change, `[1]` replaced, `[2]` destroyed). Added the summary line: `1 to add, 0 to change, 2 to destroy`, because a replace counts once in add and once in destroy. C is rebuilt although I only removed B.
- **Q3, when `depends_on` is needed:** wrong at first. I said it is for when one resource needs an ID from another. That is a reference, which is already an implicit dependency. `depends_on` is for when nothing in the code references the other resource but it still must exist first (my `depends_buckets` never mentions `count_buckets`). Restated in my own words: "a reference orders it by itself; no reference but must exist first, force it with `depends_on`".
- **Q4, why the graph has 10 nodes and the plan 16:** wrong at first. I said the plan shows destroys and replaces and the graph only the current resources, but this plan had only adds. The graph has one node per resource block; the plan counts instances after `count` and `for_each` expand (four single blocks plus six blocks with two each = 16). (Claude's wording; restate before any post.)
- **Q5, renaming a `for_each` key and keys from `id`:** right (old destroyed, new created; `id` is not known at plan time). Added: it shows as a destroy plus a create, not a replace, because the keys are different addresses (`1 to add, 1 to destroy`); a `moved` block saves it only when the real bucket name does not change; keys from `id` fail with `Invalid for_each argument`.
- **Q&A score:** three right, two wrong (Q3 and Q4). Q3 is restated in my own words; Q4 is Claude's wording.

## 8. Cleanup

Nothing was applied on Day 8, so there is nothing to destroy and nothing billed. If I apply later:

- [ ] `terraform destroy` (you run it)
- [ ] Console check that no `tf30-day08-` bucket is left, then Billing check

## 9. LinkedIn worth

- Remove the first item from a `count` list and every later resource shifts address and is replaced; with `for_each` only the removed one goes. Reasoned, not seen in a real plan (the removal test was against empty state), so it stays at strength 2 until I see the `must be replaced` lines myself.
- `terraform graph` showed 10 nodes while the plan said `16 to add`: the graph counts blocks, the plan counts instances. I got this wrong in the Q&A.
- I thought `depends_on` was for "getting an ID from another resource". That is a reference, which already orders things; `depends_on` is for a dependency the code cannot show.

All three are logged in `docs/LINKEDIN-IDEAS.md`.
