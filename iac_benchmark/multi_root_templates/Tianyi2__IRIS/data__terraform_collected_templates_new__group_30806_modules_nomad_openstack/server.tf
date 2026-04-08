locals {
  consul_hosts = var.agent_type == "server" ? openstack_compute_instance_v2.server.*.network.0.fixed_ip_v4: var.consul_hosts
}

data "template_file" "consul_server_config" {
  template = file("${path.module}/../templates/consul/${var.agent_type}.hcl.tpl")

  vars = {
    instances              = var.worker_count
    datacenter             = var.datacenter
  }
}

data "template_file" "nomad_server_config" {
  template = file("${path.module}/../templates/nomad/${var.agent_type}.hcl.tpl")

  vars = {
    instances              = var.worker_count
    datacenter             = var.datacenter
  }
}

resource "openstack_compute_servergroup_v2" "server_group" {
  name     = var.server_group
  policies = var.server_group_policies
}

resource "openstack_compute_instance_v2" "server" {
  count             = var.worker_count
  name              = "${var.env_name}-${var.agent_type}-${var.worker_name}-${count.index}"
  flavor_name       = var.worker_flavor
  image_name        = var.worker_image
  key_pair          = "${var.env_name}-keypair"

  connection {
    host                = self.network.0.fixed_ip_v4
    agent               = "true"
    type                = "ssh"
    user                = "centos"
    private_key         = file(var.private_key)
    bastion_host        = var.bastion_ip
    bastion_private_key = file(var.private_key)
  }

  provisioner "remote-exec" {
    inline = [
      "sudo groupadd docker",
      "sudo usermod -aG docker centos"
    ]
  }

  scheduler_hints {
    group             = openstack_compute_servergroup_v2.server_group.id
  }


  network {
    uuid = var.network_id
  }

  security_groups = var.security_group_ids
}

resource "null_resource" "servers_cluster" {
  count = var.worker_count

  connection {
    host                = openstack_compute_instance_v2.server.*.network.0.fixed_ip_v4[count.index]
    agent               = "true"
    type                = "ssh"
    user                = "centos"
    private_key         = file(var.private_key)
    bastion_host        = var.bastion_ip
    bastion_private_key = file(var.private_key)
  }

  provisioner "file" {
    content = templatefile("${path.module}/../templates/setup.sh.tpl",
    {
      server_type = var.agent_type
      consul_version = var.consul_version,
      nomad_version = var.nomad_version,
      consul_config = data.template_file.consul_server_config.rendered
      nomad_config = data.template_file.nomad_server_config.rendered
      consul_hosts = local.consul_hosts
      docker_username = var.docker_username
      docker_password = var.docker_password
    }
    )
    destination     = "/home/centos/setup.sh"
  }


  provisioner "remote-exec" {
    inline = [
      "chmod +x /home/centos/setup.sh",
      "/home/centos/setup.sh",
    ]
  }

  depends_on = [
    openstack_compute_instance_v2.server,
    data.template_file.consul_server_config,
    data.template_file.nomad_server_config
  ]
}


