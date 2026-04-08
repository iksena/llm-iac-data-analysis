locals {
  consul_hosts = var.agent_type == "server" ? aws_instance.server.*.private_ip: var.consul_hosts
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


resource "aws_instance" "server" {
  count                  = var.worker_count
  ami                    = var.image_id
  instance_type          = var.instance_type
  key_name               = "${var.env_name}-keypair"
  subnet_id              = var.subnet_id
  vpc_security_group_ids = var.security_group_ids
  tags = {
    Name = "${var.env_name}-${var.agent_type}-${var.worker_name}-${count.index}"
  }
  root_block_device {
    volume_size = var.volume_size
    volume_type = "standard"
    delete_on_termination = true
  }
  connection {
    host                = self.private_ip
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
}

resource "null_resource" "servers_cluster" {
  count = var.worker_count

  connection {
    host                = aws_instance.server.*.private_ip[count.index]
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
    aws_instance.server,
    data.template_file.consul_server_config,
    data.template_file.nomad_server_config
  ]
}


