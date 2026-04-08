output manager-ips {
  value = openstack_compute_instance_v2.manager.*.network.0.fixed_ip_v4
}

output worker-ips {
  value = openstack_compute_instance_v2.worker.*.network.0.fixed_ip_v4
}

output "worker_token"{
  value = data.external.cluster_token.result.worker
}

output "manager_token"{
  value = data.external.cluster_token.result.manager
}

