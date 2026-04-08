provider "aws" {
  region = var.region
}

resource "aws_security_group" "webserver-sg" {
  name   = "webserver-sg"
  vpc_id = local.vpc_id

  dynamic "ingress" {
    for_each = [22, 80, 443]
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
}

resource "aws_instance" "webserver" {
  ami                         = data.aws_ami.latest_ubuntu.id
  instance_type               = "t2.micro"
  subnet_id                   = local.subnet_id
  associate_public_ip_address = true
  key_name                    = local.key_name
  security_groups             = [aws_security_group.webserver-sg.id]

  provisioner "remote-exec" {
    inline = ["echo 'Wait until SSH is ready'"]

    connection {
      type        = "ssh"
      user        = local.ssh_user
      private_key = file(local.private_key_path)
      host        = aws_instance.webserver.public_ip
    }
  }

  provisioner "local-exec" {
    command = "ansible-playbook -i ${aws_instance.webserver.public_ip}, --private-key ${local.private_key_path} nginx-playbook.yaml"
  }

  depends_on = [aws_security_group.webserver-sg]

  tags = merge(var.common_tags, {
    Name    = "WebServer Instance in ${var.region}"
    Project = "Terraform with Ansible"
  })
}