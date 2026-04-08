data "template_file" "ansible_configuration_tpl" {
  template = file("${path.module}/templates/ansible-configuration.tpl")

  vars = {
    ssh_key     = var.ssh_private_key
    remote_user = var.ssh_remote_user
  }
}

data "template_file" "ansible_inventory_tpl" {
  template = file("${path.module}/templates/ansible-inventory.tpl")

  vars = {
    masters = join("\n", [for i in google_compute_instance.master : i.network_interface[0].access_config[0].nat_ip])
    workers = join("\n", [for i in google_compute_instance.worker : i.network_interface[0].access_config[0].nat_ip])
  }
}

resource "null_resource" "make_inventory" {
  provisioner "local-exec" {
    command     = "echo \"${data.template_file.ansible_inventory_tpl.rendered}\" > .inventory"
    working_dir = path.cwd
  }

  depends_on = [
    google_compute_instance.worker,
    google_compute_instance.master
  ]
}

resource "null_resource" "make_ansible_config" {
  provisioner "local-exec" {
    command     = "echo \"${data.template_file.ansible_configuration_tpl.rendered}\" > ansible.cfg"
    working_dir = path.cwd
  }
}

resource "null_resource" "worker_reachability_test" {
  for_each = google_compute_instance.worker

  provisioner "remote-exec" {
    connection {
      host        = each.value.network_interface[0].access_config[0].nat_ip
      user        = var.ssh_remote_user
      private_key = file(var.ssh_private_key)
    }

    inline = ["echo 'connected'"]
  }
}

resource "null_resource" "master_reachability_test" {
  for_each = google_compute_instance.master

  provisioner "remote-exec" {
    connection {
      host        = each.value.network_interface[0].access_config[0].nat_ip
      user        = var.ssh_remote_user
      private_key = file(var.ssh_private_key)
    }

    inline = ["echo 'connected'"]
  }
}

resource "null_resource" "ensure_private_key_permissions" {
  provisioner "local-exec" {
    command = "chmod 400 ${var.ssh_private_key}"
  }
}

resource "null_resource" "run_ansible_playbook" {
  provisioner "local-exec" {
    command     = "ansible-playbook ${path.module}/ansible/cluster-playbook.yml -e \"external_dns_name=${var.control_plane_endpoint}\""
    working_dir = path.cwd
    environment = {
      "ANSIBLE_HOST_KEY_CHECKING" = "False"
      "ANSIBLE_CONFIG"            = "${path.cwd}/ansible.cfg"
    }
  }

  depends_on = [
    null_resource.ensure_private_key_permissions,
    null_resource.master_reachability_test,
    null_resource.worker_reachability_test,
    null_resource.make_ansible_config,
    null_resource.make_inventory
  ]
}

resource "time_sleep" "safety_timer" {
  depends_on      = [null_resource.run_ansible_playbook]
  create_duration = "10s"
}

resource "null_resource" "run_user_creation" {
  provisioner "local-exec" {
    command     = "${path.module}/scripts/create-user-certificate.sh ${var.cluster_user} system:masters"
    working_dir = path.cwd
  }

  depends_on = [
    time_sleep.safety_timer
  ]
}

data "local_file" "credentials" {
  filename = "${path.cwd}/.user-credentials"

  depends_on = [
    null_resource.run_user_creation
  ]
}

output "worker_public_ip" {
  value = { for i in google_compute_instance.worker : i.name => i.network_interface[0].access_config[0].nat_ip }
}

output "master_public_ip" {
  value = { for i in google_compute_instance.worker : i.name => i.network_interface[0].access_config[0].nat_ip }
}

output "cluster_ca" {
  value = split(":", data.local_file.credentials.content)[0]
}

output "user_certificate" {
  value = split(":", data.local_file.credentials.content)[1]
}

output "user_key" {
  value = split(":", data.local_file.credentials.content)[2]
  sensitive = true
}
