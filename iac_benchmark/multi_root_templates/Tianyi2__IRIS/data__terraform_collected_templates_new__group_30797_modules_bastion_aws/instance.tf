resource "aws_instance" "bastion" {
  ami                    = var.image_id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.terraform.key_name
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [aws_security_group.bastion.id]
  associate_public_ip_address = true
  tags = {
    Name = "${var.env_name}-bastion"
  }
  root_block_device {
    volume_size = var.volume_size
    volume_type = "standard"
    delete_on_termination = true
  }
  depends_on = [aws_security_group.bastion]
}

resource "null_resource" "bastion_packages" {

  connection {
    host                = aws_instance.bastion.public_ip
    agent               = "true"
    type                = "ssh"
    user                = "centos"
    private_key         = file(var.private_key)
    timeout = "10m"
  }

  provisioner "file" {
   source = "${path.module}/../scripts/setup_bastion.sh"
   destination = "/home/centos/setup_bastion.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /home/centos/setup_bastion.sh",
      "/home/centos/setup_bastion.sh",
    ]
  }

  depends_on = [
    aws_instance.bastion,
  ]
}
