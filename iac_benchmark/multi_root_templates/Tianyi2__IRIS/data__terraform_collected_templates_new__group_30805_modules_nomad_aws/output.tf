output workers-fixed-ips {
  value = aws_instance.server.*.private_ip
}

