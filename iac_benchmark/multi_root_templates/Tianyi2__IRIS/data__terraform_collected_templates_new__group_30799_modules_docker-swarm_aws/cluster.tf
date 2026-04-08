data "external" "cluster_token" {
  program = [
    "sh",
    "${path.module}/../scripts/generate-tokens.sh"]
  query = {
    manager_host = aws_instance.manager.private_ip
    bastion_host = var.bastion_ip
  }

  depends_on = [
    null_resource.manager_config]
}


resource "aws_instance" "manager" {
  ami                    = var.image_id
  instance_type          = var.instance_type
  key_name               = "${var.env_name}-keypair"
  subnet_id              = var.subnet_id
  vpc_security_group_ids = var.security_group_ids
  tags = {
    Name = "${var.env_name}-manager-${var.worker_name}"
  }
  root_block_device {
    volume_size = var.volume_size
    volume_type = "standard"
    delete_on_termination = true
  }
  connection {
    host = self.private_ip
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

}

resource "null_resource" "manager_config" {
  connection {
    host = aws_instance.manager.private_ip
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
      "docker swarm init --advertise-addr ${aws_instance.manager.private_ip}"
    ]
  }

}

resource "aws_instance" "worker" {
  count                  = var.worker_count
  ami                    = var.image_id
  instance_type          = var.instance_type
  key_name               = "${var.env_name}-keypair"
  subnet_id              = var.subnet_id
  vpc_security_group_ids = var.security_group_ids
  tags = {
    Name = "${var.env_name}-worker-${var.worker_name}-${count.index}"
  }
  root_block_device {
    volume_size = var.volume_size
    volume_type = "standard"
    delete_on_termination = true
  }

  connection {
    host = self.private_ip
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
}

resource "null_resource" "worker_config" {
  count = var.worker_count
  connection {
    host = aws_instance.worker.*.private_ip[count.index]
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
      "docker swarm join --token ${data.external.cluster_token.result.worker} ${aws_instance.manager.private_ip}:2377"
    ]
  }

  depends_on = [
    null_resource.manager_config]
}

resource "null_resource" "faas-service" {
  connection {
    host = aws_instance.manager.private_ip
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
  depends_on = [null_resource.worker_config]
}