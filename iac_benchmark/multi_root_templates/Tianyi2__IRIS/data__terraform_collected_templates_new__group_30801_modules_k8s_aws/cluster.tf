resource "aws_instance" "master" {
  count                  = var.master_count
  ami                    = var.image_id
  instance_type          = var.instance_type
  key_name               = "${var.env_name}-keypair"
  subnet_id              = var.subnet_id
  vpc_security_group_ids = var.security_group_ids
  tags = {
    Name = "${var.env_name}-master-${var.worker_name}-${count.index}"
  }
  root_block_device {
    volume_size = var.volume_size
    volume_type = "standard"
    delete_on_termination = true
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
}

resource "null_resource" "cluster" {
  connection {
    host = var.bastion_ip
    agent = "true"
    type = "ssh"
    user = "centos"
    private_key = file(var.private_key)
    timeout = "10m"
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

      worker_ips = aws_instance.worker.*.private_ip
      master_ips = aws_instance.master.*.private_ip
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

  depends_on = [aws_instance.worker, aws_instance.master]
}

resource "null_resource" "kubeconfig" {
   connection {
    host = aws_instance.master.*.private_ip[0]
    agent = "true"
    type = "ssh"
    user = "centos"
    private_key = file(var.private_key)
    bastion_host = var.bastion_ip
    bastion_private_key = file(var.private_key)
    timeout = "10m"
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
    timeout = "10m"
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
      MASTER_IP = aws_instance.master.*.private_ip[0]
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