resource "aws_iam_group" "group" {
  name = var.iam_group
}

data "github_team" "group" {
  slug = var.github_team
}

data "github_user" "user" {
  count    = length(data.github_team.group.members)
  username = element(data.github_team.group.members, count.index)
}

locals {
  usernames = [
    for user in data.github_user.user :
    user.username
  ]
  users = zipmap(local.usernames, data.github_user.user)
}

resource "aws_iam_user" "user" {
  for_each = local.users

  name = "${var.user_prefix}${each.key}"
}

resource "aws_iam_user_ssh_key" "user" {
  for_each = local.users

  username   = lookup(aws_iam_user.user, each.key).name
  encoding   = "SSH"
  public_key = each.value.ssh_keys[0]
}

resource "aws_iam_user_group_membership" "group" {
  for_each = local.users

  user   = lookup(aws_iam_user.user, each.key).name
  groups = [aws_iam_group.group.name]
}
