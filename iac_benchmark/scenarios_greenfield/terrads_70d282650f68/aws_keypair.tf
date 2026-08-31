resource "aws_key_pair" "sshkey" {
  key_name = "${var.app_name}-key"
  public_key = "${var.my_public_key}"
}
