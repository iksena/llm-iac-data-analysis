resource "aws_eip" "static_ip" {
  instance = aws_instance.instance_ubuntu.id
  tags = merge(var.common_tags, {
    Name = "${var.common_tags["Environment"]} Server IP"
  })
}
