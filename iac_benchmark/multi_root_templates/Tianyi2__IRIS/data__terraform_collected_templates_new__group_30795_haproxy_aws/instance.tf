resource "aws_instance" "haproxy" {
  ami                    = var.image_id
  instance_type          = var.instance_type
  key_name               = "${var.env_name}-keypair"
  subnet_id              = var.subnet_id
  vpc_security_group_ids = var.security_group_ids
  tags = {
    Name = "${var.env_name}-haproxy"
  }
  root_block_device {
    volume_size = var.volume_size
    volume_type = "standard"
    delete_on_termination = true
  }
}


resource "null_resource" "haproxy_packages" {

  connection {
    bastion_host = var.bastion_ip
    host = aws_instance.haproxy.private_ip
    agent = "true"
    type = "ssh"
    user = "centos"
    private_key = file(var.private_key)
    timeout = "10m"
  }

  provisioner "file" {

    content = templatefile("${path.module}/../templates/haproxy.cfg.tpl",
    {
      backend_ips = var.backend_ips
      openfaas_backend_port = var.openfaas_backend_port
      prometheus_backend_port = var.prometheus_backend_port
    }
    )
    destination = "/home/centos/haproxy.cfg"
  }


  provisioner "remote-exec" {
    inline = [
      "sudo yum install haproxy -y",
      "sudo systemctl enable haproxy",
      "yes | sudo cp -rf /home/centos/haproxy.cfg /etc/haproxy/",
      "sudo systemctl restart haproxy",
    ]
  }

  depends_on = [aws_instance.haproxy]
}