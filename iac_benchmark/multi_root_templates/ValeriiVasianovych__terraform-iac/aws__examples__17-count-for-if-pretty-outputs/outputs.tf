output "created_users_all" {
  description = "List of all created IAM users as resources"
  value       = aws_iam_user.users
}

output "created_users_all_ids" {
  description = "List of IDs of all created IAM users"
  value       = [for user in aws_iam_user.users : user.id]
}

output "created_users_all_custom" {
  description = "Custom details for all created IAM users"
  value = [
    for user in aws_iam_user.users :
    "Username: ${user.name} with ARN: ${user.arn}"
  ]
}

output "created_users_map" {
  description = "Mapping of unique IDs to IAM user IDs"
  value = {
    for user in aws_iam_user.users :
    user.unique_id => user.id
  }
}

# print all users with length 4 
output "selected_users" {
  description = "Custom if for users"
  value = [
    for x in aws_iam_user.users :
    x.name
    if length(x.name) == 4
  ]
}

output "ec2_info" {
  value = [for instance in aws_instance.ubuntu_instance : instance.id]
}

output "ec2_id_ip" {
  value = {
    for server in aws_instance.ubuntu_instance :
    server.id => server.public_ip
  }
}