resource "null_resource" "nomad_jobs" {
  connection {
    host                = module.nomad_servers.workers-fixed-ips[0]
    agent               = "true"
    type                = "ssh"
    user                = "centos"
    private_key         = file(var.private_key)
    bastion_host        = var.bastion_ip
    bastion_private_key = file(var.private_key)
  }

  provisioner "remote-exec" {
    inline = [
      "curl https://raw.githubusercontent.com/mabuaisha/faas-nomad/master/nomad_job_files/faas.hcl -o /home/centos/faas.hcl",
      "curl https://raw.githubusercontent.com/mabuaisha/faas-nomad/master/nomad_job_files/monitoring.hcl -o /home/centos/monitoring.hcl",
      "nomad run /home/centos/faas.hcl",
      "nomad run /home/centos/monitoring.hcl"
    ]
  }

  depends_on = [
    module.nomad_servers,
    module.nomad_clients,
  ]
}