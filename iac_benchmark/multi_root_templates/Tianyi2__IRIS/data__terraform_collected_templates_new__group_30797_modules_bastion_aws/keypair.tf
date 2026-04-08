resource "aws_key_pair" "terraform" {
  key_name       = "${var.env_name}-keypair"
  public_key = file(var.public_key)
}