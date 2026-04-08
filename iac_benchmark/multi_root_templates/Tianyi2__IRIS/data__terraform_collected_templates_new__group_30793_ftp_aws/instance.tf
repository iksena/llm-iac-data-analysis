resource "aws_instance" "ftp" {
  ami                    = var.image_id
  instance_type          = var.instance_type
  key_name               = "${var.env_name}-keypair"
  subnet_id              = var.subnet_id
  vpc_security_group_ids = var.security_group_ids
  tags = {
    Name = "${var.env_name}-ftp"
  }
  root_block_device {
    volume_size = var.volume_size
    volume_type = "standard"
    delete_on_termination = true
  }
}


resource "null_resource" "ftp_packages" {

  connection {
    bastion_host = var.bastion_ip
    host = aws_instance.ftp.private_ip
    agent = "true"
    type = "ssh"
    user = "centos"
    private_key = file(var.private_key)
    timeout = "10m"
  }

  provisioner "file" {

    content = templatefile("${path.module}/../templates/setup_ftp.sh.tpl",
    {
      ftp_username = var.ftp_username
      ftp_password = var.ftp_password
    }
    )
    destination = "/home/centos/setup_ftp.sh"
  }

  provisioner "file" {
   source = "${path.module}/../templates/vsftpd.conf"
   destination = "/home/centos/vsftpd.conf"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /home/centos/setup_ftp.sh",
      "/home/centos/setup_ftp.sh",
    ]
  }

  depends_on = [aws_instance.ftp]
}