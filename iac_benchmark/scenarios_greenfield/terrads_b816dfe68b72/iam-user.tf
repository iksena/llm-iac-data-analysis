resource "aws_iam_user" "iam-user" {
  name          = local.aws_iam_user
  force_destroy = true // DS; TF docs have an updated best practice on this. follow that. 
}

resource "aws_iam_access_key" "access-key" {
  user = aws_iam_user.iam-user.name
}

resource "aws_iam_user_policy_attachment" "test-attach" {
  user       = aws_iam_user.iam-user.name
  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}


