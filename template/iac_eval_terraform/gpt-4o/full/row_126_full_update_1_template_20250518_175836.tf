To fulfill the business need, we will create an AWS EC2 instance using the latest Amazon Linux 2 AMI. We will configure the instance with 2 vCPUs and set the threads per core to 2. This configuration will be defined in a Terraform HCL program. We will also include the necessary IAM roles and provider configuration to ensure the infrastructure is deployable.

<iac_template>

```hcl
provider "aws" {
  region = "us-east-1"
}

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

resource "aws_instance" "example" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = "t3.medium" # This instance type has 2 vCPUs

  cpu_core_count       = 1
  cpu_threads_per_core = 2

  tags = {
    Name = "ExampleInstance"
  }
}

resource "aws_iam_role" "ec2_role" {
  name = "ec2_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ec2_role_policy" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ReadOnlyAccess"
}

resource "aws_instance_profile" "ec2_instance_profile" {
  name = "ec2_instance_profile"
  role = aws_iam_role.ec2_role.name
}

resource "aws_launch_configuration" "example" {
  name          = "example-launch-configuration"
  image_id      = data.aws_ami.amazon_linux.id
  instance_type = "t3.medium"

  iam_instance_profile = aws_instance_profile.ec2_instance_profile.name

  lifecycle {
    create_before_destroy = true
  }
}
```

</iac_template>

This Terraform configuration sets up an EC2 instance using the latest Amazon Linux 2 AMI. The instance is configured with 2 vCPUs, and the threads per core are set to 2. An IAM role is created and attached to the instance to allow EC2 read-only access. The configuration also includes a launch configuration for future use in auto-scaling groups if needed.