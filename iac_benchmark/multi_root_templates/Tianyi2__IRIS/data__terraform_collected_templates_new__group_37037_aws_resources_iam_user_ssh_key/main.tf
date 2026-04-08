resource "aws_iam_user_ssh_key" "this" {
  username   = var.username
  encoding   = var.encoding
  public_key = var.public_key
  status     = var.status
}