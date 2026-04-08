resource "openstack_compute_instance_v2" "haproxy" {
  name              = "${var.env_name}-haproxy"
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


resource "null_resource" "haproxy_packages" {

  connection {
    bastion_host = var.bastion_ip
    host =              openstack_compute_instance_v2.haproxy.network.0.fixed_ip_v4
    agent               = "true"
    type                = "ssh"
    user                = "centos"
    private_key         = file(var.private_key)
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

  depends_on = [openstack_compute_instance_v2.haproxy]
}


