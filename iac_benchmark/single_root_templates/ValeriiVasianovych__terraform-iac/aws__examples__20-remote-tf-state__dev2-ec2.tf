# ── main.tf ────────────────────────────────────
terraform {
  backend "s3" {
    bucket = "terrafrom-tfstate-file-s3-bucket"
    # dynamodb_table = "terraform-tfstate-dynamodb"
    encrypt = true
    key     = "aws/tfstates/remote-tf-state/dev2/terraform.tfstate"
    region  = "us-east-1"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }
}

module "common_vars" {
  source = "../common"
}

# ── outputs.tf ────────────────────────────────────
output "sg_group_id" {
  value = aws_security_group.webserver.id
}

output "webservers_ids" {
  value = aws_instance.ubuntu_webserver[*].id
}

output "aws_instance_public_ip" {
  value = [for i in range(length(aws_instance.ubuntu_webserver)) : aws_instance.ubuntu_webserver[i].public_ip]
}

output "aws_instance_private_ip" {
  value = [for i in range(length(aws_instance.ubuntu_webserver)) : aws_instance.ubuntu_webserver[i].private_ip]
}

output "elastic_ip" {
  value = aws_eip.public_eip[*].public_ip
}

output "eip_ids" {
  value = aws_eip.public_eip[*].id
}

# ── datasource.tf ────────────────────────────────────
data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket  = "terrafrom-tfstate-file-s3-bucket"
    encrypt = true
    key     = "aws/tfstates/remote-tf-state/dev1/terraform.tfstate"
    region  = "us-east-1"
  }
}

data "aws_ami" "latest_ubuntu" {
  owners      = ["099720109477"]
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }
}
  

# ── instance.tf ────────────────────────────────────
provider "aws" {
    region = module.common_vars.region
}

resource "aws_instance" "ubuntu_webserver" {
  count         = length(data.terraform_remote_state.vpc.outputs.public_subnet_ids)
  ami           = data.aws_ami.latest_ubuntu.id
  instance_type = (module.common_vars.env == "dev" ? module.common_vars.instance_type.dev : module.common_vars.instance_type.prod)
  key_name      = "ServersKey"
  vpc_security_group_ids = [aws_security_group.webserver.id]
  subnet_id     = element(data.terraform_remote_state.vpc.outputs.public_subnet_ids, count.index)
  user_data     = file("userdata/script.sh")
  tags = merge(module.common_vars.common_tags, {
    Name        = "Ubuntu-${data.aws_ami.latest_ubuntu.id}-${count.index + 1}"
    Subnet      = element(data.terraform_remote_state.vpc.outputs.public_subnet_ids, count.index)
    Environment = "${module.common_vars.env}"
  })
}

resource "aws_security_group" "webserver" {
  name   = "${module.common_vars.env}-webserver-sg"
  vpc_id = data.terraform_remote_state.vpc.outputs.vpc_id["id"]
  dynamic "ingress" {
    for_each = module.common_vars.ingress_ports[module.common_vars.env]
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

  tags = merge(module.common_vars.common_tags, {
    Name        = "${module.common_vars.env}-webserver-sg"
    Environment = "${module.common_vars.env}"
  })
}

resource "aws_eip" "public_eip" {
  count = length(data.terraform_remote_state.vpc.outputs.public_subnet_ids)
  vpc   = true
}

resource "aws_eip_association" "eip_assoc" {
  count          = length(data.terraform_remote_state.vpc.outputs.public_subnet_ids)
  instance_id    = element(aws_instance.ubuntu_webserver.*.id, count.index)
  allocation_id  = element(aws_eip.public_eip.*.id, count.index)
}
