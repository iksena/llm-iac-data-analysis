resource "aws_instance" "this" {
  ami             = var.instance_ami 
  instance_type   = var.instance_type
  subnet_id       = var.subnet_id
  security_groups = [var.security_group_id]

  tags = merge(
    var.common_tags,
    {
    Name = "Latest Ubuntu EC2 Instance ${var.instance_ami}"
    }
  )
}