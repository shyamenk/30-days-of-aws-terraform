# How to read the docs and build it yourself

The goal is to turn a requirement like "an EC2 instance in a private subnet" into working Terraform using only the documentation. The video shows one way. The docs are the contract.

## The three kinds of docs, and what each answers

| Source | Answers | Where |
|---|---|---|
| Terraform language docs | How does the language work? (variables, `for_each`, modules, state) | [developer.hashicorp.com/terraform/language](https://developer.hashicorp.com/terraform/language) |
| AWS provider docs | Which resource, which arguments, what it exports? | [registry.terraform.io/providers/hashicorp/aws](https://registry.terraform.io/providers/hashicorp/aws/latest/docs) |
| AWS service docs | What does the service do and what are its limits and prices? | [docs.aws.amazon.com](https://docs.aws.amazon.com/) |

## The loop for any new resource

1. **Understand the service first.** Read the AWS service overview. If you can't explain what a NAT gateway is for, you can't choose its arguments.
2. **Find the resource page.** Search the provider docs for the AWS name (`aws_nat_gateway`). Check the version selector matches your lock file.
3. **Read top to bottom.** The example is only the shape. Then read **Argument Reference**: required arguments first, then the optional ones that match your requirement.
4. **Read Attribute Reference.** These are the values other resources can use (`aws_nat_gateway.main.id`). This is how resources connect.
5. **Read the Import section** at the bottom. It shows the identifier the resource uses, and it is a fast way to see the resource's shape.
6. **Write the smallest version that satisfies the requirement.** One resource, required arguments only.
7. **`terraform validate`, then `terraform plan`.** Read every `+`, `~` and `-` line. If the plan surprises you, stop and find out why before applying.
8. **Apply, check the console, then change one argument** and watch what the plan says. This is how you learn which changes replace the resource and which update it in place.
9. **Destroy.** Check the console and the bill.

## Reading errors

- Read the whole message. It names the file, line and argument.
- "Unsupported argument" means a typo or a version difference. Check the docs for your pinned version.
- "Missing required argument" means go back to the Argument Reference.
- AWS API errors (`UnauthorizedOperation`, `InvalidParameterValue`) are IAM or AWS-side. Search the exact error string with the service name.

## When you're stuck (the ladder)

1. 25 minutes with the docs and the exact error.
2. Registry examples and the provider's GitHub issues.
3. The instructor's code, only after step 2 has failed.
4. Ask Claude for a hint: which doc section to re-read. No code.

## Habits that make you faster

- Keep `terraform plan` output open as your feedback loop. Run it after every small edit.
- Use `terraform console` to try expressions and functions.
- Use `terraform state list` and `terraform state show` to see what Terraform believes exists.
- Write down what confused you in the day's Gotchas section. That list is what you will re-read before interviews.
