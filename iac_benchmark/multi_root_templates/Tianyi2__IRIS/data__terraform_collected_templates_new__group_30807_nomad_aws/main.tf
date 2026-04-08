module "nomad_servers" {
  source = "../../modules/nomad/aws"
  agent_type = "server"
  private_key = var.private_key
  bastion_ip = var.bastion_ip
  worker_count = var.servers_count
  worker_name = var.worker_name
  image_id = var.image_id
  instance_type = var.instance_type
  subnet_id = var.subnet_id
  volume_size = var.volume_size
  security_group_ids = var.security_group_ids
}

module "nomad_clients" {
  source = "../../modules/nomad/aws"
  agent_type = "client"
  private_key = var.private_key
  bastion_ip = var.bastion_ip
  consul_hosts = module.nomad_servers.workers-fixed-ips
  worker_count = var.clients_count
  worker_name = var.worker_name
  image_id = var.image_id
  instance_type = var.instance_type
  subnet_id = var.subnet_id
  volume_size = var.volume_size
  docker_username = var.docker_username
  docker_password = var.docker_password
  security_group_ids = var.security_group_ids
}
