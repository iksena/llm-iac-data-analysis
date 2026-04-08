resource "openstack_compute_instance_v2" "bastion" {
  name              = "${var.env_name}-bastion"
  flavor_name       = var.flavor
  image_name        = var.image
  key_pair          = openstack_compute_keypair_v2.terraform.name


  network {
    uuid = var.network_id
  }

  block_device {
    volume_size = "15"
    source_type           = "blank"
    destination_type      = "volume"
    delete_on_termination = true
  }

  security_groups = [
    openstack_compute_secgroup_v2.bastion.name,
    "default",
  ]

  provisioner "local-exec" {
    command = "ssh-add ${var.private_key}"
  }
}

resource "openstack_compute_floatingip_associate_v2" "bastion_ip" {
  floating_ip = openstack_networking_floatingip_v2.bastion_ip.address
  instance_id = openstack_compute_instance_v2.bastion.id
  fixed_ip    = openstack_compute_instance_v2.bastion.network.0.fixed_ip_v4
}

resource "null_resource" "bastion_packages" {

  connection {
    host                = openstack_networking_floatingip_v2.bastion_ip.address
    agent               = "true"
    type                = "ssh"
    user                = "centos"
    private_key         = file(var.private_key)
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
    openstack_compute_floatingip_associate_v2.bastion_ip,
    openstack_compute_instance_v2.bastion,
  ]
}

