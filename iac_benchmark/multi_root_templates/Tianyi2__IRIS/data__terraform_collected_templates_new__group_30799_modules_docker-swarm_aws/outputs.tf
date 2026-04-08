output manager-ips {
  value = aws_instance.manager.*.private_ip
}

output worker-ips {
  value = aws_instance.worker.*.private_ip
}

output "worker_token"{
  value = data.external.cluster_token.result.worker
}

output "manager_token"{
  value = data.external.cluster_token.result.manager
}

