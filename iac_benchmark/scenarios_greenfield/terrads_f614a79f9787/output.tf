output "ec2_private_dns" {
  value                 = aws_instance.test_instance.private_dns
}

output "ec2_instance_id" {
  value                 = aws_instance.test_instance.id
}

output "ec2_sg_id" {
  value                 = aws_security_group.ec2_sg.id
}

output "ec2_instance_profile_name" {
  value                 = aws_iam_instance_profile.ec2_instance_profile.name
}

output "vpc_id" {
  value                 = aws_vpc.vpc.id
}

output "subnet_id" {
  value                 = aws_subnet.priv_subnet.id
}
