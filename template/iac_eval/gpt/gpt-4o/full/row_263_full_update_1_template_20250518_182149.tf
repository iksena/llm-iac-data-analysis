To fulfill the business need, we will create a Terraform configuration that sets up an AWS IAM user with a basic SSH key attached. This involves creating an IAM user, generating an SSH key pair, and associating the public key with the IAM user. The configuration will use the AWS provider and will be set in the `us-east-1` region. We will also create an IAM policy to allow the user to perform basic actions, such as listing S3 buckets.

<iac_template>

```hcl
provider "aws" {
  region = "us-east-1"
}

resource "aws_iam_user" "basic_user" {
  name = "basic-ssh-user"
}

resource "aws_iam_access_key" "basic_user_key" {
  user = aws_iam_user.basic_user.name
}

resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "aws_iam_user_ssh_key" "basic_user_ssh_key" {
  username   = aws_iam_user.basic_user.name
  encoding   = "SSH"
  public_key = tls_private_key.ssh_key.public_key_openssh
}

resource "aws_iam_policy" "basic_policy" {
  name        = "basic-policy"
  description = "A basic policy for listing S3 buckets"
  policy      = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = "s3:ListBucket"
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_user_policy_attachment" "basic_user_policy_attachment" {
  user       = aws_iam_user.basic_user.name
  policy_arn = aws_iam_policy.basic_policy.arn
}

output "private_key_pem" {
  value     = tls_private_key.ssh_key.private_key_pem
  sensitive = true
}

output "public_key_openssh" {
  value = tls_private_key.ssh_key.public_key_openssh
}

output "access_key_id" {
  value = aws_iam_access_key.basic_user_key.id
}

output "secret_access_key" {
  value     = aws_iam_access_key.basic_user_key.secret
  sensitive = true
}
```

</iac_template>

This configuration will create an IAM user with an SSH key and attach a basic IAM policy that allows listing S3 buckets. The SSH key pair is generated using the `tls` provider, and the public key is associated with the IAM user. The private key and access keys are outputted as sensitive information.