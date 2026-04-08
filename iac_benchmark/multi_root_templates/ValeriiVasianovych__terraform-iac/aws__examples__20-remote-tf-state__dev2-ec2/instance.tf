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
