I'll help you create a Terraform configuration that sets up two IAM users and adds them to a single IAM group in AWS. This configuration will:

1. Create an IAM group named "basic-users"
2. Create two IAM users named "user-one" and "user-two"
3. Add both users to the "basic-users" group
4. Set up login credentials for both users

Here's the complete Terraform configuration:

<iac_template>
# Configure AWS Provider
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
</iac_template>

This Terraform configuration will:
1. Set up the AWS provider in the us-east-1 region
2. Create an IAM group called "basic-users"
3. Create two IAM users: "user-one" and "user-two"
4. Add both users to the "basic-users" group
5. Create login profiles for both users with password reset required on first login
6. The force_destroy option is set to true for both users, which allows Terraform to delete the users even if they have non-Terraform-managed IAM access keys, login profiles, or MFA devices

When you apply this configuration, Terraform will create all these resources in your AWS account. The users will be able to log in to the AWS Management Console, and they will be required to change their passwords on their first login for security purposes.

Note: Make sure you have proper AWS credentials configured on your system to execute this Terraform configuration. Also, remember to securely communicate the initial passwords to the users, as they will be generated automatically by AWS.