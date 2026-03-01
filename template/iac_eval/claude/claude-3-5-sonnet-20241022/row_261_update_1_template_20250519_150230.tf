provider "aws" {
  region = "us-east-1"
}

# Create IAM Group
resource "aws_iam_group" "basic_users" {
  name = "basic-users"
}

# Create first IAM User
resource "aws_iam_user" "user_one" {
  name = "user-one"
  force_destroy = true
}

# Create second IAM User
resource "aws_iam_user" "user_two" {
  name = "user-two"
  force_destroy = true
}

# Add first user to the group
resource "aws_iam_user_group_membership" "user_one_membership" {
  user = aws_iam_user.user_one.name
  groups = [aws_iam_group.basic_users.name]
}

# Add second user to the group
resource "aws_iam_user_group_membership" "user_two_membership" {
  user = aws_iam_user.user_two.name
  groups = [aws_iam_group.basic_users.name]
}

# Create login profile for first user
resource "aws_iam_user_login_profile" "user_one_login" {
  user    = aws_iam_user.user_one.name
  password_reset_required = true
}

# Create login profile for second user
resource "aws_iam_user_login_profile" "user_two_login" {
  user    = aws_iam_user.user_two.name
  password_reset_required = true
}