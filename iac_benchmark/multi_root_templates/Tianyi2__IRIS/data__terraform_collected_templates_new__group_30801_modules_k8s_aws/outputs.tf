output master-ips {
  value = aws_instance.master.*.private_ip
}

output worker-ips {
  value = aws_instance.worker.*.private_ip
}