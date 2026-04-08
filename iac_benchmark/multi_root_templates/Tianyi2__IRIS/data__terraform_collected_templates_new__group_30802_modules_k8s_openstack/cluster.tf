resource "openstack_compute_servergroup_v2" "server_group" {
  name = var.server_group
  policies = var.server_group_policies
}

resource "openstack_compute_instance_v2" "master" {
  count             = var.master_count
  name              = "${var.env_name}-master-${var.worker_name}-${count.index}"
  flavor_name       = var.server_flavor
  image_name        = var.server_image
  key_pair          = "${var.env_name}-keypair"

  scheduler_hints {
    group = openstack_compute_servergroup_v2.server_group.id
  }

  network {
    uuid = var.network_id
  }

  security_groups = var.security_group_ids

}

resource "openstack_compute_instance_v2" "worker" {
  count             = var.worker_count
  name              = "${var.env_name}-worker-${var.worker_name}-${count.index}"
  flavor_name       = var.server_flavor
  image_name        = var.server_image
  key_pair          = "${var.env_name}-keypair"

  scheduler_hints {
    group = openstack_compute_servergroup_v2.server_group.id
  }

  network {
    uuid = var.network_id
  }

  security_groups = var.security_group_ids

}

resource "null_resource" "cluster" {
  connection {
    host = var.bastion_ip
    agent = "true"
    type = "ssh"
    user = "centos"
    private_key = file(var.private_key)
  }

  provisioner "file" {
    source = var.private_key
    destination = "/home/centos/faas_key.pem"
  }

  provisioner "remote-exec" {
    inline = ["chmod 400 /home/centos/faas_key.pem"]
  }

  provisioner "file" {
    content = templatefile("${path.module}/../templates/inventory.yml.tpl",
    {
      worker_ips = openstack_compute_instance_v2.worker.*.network.0.fixed_ip_v4
      master_ips = openstack_compute_instance_v2.master.*.network.0.fixed_ip_v4
    }
    )
    destination     = "/home/centos/inventory.yml"
  }

  provisioner "file" {
    source = "${path.module}/../scripts/setup_cluster.sh"
    destination = "/home/centos/setup_cluster.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod 400 /home/centos/faas_key.pem",
      "chmod +x /home/centos/setup_cluster.sh",
      "/home/centos/setup_cluster.sh",
    ]
  }

  depends_on = [openstack_compute_instance_v2.worker, openstack_compute_instance_v2.master]
}

resource "null_resource" "kubeconfig" {
   connection {
    host = openstack_compute_instance_v2.master.*.network.0.fixed_ip_v4[0]
    agent = "true"
    type = "ssh"
    user = "centos"
    private_key = file(var.private_key)
    bastion_host = var.bastion_ip
    bastion_private_key = file(var.private_key)
  }
  provisioner "remote-exec" {
    inline = [
      "sudo cp /etc/kubernetes/admin.conf /home/centos/admin.conf",
      "sudo chown centos. /home/centos/admin.conf",
      "sudo chmod 640 /home/centos/admin.conf",]
  }
  depends_on = [null_resource.cluster]
}

resource "null_resource" "openfaas" {
  connection {
    host = var.bastion_ip
    agent = "true"
    type = "ssh"
    user = "centos"
    private_key = file(var.private_key)
  }

  provisioner "file" {
    source = "${path.module}/../templates/prometheus-ingress.yaml"
    destination = "/home/centos/prometheus-ingress.yaml"
  }


  provisioner "file" {
    content = templatefile("${path.module}/../templates/deploy_openfaas.sh.tpl",
    {
      DOCKER_USERNAME = var.docker_username
      DOCKER_PASSWORD = var.docker_password
      DOCKER_EMAIL = var.docker_email
      MASTER_IP = openstack_compute_instance_v2.master.*.network.0.fixed_ip_v4[0]
    }
    )
    destination     = "/home/centos/deploy_openfaas.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /home/centos/deploy_openfaas.sh",
      "source /home/centos/deploy_openfaas.sh",
    ]
  }

  depends_on = [null_resource.kubeconfig]
}