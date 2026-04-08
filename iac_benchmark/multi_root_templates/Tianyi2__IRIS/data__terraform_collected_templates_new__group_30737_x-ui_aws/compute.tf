# https://wiki.debian.org/Cloud/AmazonEC2Image
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami
data "aws_ami" "debian" {
  most_recent = true
  owners      = ["136693071363"]

  filter {
    name   = "name"
    values = ["debian-11-amd64-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance
resource "aws_instance" "vpn" {
  subnet_id = aws_subnet.vpn.0.id

  launch_template {
    id      = aws_launch_template.vpn.id
    version = "$Latest"
  }

  # https://developer.hashicorp.com/terraform/language/resources/provisioners/syntax
  # https://developer.hashicorp.com/terraform/language/resources/provisioners/connection
  # https://developer.hashicorp.com/terraform/language/resources/provisioners/file

  connection {
    type        = "ssh"
    user        = "admin"
    host        = self.public_ip
    private_key = tls_private_key.vpn.private_key_openssh
  }

  provisioner "remote-exec" {
    inline = [
      "sudo mkdir -p /cert",
      "sudo chown :admin /cert",
      "sudo usermod -a -G admin admin",
      "sudo chmod g+w /cert",
    ]
  }

  provisioner "file" {
    content     = acme_certificate.cert.private_key_pem
    destination = "/cert/private_key.pem"
  }

  provisioner "file" {
    content     = acme_certificate.cert.certificate_pem
    destination = "/cert/certificate.pem"
  }

  provisioner "file" {
    content     = acme_certificate.cert.issuer_pem
    destination = "/cert/issuer_cert.pem"
  }
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_template
resource "aws_launch_template" "vpn" {
  name                                 = "vpn-${var.name}"
  image_id                             = data.aws_ami.debian.id
  instance_type                        = var.instance_type
  key_name                             = aws_key_pair.vpn.key_name
  user_data                            = base64encode(data.template_file.user_data.rendered)
  instance_initiated_shutdown_behavior = "terminate"

  iam_instance_profile {
    name = aws_iam_instance_profile.vpn.name
  }

  network_interfaces {
    associate_public_ip_address = true
    delete_on_termination       = true
    security_groups             = [aws_security_group.vpn.id]
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "vpn-${var.name}"
    }
  }

  tags = {
    Name = "vpn-${var.name}"
  }

  lifecycle {
    ignore_changes = [
      tags,
      tag_specifications.0.tags,
    ]
  }
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/key_pair
resource "aws_key_pair" "vpn" {
  key_name   = "vpn-${var.name}"
  public_key = tls_private_key.vpn.public_key_openssh

  tags = {
    Name = "vpn-${var.name}"
  }

  lifecycle {
    ignore_changes = [tags]
  }
}

# https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/private_key
resource "tls_private_key" "vpn" {
  algorithm = "ED25519"
}

# https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/sensitive_file
resource "local_sensitive_file" "private_key" {
  filename             = local.private_key_file
  content              = tls_private_key.vpn.private_key_openssh
  file_permission      = "400"
  directory_permission = "700"
}

# https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file
resource "local_file" "ssh_config" {
  filename             = local.ssh_config_file
  content              = data.template_file.ssh_config.rendered
  file_permission      = "600"
  directory_permission = "700"
}

# https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file
data "template_file" "ssh_config" {
  template = file("${path.module}/ssh-config.tpl")
  vars = {
    name             = var.name
    address          = aws_instance.vpn.public_ip
    private_key_file = basename(local.private_key_file)
  }
}

# https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file
data "template_file" "user_data" {
  template = file("${path.module}/user-data.tpl")
  vars = {
    username = local.panel_username
    password = local.panel_password
    port     = local.panel_port
  }
}
