// Tested in us-west-2
data "aws_ami" "flatcar" {
  most_recent = true
  owners      = ["075585003325"]
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  filter {
    name   = "name"
    values = ["Flatcar-stable-*"]
  }
}

locals {
  data = jsonencode(jsondecode(templatefile("${path.module}/linux-config/machine.tpl", { allowed_users = var.allowed_users, ssh_port = var.ssh_port, aws_s3_bucket = aws_s3_bucket_website_configuration.ssh_public_keys.website_endpoint })))
}

// Just in case something goes wrong, the AMI ID for us-west-2 flatcar is 'ami-0bb54692374ac10a7'
// Source: https://docs.flatcar-linux.org/os/booting-on-ec2/
//
resource "aws_launch_template" "bastion" {
  image_id      = data.aws_ami.flatcar.image_id
  instance_type = var.instance_type
  user_data     = base64encode(local.data)
  key_name      = var.key_name

  monitoring {
    enabled = true
  }

  network_interfaces {
    security_groups = concat(
      [aws_security_group.bastion.id],
      var.additional_security_groups,
    )

    associate_public_ip_address = var.associate_public_ip_address
  }
}
