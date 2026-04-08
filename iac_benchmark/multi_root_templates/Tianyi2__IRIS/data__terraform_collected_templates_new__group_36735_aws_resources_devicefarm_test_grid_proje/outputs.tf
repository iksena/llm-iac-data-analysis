output "arn" {
  description = "The Amazon Resource Name of this Test Grid Project."
  value       = aws_devicefarm_test_grid_project.this.arn
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_devicefarm_test_grid_project.this.tags_all
}