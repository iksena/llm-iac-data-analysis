resource "aws_instance" "instance_ubuntu" {
  ami                    = data.aws_ami.latest_ubuntu.id
  instance_type          = var.instance_type             # Instance type, default is t2.micro
  key_name               = "ServersKey"
  vpc_security_group_ids = [aws_security_group.web_sg.id]
  monitoring             = var.monitoring_value          # Monitoring, default is false

  tags = merge(var.common_tags, {                        # Tags to apply to the instance
    Name        = "Ubuntu Instance"
  })
}