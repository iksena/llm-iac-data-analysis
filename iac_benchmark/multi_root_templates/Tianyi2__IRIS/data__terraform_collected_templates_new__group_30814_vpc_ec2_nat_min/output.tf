
output "private_ip" {
  description = "Private ip"
  value       = aws_instance.private.private_ip
}

output "nat_ip" {
  description = "NAT ip"
  value       = aws_instance.ec2_nat.private_ip
}

output "ssh_private" {
  description = "ssh to private instance"
  value       = "ssh -o'UserKnownHostsFile=/dev/null' -o 'StrictHostKeyChecking=no' -J ubuntu@${aws_instance.ec2_nat.public_ip} ubuntu@${aws_instance.private.private_ip}"
}

output "ssh_nat" {
  description = "ssh to NAT instance"
  value       = "ssh -o'UserKnownHostsFile=/dev/null' -o 'StrictHostKeyChecking=no' ubuntu@${aws_instance.ec2_nat.public_ip}"
}
