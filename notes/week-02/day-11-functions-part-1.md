# Day 11: Functions, part 1

Video: [11/30 - AWS Terraform Functions - Part 1](https://www.youtube.com/watch?v=-dKsmU4Z1hM) (55 min) · Instructor code: [lessons/day11-12](https://github.com/piyushsachdeva/Terraform-Full-Course-Aws/tree/main/lessons/day11-12) (shared with Day 12: `README.md`, `task.md`, `main.tf`, `variables.tf`, `outputs.tf`, `provider.tf`) · Verified against: Terraform 1.17.1 (pinned), AWS provider 6.73.0 (the Day 10 lock), and the `timestamp` and `cidrsubnet` docs read on 2026-11-26

Source material for this note: my own notes from the video (written 2026-11-24, outside this repo), the instructor's `task.md` and `variables.tf`, and console runs on 2026-11-26. Hands-on: Task 1 only (console), 2026-11-26. Tasks 2 to 5 and the Q&A skipped by my choice when closing the day; Claude gave the answers.

## 1. Goal

After today I can test any built-in function in `terraform console`, chain functions to clean messy input into valid names, tags and rules, and I know which functions break a plan (`timestamp()`) or quietly give the wrong result (`trim`, `substr`, `split` with spaces).

## 2. Concepts

**What a function is here.** A named built-in you call, such as `upper("x")`. HCL has no way to define your own. Since Terraform 1.8, providers can ship functions too, called as `provider::<name>::<function>()`, so "built-in only" is no longer the whole story.

**Test in the console first.** `terraform console` evaluates expressions with nothing created. It loads the `.tf` files of the folder it starts in, so start it in the sandbox folder to reach `var.` and `local.` values (the Day 10 Task 5 mistake).

**Nested calls run from the inside out.** In `lower(replace(var.name, " ", "-"))`, `replace` runs first and its result goes into `lower`. Order matters when one step creates what the next one removes.

```
 messy input                              clean value
 "Project ALPHA Resource"  -> replace(" ","-") -> lower()  ->  "project-alpha-resource"
 "80, 443,8080"            -> split(",")  -> trimspace() -> tonumber()  ->  [80, 443, 8080]
 default_tags + env_tags   -> merge()  (later map wins on a duplicate key)
 instance_sizes[env]       -> lookup(map, key, fallback)
```

**The categories from the video.** String (`upper`, `lower`, `trim`, `trimspace`, `replace`, `substr`, `split`, `join`, `format`), numeric (`max`, `min`, `abs`, `sum`), collection (`length`, `concat`, `merge`, `toset`, `lookup`), type conversion (`tonumber`, `tostring`, `tolist`, `toset`), date and time (`timestamp`, `formatdate`). Validation and file functions are Day 12.

**Three pairs that are easy to swap:**

| Pair | Difference |
|---|---|
| `concat` vs `merge` | `concat` joins lists or tuples. `merge` joins maps or objects; on a duplicate key the later argument wins |
| `trim` vs `trimspace` | `trim(s, chars)` removes the given characters from the start and end only. `trimspace(s)` removes whitespace from both ends |
| `[for ...]` vs `{for ...}` | Square brackets make a tuple (ordered list). Curly braces with `k => v` make an object (map) |

**`substr(string, offset, length)`.** The third argument is a length, not an end index. `substr("terraform", 2, 3)` is `"rra"`.

**`timestamp()` changes on every run.** The docs: using it in resource attributes "will cause a diff to be detected on every Terraform run", and its value "cannot be predicted during Terraform's planning phase". `plantimestamp()` gives one fixed value for the plan; the Time provider is the docs' answer for stable times.

**Answers to the Task 1 traps** (given by Claude when I closed the day):

| Expression | Result | Why |
|---|---|---|
| `sum(2, 5)` | Error: "Too many function arguments" | `sum` takes one argument, a list |
| `sum([2, 5])` | `7` | One list of numbers |
| `trim("  awstf  ", "f")` | `"  awstf  "`, unchanged | `trim` removes the given characters only at the very start and end. The ends are spaces, not `f`, so it stops at once |
| `substr("terraform", 2, 3)` | `"rra"` | Start at offset 2 (the first `r`, counting from 0) and take a **length** of 3 |
| `merge({ env = "dev", owner = "me" }, { env = "prod" })` | `{ env = "prod", owner = "me" }` | One map. On a duplicate key the **later** argument wins, which is why defaults go first and overrides last |
| `formatdate("dd mm yyyy", ...)` | Error: `invalid date format verb "dd"` | Verbs are case-sensitive: `DD` is the day, `MM` the month, `YYYY` the year, and lowercase `mm` is **minutes** |

**When to use these: common scenarios.**

| Scenario | Functions | Example |
|---|---|---|
| Clean a name from human input (buckets, tags) | `lower`, `replace`, `substr`, `trimspace` | `substr(lower(replace(var.name, " ", "-")), 0, 63)` |
| Build one naming prefix for every resource | `format` or interpolation, `lower` | `format("tf30-%s-%s", var.project, var.env)` |
| Shared tags plus per-resource or per-environment tags | `merge` | `merge(local.common_tags, { Name = "x" })`, defaults first |
| Pick a value per environment with a safe default | `lookup`, or a map index | `lookup(var.sizes, var.env, "t3.micro")` |
| Turn a comma-separated string (from CI or a tfvars file) into a list | `split`, `trimspace`, `tonumber` | `[for p in split(",", var.ports) : tonumber(trimspace(p))]` |
| Feed `for_each` from a list | `toset`, or a `for` expression into a map | `for_each = toset(var.names)` |
| Join two lists of subnets or CIDRs | `concat`, `distinct` | `distinct(concat(var.a, var.b))` |
| Cut subnets from a VPC range | `cidrsubnet` | `cidrsubnet(var.vpc_cidr, 8, 1)` gives a `/24` |
| Count or guard a list | `length` | `count = length(var.subnets)`; validation `length(var.x) > 0` (Day 12) |
| A date in an output or file name | `formatdate`, `plantimestamp` | `formatdate("YYYY-MM-DD", plantimestamp())` in an output, never in a tag |

**Best practices and tips.**

- **Prototype in the console, then move it into a local.** Start `terraform console` in the folder so `var.` and `local.` resolve.
- **Put function chains in `locals`, not inside resource arguments.** One named local (`local.bucket_name`) is readable, testable in the console, and reused everywhere; a chain repeated inline drifts.
- **Keep chains short.** More than three nested calls is hard to read; split it into two locals with names that say what each step does.
- **Validate input instead of silently fixing it.** Cleaning `"My Bucket!!"` hides a bad value; a `validation` block (Day 12) rejects it with a message. Clean only what is safe to change, such as case.
- **Order `merge` from general to specific.** Defaults first, overrides last, because the last map wins.
- **Convert types on purpose.** `tonumber`, `tostring`, `toset` say what you mean; trim before you convert.
- **Never put `timestamp()` or `uuid()` in a resource argument or tag.** Both change on every run, so every plan shows a change. Use `plantimestamp()` in an output, a fixed value, or the Time provider.
- **Know when to use a map index instead of `lookup`.** `var.sizes[var.env]` fails loudly on a missing key, which is better when every environment must be listed; `lookup` with a default is for optional keys.

## 3. Docs to read

- [ ] [Built-in functions](https://developer.hashicorp.com/terraform/language/functions) (the category list on the left; skim names only)
- [ ] [terraform console](https://developer.hashicorp.com/terraform/cli/commands/console) (it loads the current folder's configuration)
- [ ] [substr](https://developer.hashicorp.com/terraform/language/functions/substr), [trim](https://developer.hashicorp.com/terraform/language/functions/trim), [split](https://developer.hashicorp.com/terraform/language/functions/split) (arguments and edge cases)
- [ ] [merge](https://developer.hashicorp.com/terraform/language/functions/merge) and [lookup](https://developer.hashicorp.com/terraform/language/functions/lookup) (which value wins; the fallback)
- [ ] [timestamp](https://developer.hashicorp.com/terraform/language/functions/timestamp) and [formatdate](https://developer.hashicorp.com/terraform/language/functions/formatdate) (why not in resource attributes; case-sensitive verbs)
- [ ] [cidrsubnet](https://developer.hashicorp.com/terraform/language/functions/cidrsubnet) (`prefix`, `newbits`, `netnum`; used in Day 10 Task 4)
- [ ] [for expressions](https://developer.hashicorp.com/terraform/language/expressions/for) (brackets decide tuple or object)

## 4. Challenge

The instructor's `task.md` asks for 5 of 12 function assignments plus a blog, which we skip until the course ends. The video creates an S3 bucket; this challenge stays free and plan only: a VPC, subnets and security group rules, never applied.

Work in `sandbox/day-11-functions/`, copying the Day 10 file layout. Local state. Every name starts with `tf30-day11-`, every resource gets the `Project` tag, and the region comes from a variable. One task at a time.

Acceptance criteria:

- [x] **Task 1, console traps:** in `terraform console` I predict, then run, `sum` with two numbers and with a list, `trim` on a padded string, `substr` with a non-zero offset, `merge` with a duplicate key, and `formatdate` with lowercase verbs, and say why each result differs from my prediction
- [ ] **Task 2, clean names and tags** (skipped by my choice, 2026-11-26): from a messy `project_name` default such as `"Project ALPHA Resource"`, a local builds a valid lowercase prefix starting with `tf30-day11-`; `merge` combines default tags with environment tags so the environment value wins; a VPC uses both. The plan shows the clean `Name` tag
- [ ] **Task 3, string to rules** (skipped by my choice, 2026-11-26): a variable `allowed_ports` is a string with spaces, such as `"80, 443,8080"`. Functions turn it into numbers, and one `aws_vpc_security_group_ingress_rule` per port is created with `for_each` on a private CIDR. Adding a port to the string changes the plan with no other edit
- [ ] **Task 4, size per environment and subnets** (skipped by my choice, 2026-11-26): `lookup` picks a value per environment from a map with a fallback (shown in an output); `cidrsubnet` cuts two subnets from the VPC range so they always fit. `plan -var environment=staging` shows the fallback
- [ ] **Task 5, time** (skipped by my choice, 2026-11-26): I put `formatdate(...timestamp())` in a tag, explain what `plan` shows and why it would change on every run, then replace it with a stable option
- [x] No `.tf` files written (console only), so there is no folder to gate
- [x] Nothing applied

## 5. Hints

Open one at a time, in order.

1. Nudge: every task is one or two function doc pages; run each piece in the console before putting it in a local.
2. Narrower: Task 2 needs two kinds of cleanup (case and spaces). Task 3 has a space problem after `split`, and `for_each` needs a set or map of strings. Task 4: count the bits between `/16` and `/24`.
3. Last resort, in words only: Task 3 trims each piece before converting it, then keys the rules by the port as a string. Task 5's stable options are `plantimestamp()` in an output, a static value, or the Time provider.

## 6. Verify

| Command | Expected |
|---|---|
| `terraform console` (Task 1) | `sum(2, 5)` errors with "Too many function arguments"; `sum([2, 5])` is `7`; `trim(" awstf ", "f")` is unchanged; `substr("terraform", 2, 3)` is `"rra"`; `formatdate("dd mm yyyy", ...)` errors (checked by Claude on 1.17.1, 2026-11-26; I ran them too and got the same `formatdate` error) |
| `terraform plan` (Task 2) | The VPC `Name` tag is lowercase with hyphens, and `Environment` comes from the environment tags |
| `terraform plan` (Task 3) | One ingress rule per port, addressed by port; a fourth port adds one rule |
| `terraform plan -var environment=staging` (Task 4) | The output shows the fallback value; both subnets sit inside the VPC range |
| `terraform plan` (Task 5) | The timestamp tag shows `(known after apply)`, so it can never match the last run |

Task 1 results are from real console runs. Tasks 2 to 5 were skipped, so their rows are still expectations from the docs.

## 7. Gotchas and mistakes

**Traps in the video** (checked in the console on Terraform 1.17.1, 2026-11-26):

- **"There's no `sum` function" (14:17).** There is; it takes one list. `sum(2, 5)` fails with "Too many function arguments", `sum([2, 5])` is `7`.
- **"`trim` removes occurrences of a character" (11:06).** Only from the start and end. `trim("ffawsff", "f")` is `"aws"`, but `trim(" awstf ", "f")` is unchanged, because the ends are spaces.
- **"`substr(s, 0, 3)` means from element 0 to element 3" (13:39).** The third argument is a length; it only looked right because he started at 0.
- **"`merge` works on key-value pairs, which are tuples" (16:49).** `merge` takes maps or objects. Tuples go to `concat`, and `concat("a", "b")` fails with "Invalid function argument".
- **"The `for` expression produced a map" (47:49).** With `[ ]` it is a tuple of objects; the console's `type()` shows `tuple([object({...})])`.
- **"Run `terraform refresh`" (25:04).** Deprecated; use `terraform apply -refresh-only`, which shows the change before writing state.
- **`locals.` versus `local.`** He hit it twice, same as Day 10.
- **Bucket-name cleanup only removes spaces and `!`.** An underscore or a trailing hyphen still fails S3 rules at apply. Rejecting bad input with a `validation` block (Day 12) is often safer than fixing it silently.
- **`t2.micro` and older types.** They work, but they are older generations.

**Found while checking** (console, 2026-11-26):

- **`split` keeps the spaces.** `split(",", "80, 443")` gives `["80", " 443"]`, and `tonumber(" 443")` fails with "Invalid function argument". Trim each piece first.
- **`formatdate` verbs are case-sensitive.** `"dd mm yyyy"` errors; `"DD-MM-YYYY hh:mm"` gives `"24-11-2026 10:30"`. Lowercase `mm` is minutes.
- **`terraform output` reads state.** Outputs stay empty until something writes state; a plan never does.

My own mistakes:

- **Task 1 predictions (2026-11-26): 2 right, 1 half right, 3 wrong.** `sum` with two numbers (error) and with a list (`7`) right. `merge`: I said it becomes one object (right) but not which `env` survives (the later map, `prod`). `trim`: I predicted `" awst "`, thinking it removes the character anywhere; it only looks at the ends, which were spaces, so nothing changed. `substr`: I predicted `"teaform"`; the third argument is a length, so it is `"rra"`. `formatdate`: I predicted a date; lowercase verbs error, and `mm` means minutes. All three wrong ones are the same mistake as the video's: guessing from the name instead of reading the arguments.

## 8. Cleanup

- [x] `terraform destroy`: not needed, nothing was applied
- [x] Billing check: not needed, nothing billable was created

## 9. LinkedIn worth

Logged in `docs/LINKEDIN-IDEAS.md`: my three wrong console predictions (guessing a function from its name). From Claude's console check only, so confirm before posting: `split` plus `tonumber` failing on `"80, 443"`; `timestamp()` in a tag making every plan dirty.
