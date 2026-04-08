resource "aws_key_pair" "mykeypair" {
  count = var.path_to_public_key == null ? 0 : 1
  key_name   = var.keypair_name
  public_key = file(var.path_to_public_key)
}