output "get_public_ip" {
  value = aws_instance.ubuntu_ec2[*].public_ip
}

output "lookup_example" {
  value = lookup({a="ay", b="bee"}, "c", "what?")
}