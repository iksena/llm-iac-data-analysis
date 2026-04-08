data "aws_ami" "amazon_linux_2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "web" {
  count                  = length(var.subnet_ids)
  ami                    = var.ami_id != "" ? var.ami_id : data.aws_ami.amazon_linux_2023.id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_ids[count.index]
  vpc_security_group_ids = [var.security_group_id]
  key_name               = var.key_name != "" ? var.key_name : null

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y httpd
              systemctl start httpd
              systemctl enable httpd
              INSTANCE_ID=$(ec2-metadata --instance-id | cut -d ' ' -f 2)
              AZ=$(ec2-metadata --availability-zone | cut -d ' ' -f 2)
              echo "<html><head><title>HA Web App</title></head><body style='font-family: Arial; text-align: center; padding: 50px;'><h1>Hello from Instance $INSTANCE_ID</h1><h2>Availability Zone: $AZ</h2><p>This is instance ${count.index + 1} of ${length(var.subnet_ids)}</p></body></html>" > /var/www/html/index.html
              EOF

  tags = {
    Name = "${var.project_name}-instance-${count.index + 1}"
  }
}
