data "external" "cluster_token" {
  program = [
    "sh",
    "${path.module}/scripts/generate-tokens.sh"]
  query = {
    manager_host = openstack_compute_instance_v2.manager.*.network.0.fixed_ip_v4[0]
    bastion_host = var.bastion_ip
  }

  depends_on = [
    null_resource.manager_config]
}

resource "openstack_compute_servergroup_v2" "server_group" {
  name = var.server_group
  policies = var.server_group_policies
}

resource "openstack_compute_instance_v2" "manager" {
  name = "${var.env_name}-manager-${var.worker_name}"
  flavor_name = var.server_flavor
  image_name = var.server_image
  key_pair = "${var.env_name}-keypair"

  connection {
    host = self.network.0.fixed_ip_v4
    agent = "true"
    type = "ssh"
    user = "centos"
    private_key = file(var.private_key)
    bastion_host = var.bastion_ip
    bastion_private_key = file(var.private_key)
  }

  provisioner "remote-exec" {
    inline = [
      "sudo yum install epel-release -y",
      "sudo yum install jq git -y",
      "sudo groupadd docker",
      "sudo usermod -aG docker centos"
    ]
  }

  scheduler_hints {
    group = openstack_compute_servergroup_v2.server_group.id
  }

  network {
    uuid = var.network_id
  }

  security_groups = var.security_group_ids

}

resource "null_resource" "manager_config" {
  connection {
    host = openstack_compute_instance_v2.manager.*.network.0.fixed_ip_v4[0]
    agent = "true"
    type = "ssh"
    user = "centos"
    private_key = file(var.private_key)
    bastion_host = var.bastion_ip
    bastion_private_key = file(var.private_key)
  }

  provisioner "file" {
    content = templatefile("${path.module}/../templates/configure.sh.tpl",
    {
      docker_username = var.docker_username
      docker_password = var.docker_password
    }
    )
    destination = "/home/centos/configure.sh"
  }


  provisioner "remote-exec" {
    inline = [
      "chmod +x /home/centos/configure.sh",
      "/home/centos/configure.sh",
    ]
  }

  provisioner "remote-exec" {
    inline = [
      "docker swarm init --advertise-addr ${openstack_compute_instance_v2.manager.*.network.0.fixed_ip_v4[0]}"
    ]
  }

}

resource "openstack_compute_instance_v2" "worker" {
  count = var.worker_count
  name = "${var.env_name}-worker-${var.worker_name}-${count.index}"
  flavor_name = var.server_flavor
  image_name = var.server_image
  key_pair = "${var.env_name}-keypair"

  connection {
    host = self.network.0.fixed_ip_v4
    agent = "true"
    type = "ssh"
    user = "centos"
    private_key = file(var.private_key)
    bastion_host = var.bastion_ip
    bastion_private_key = file(var.private_key)
  }

  provisioner "remote-exec" {
    inline = [
      "sudo yum install epel-release -y",
      "sudo yum install jq git -y",
      "sudo groupadd docker",
      "sudo usermod -aG docker centos"
    ]
  }

  scheduler_hints {
    group = openstack_compute_servergroup_v2.server_group.id
  }

  network {
    uuid = var.network_id
  }

  security_groups = var.security_group_ids
}

resource "null_resource" "worker_config" {
  count = var.worker_count
  connection {
    host = openstack_compute_instance_v2.worker.*.network.0.fixed_ip_v4[count.index]
    agent = "true"
    type = "ssh"
    user = "centos"
    private_key = file(var.private_key)
    bastion_host = var.bastion_ip
    bastion_private_key = file(var.private_key)
  }

  provisioner "file" {
    content = templatefile("${path.module}/../templates/configure.sh.tpl",
    {
      docker_username = var.docker_username
      docker_password = var.docker_password
    }
    )
    destination = "/home/centos/configure.sh"
  }


  provisioner "remote-exec" {
    inline = [
      "chmod +x /home/centos/configure.sh",
      "/home/centos/configure.sh",
    ]
  }

  provisioner "remote-exec" {
    inline = [
      "docker swarm join --token ${data.external.cluster_token.result.worker} ${openstack_compute_instance_v2.manager.*.network.0.fixed_ip_v4[0]}:2377"
    ]
  }

  depends_on = [
    null_resource.manager_config]
}

resource "null_resource" "faas-service" {
  connection {
    host = openstack_compute_instance_v2.manager.*.network.0.fixed_ip_v4[0]
    agent = "true"
    type = "ssh"
    user = "centos"
    private_key = file(var.private_key)
    bastion_host = var.bastion_ip
    bastion_private_key = file(var.private_key)
  }

  provisioner "remote-exec" {
    inline = [
      "git clone https://github.com/mabuaisha/faas",
      "cd faas && ./deploy_stack.sh",
      "curl https://raw.githubusercontent.com/mabuaisha/faas-idler/master/docker-compose.yml -o faas-idler.yml",
      "docker stack deploy func -c faas-idler.yml"
    ]
  }
  depends_on = [
    null_resource.worker_config]
}