variable "instance_name_maininstance" {
  description = "Value of the Name tag for the EC2 instance"
  type        = string
  default     = "MainInstance"
}



data "aws_ami" "latestamazon2" {
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*"]
  }
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
  owners = ["amazon"]
}


resource "aws_instance" "maininstance" {
  #ami                         = "ami-00a4e06732205ac29"
  ami                         = data.aws_ami.latestamazon2.id
  instance_type               = "t2.micro"
  vpc_security_group_ids      = [aws_security_group.main_sg.id]
  subnet_id                   = aws_subnet.subnet_main.id
  associate_public_ip_address = true
  key_name                    = var.main_key_name
  tags = {
    Name    = var.instance_name_maininstance
    Purpose = "LAB"
    Role    = "OAM"
	
  }

  root_block_device {
    volume_size           = "20"
    volume_type           = "gp2"
    encrypted             = true
    kms_key_id            = "2f545a27-40fc-4a92-b8cb-3ed8c35f59e3"
    delete_on_termination = true
  }

  provisioner "remote-exec" {
    inline = ["sudo hostnamectl set-hostname ${var.instance_name_maininstance}"]
  }

  provisioner "local-exec" {
    command = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -u ec2-user  --private-key ${var.private_key} -i ~/cloudstuffs/aws/aws_ec2.yml -l tag_Name_${self.tags.Name} ansible/first-install.yml"
    //command = "/bin/true"
  }


  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file(var.private_key)
    host        = self.public_ip
  }
}

resource "aws_route53_record" "maininstanceipv4" {
  zone_id = data.aws_route53_zone.ybonnamyname.zone_id
  name    = "${var.instance_name_maininstance}.${var.publicdomainname}"
  type    = "A"
  ttl     = 300
  records = [aws_instance.maininstance.public_ip]
}

resource "aws_route53_record" "maininstanceipv6" {
  zone_id = data.aws_route53_zone.ybonnamyname.zone_id
  name    = "${var.instance_name_maininstance}.${var.publicdomainname}"
  type    = "AAAA"
  ttl     = 300
  records = [aws_instance.maininstance.ipv6_addresses[0]]
}
