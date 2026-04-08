resource "aws_instance" "ui" {
  ami                  = "${var.ami}"
  instance_type        = "${var.instance_type}"
  subnet_id            = module.vpc_networking.public_subnet_ids[0]

  root_block_device {
    delete_on_termination = true
    volume_size           = "${var.volume_size}"
    volume_type           = "${var.volume_type}"
  }

  vpc_security_group_ids = [aws_security_group.ui.id]
}
