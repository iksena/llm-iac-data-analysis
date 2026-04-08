

resource "aws_security_group" "private" {
  name        = "${local.name}-private-ec2-sg"
  description = "security group for private EC2 "
  vpc_id      = aws_vpc.this.id

  ingress {
    description      = "port 80 for nginx"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description      = "port 22 for ssh"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = { Name = "${local.name}-private-ec2-sg" }
}


resource "aws_instance" "private" {
  depends_on = [aws_instance.ec2_nat]

  ami           = data.aws_ami.this.id
  instance_type = local.instance_type
  key_name      = aws_key_pair.this.key_name

  subnet_id = aws_subnet.private[0].id

  vpc_security_group_ids = [aws_security_group.private.id]

  root_block_device {
    volume_type = local.volume_type
    volume_size = local.volume_size
  }

  user_data = <<EOT
#!/bin/bash
apt update
apt -qqy install nginx --no-install-recommends
systemctl enable nginx
systemctl start nginx
EOT

  tags = { Name = "${local.name}-private-ec2" }
}
