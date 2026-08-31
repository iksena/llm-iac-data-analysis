resource "random_pet" "this" {
  prefix = "policy-attachment"
  keepers = {
    # Generate a new pet name each time we switch to a new AMI id
    policies = join(",",var.policies)
    roles = join(",",var.roles)
    users = join(",",var.users)
    groups = join(",",var.groups)
  }
  length = 3
  separator = "-"
}

resource "aws_iam_policy_attachment" "this" {
  count = length(var.policies)
  name = random_pet.this.id
  users      = var.users
  roles      = var.roles
  groups     = var.groups
  policy_arn = var.policies[count.index]
}
