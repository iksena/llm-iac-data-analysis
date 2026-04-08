resource "openstack_compute_instance_v2" "ftp" {
  name              = "${var.env_name}-ftp"
  flavor_name       = var.flavor
  image_name        = var.image
  key_pair          = "${var.env_name}-keypair"


  network {
    uuid = var.network_id
  }

  security_groups = [
    "default",
  ]

}

resource "null_resource" "ftp_packages" {

  connection {
    bastion_host = var.bastion_ip
    host =              openstack_compute_instance_v2.ftp.network.0.fixed_ip_v4
    agent               = "true"
    type                = "ssh"
    user                = "centos"
    private_key         = file(var.private_key)
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

  depends_on = [
    openstack_compute_instance_v2.ftp,
  ]
}


