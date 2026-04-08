output "id" {
  description = "The name of the GameLift Game Server Group."
  value       = aws_gamelift_game_server_group.this.id
}

output "arn" {
  description = "The ARN of the GameLift Game Server Group."
  value       = aws_gamelift_game_server_group.this.arn
}

output "auto_scaling_group_arn" {
  description = "The ARN of the created EC2 Auto Scaling group."
  value       = aws_gamelift_game_server_group.this.auto_scaling_group_arn
}