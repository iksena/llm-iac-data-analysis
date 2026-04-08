resource "aws_security_group" "ec2_nat" {
  name        = "${local.name}-ec2_nat-ec2-sg"
  description = "security group for ec2_nat EC2 "
  vpc_id      = aws_vpc.this.id

  ingress {
    description = "open to all NAT"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [local.cidr_block]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = { Name = "${local.name}-ec2_nat-ec2-sg" }
}


resource "aws_instance" "ec2_nat" {
  ami                    = data.aws_ami.this.id
  instance_type          = local.instance_type
  key_name               = aws_key_pair.this.key_name
  source_dest_check      = false // must uncheck this to allow traffic forward
  subnet_id              = aws_subnet.public[0].id
  vpc_security_group_ids = [aws_security_group.ec2_nat.id]
  root_block_device {
    volume_type = local.volume_type
    volume_size = local.volume_size
  }
  tags = { Name = "${local.name}-ec2_nat-ec2" }

  user_data = <<EOT
#!/bin/bash
echo 1 > /proc/sys/net/ipv4/ip_forward
iptables -t nat -A POSTROUTING -o  ens5 -j MASQUERADE
iptables -A FORWARD -i ens5 -j ACCEPT
EOT
}

resource "aws_route" "nat_route" {
  // route the private subnet via this EC2 instance
  route_table_id         = aws_route_table.private.id
  network_interface_id   = aws_instance.ec2_nat.primary_network_interface_id
  destination_cidr_block = "0.0.0.0/0"
}