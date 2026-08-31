output "vpc_id" {
  value = aws_vpc.my_vpc.id
}

output "subnet_public_bastion_a_id" {
  value = aws_subnet.public_bastion_a.id
}

output "subnet_public_bastion_b_id" {
  value = aws_subnet.public_bastion_b.id
}

output "subnet_private_web_a_id" {
  value = aws_subnet.private_web_a.id
}

output "subnet_private_web_b_id" {
  value = aws_subnet.private_web_b.id
}

output "subnet_private_redis_a_id" {
  value = aws_subnet.private_redis_a.id
}

output "subnet_private_redis_b_id" {
  value = aws_subnet.private_redis_b.id
}

output "sg_bastion_id" {
  value = aws_security_group.bastion.id
}

output "sg_database_id" {
  value = aws_security_group.database.id
}

output "sg_webserver_id" {
  value = aws_security_group.webserver.id
}

output "aws_eip_bastion_id" {
  value = aws_eip.bastion.id
}

output "alb_target_group_web_arn" {
  value = aws_lb_target_group.web.arn
}

output "iam_instance_profile_name" {
  value = aws_iam_instance_profile.profile.name
}

output "ssh_key" {
  value = aws_key_pair.deployer.key_name
}
