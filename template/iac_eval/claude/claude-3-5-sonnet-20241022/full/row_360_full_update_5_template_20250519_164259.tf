I'll create a simple Lightsail instance template without the snapshot feature, as it seems the snapshot resources are not currently supported in the AWS provider.

<iac_template>
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_lightsail_instance" "main" {
  name              = "my-lightsail-instance"
  availability_zone = "us-east-1a"
  blueprint_id      = "amazon_linux_2"
  bundle_id         = "nano_2_0"

  tags = {
    Name        = "my-lightsail-instance"
    Environment = "Production"
  }
}

output "instance_ip" {
  value = aws_lightsail_instance.main.public_ip_address
}
</iac_template>

Note: It appears that automatic snapshots in Lightsail cannot be managed directly through Terraform at this time. You would need to enable automatic snapshots through the AWS Console or AWS CLI after the instance is created. Alternatively, you could use a null_resource with local-exec provisioner to run AWS CLI commands to enable automatic snapshots, but that would be less elegant and not fully managed by Terraform's state.