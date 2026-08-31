output "alb_dns_name" {
  description = "ALB public dns name"
  value       = aws_lb.main.dns_name
}

output "aws_region" {
  description = "AWS region"
  value       = var.aws_region
}

output "github_actions_role_arn" {
  description = "Role ARN for GitHub Actions"
  value       = aws_iam_role.github_actions.arn
}

output "ecs_cluster_name" {
  description = "ECS clusster name"
  value       = aws_ecs_cluster.main.name
}
