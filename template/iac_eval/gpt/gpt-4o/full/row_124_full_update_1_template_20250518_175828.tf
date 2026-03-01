To create an AWS AMI resource for the latest Amazon Linux 2 AMI, we will use the `aws_ami` data source to fetch the most recent Amazon Linux 2 AMI ID. This will allow us to reference the latest AMI in other resources, such as EC2 instances, without hardcoding the AMI ID. We will configure the AWS provider to operate in the `us-east-1` region.

Here is the Terraform HCL configuration:

<iac_template>
```hcl
provider "aws" {
  region = "us-east-1"
}

data "aws_ami" "amazon_linux_2" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["amazon"]
}

output "amazon_linux_2_ami_id" {
  value = data.aws_ami.amazon_linux_2.id
}
```
</iac_template>

This configuration sets up the AWS provider for the `us-east-1` region and uses the `aws_ami` data source to find the most recent Amazon Linux 2 AMI. The AMI ID is then outputted, which can be used in other parts of your Terraform configuration.