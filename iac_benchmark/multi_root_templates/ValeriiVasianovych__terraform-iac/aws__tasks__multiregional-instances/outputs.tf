output "public_ip_addresse_1" {
  value = aws_instance.instance-1.public_ip
}

output "public_ip_addresse_2" {
  value = aws_instance.instance-2.public_ip
}