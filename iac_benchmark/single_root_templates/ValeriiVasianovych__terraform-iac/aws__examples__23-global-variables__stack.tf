# ── main.tf ────────────────────────────────────
terraform {
  backend "s3" {
    bucket       = "terrafrom-tfstate-file-s3-bucket"
    encrypt      = true
    key          = "aws/tfstates/examples/23-global-variables/stack/terraform.tfstate"
    region       = "us-east-1"
    use_lockfile = true
  }
}

provider "aws" {
  region = local.region
}

#================================================================
#================================================================

locals {
  region                 = data.terraform_remote_state.global_vars.outputs.region
  env                    = data.terraform_remote_state.global_vars.outputs.env
  common_tags            = data.terraform_remote_state.global_vars.outputs.common_tags
  security_group_ingress = data.terraform_remote_state.global_vars.outputs.security_group_ingress
  instance_types         = data.terraform_remote_state.global_vars.outputs.instance_types
}

output "region" {
  value = local.region
}

output "env" {
  value = local.env
}

output "common_tags" {
  value = local.common_tags
}

output "security_group_ingress" {
  value = local.security_group_ingress
}

output "instance_types" {
  value = local.instance_types
}

#================================================================
#================================================================

# ── outputs.tf ────────────────────────────────────
output "instance_public_ip" {
  value = aws_instance.example.public_ip
}

# ── datasource.tf ────────────────────────────────────
data "aws_caller_identity" "current" {}

data "aws_ami" "latest_ubuntu" {
  owners      = ["099720109477"]
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }
}

data "terraform_remote_state" "global_vars" {
  backend = "s3"
  config = {
    bucket = "terrafrom-tfstate-file-s3-bucket"
    key    = "aws/tfstates/examples/23-global-variables/globals/terraform.tfstate"
    region = "us-east-1"
  }
}

# ── instance.tf ────────────────────────────────────
resource "aws_instance" "example" {
  ami             = data.aws_ami.latest_ubuntu.id
  instance_type   = local.instance_types["micro"]
  key_name        = "ServersKey"
  security_groups = [aws_security_group.example.name]
  user_data = templatefile("nginx-server.sh.tpl", {
    region = "${local.region}"
  })

  tags = merge(local.common_tags, {
    Name = "${local.env}-instance"
  })
}

resource "aws_security_group" "example" {
  name_prefix = "security-group"
  description = "An example security group for Terraform"

  dynamic "ingress" {
    for_each = local.security_group_ingress
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.common_tags, {
    Name = "${local.env}-security-group"
  })
}