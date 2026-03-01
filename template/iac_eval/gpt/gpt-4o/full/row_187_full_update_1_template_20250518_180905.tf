To create the latest Amazon Linux 2 AMI using Terraform, we will define a configuration that uses the AWS provider to search for the most recent Amazon Linux 2 AMI. We will use the `aws_ami` data source to find the latest AMI based on specific filters. This configuration will be deployable in the `us-east-1` region. 

The Terraform program will include:
- AWS provider configuration.
- A data source to fetch the latest Amazon Linux 2 AMI.

Here is the Terraform HCL program:

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
    name   = "owner-id"
    values = ["137112412989"]
  }
}

output "latest_amazon_linux_2_ami_id" {
  value = data.aws_ami.latest_amazon_linux_2.id
}
```
</iac_template>

This configuration will output the ID of the latest Amazon Linux 2 AMI available in the specified region.