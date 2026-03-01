To create an AWS AMI resource for the latest Amazon Linux 2 AMI, we will use the AWS provider to search for the most recent Amazon Linux 2 AMI ID in a specified region. This configuration will include a data source to fetch the latest AMI ID and output it for use in other resources or for informational purposes. We will configure the AWS provider to use a specific region, and we will ensure that all necessary components are included for a deployable Terraform configuration.

<iac_template>
```hcl
provider "aws" {
  region = "us-east-1"
}

data "aws_ami" "latest_amazon_linux_2" {
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

output "latest_amazon_linux_2_ami_id" {
  value = data.aws_ami.latest_amazon_linux_2.id
}
```
</iac_template>

This Terraform configuration will output the AMI ID of the latest Amazon Linux 2 AMI available in the "us-east-1" region. The `data "aws_ami"` block is used to query AWS for the most recent AMI that matches the specified filters, ensuring that it is an Amazon Linux 2 AMI with HVM virtualization.