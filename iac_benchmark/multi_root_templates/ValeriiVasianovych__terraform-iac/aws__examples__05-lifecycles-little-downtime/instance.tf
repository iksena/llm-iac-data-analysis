resource "aws_eip" "static_ip" {
  instance = aws_instance.little_downtime.id
  }

resource "aws_instance" "little_downtime" {
  ami                    = "ami-04b70fa74e45c3917"
  instance_type          = "t2.small"
  key_name               = "ServersKey"
  vpc_security_group_ids = [aws_security_group.lifecycle_security_group.id]
  user_data              = file("script.sh")

  tags = {
    Name    = "LifecycleElasticServer"
    Owner   = "Valerii Vasianovych"
    Project = "AWS Instance Creation with Terraform and dynamic template"
  }

  lifecycle {
    create_before_destroy = true
  }
}