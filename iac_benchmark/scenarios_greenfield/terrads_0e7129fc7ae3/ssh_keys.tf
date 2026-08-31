resource "tls_private_key" "main" {
  for_each  = toset(var.ec2_instances)
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "main" {
  for_each = toset(var.ec2_instances)

  key_name   = "${each.key}-${local.bootcamp_id}"
  public_key = tls_private_key.main[each.key].public_key_openssh
}
