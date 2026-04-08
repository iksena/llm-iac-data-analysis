resource "aws_iam_user" "user" {
  name = "${var.user}"
  force_destroy = "${var.force_destroy}"
  path = "/${var.user}/"

}

resource "aws_iam_access_key" "key" {
  user    = aws_iam_user.user.name
  pgp_key = "keybase:${var.keybase_user}"
}

resource "aws_iam_user_policy" "policy" {
  for_each = { for pl in var.policies: pl.name => pl }

  name = "${each.value.name}"
  user = aws_iam_user.user.name
  policy = jsonencode("${each.value.policy}")

}


