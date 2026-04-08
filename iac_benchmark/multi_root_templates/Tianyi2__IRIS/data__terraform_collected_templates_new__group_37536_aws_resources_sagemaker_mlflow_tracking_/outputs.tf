output "arn" {
  description = "The Amazon Resource Name (ARN) assigned by AWS to this MLFlow Tracking Server."
  value       = aws_sagemaker_mlflow_tracking_server.this.arn
}

output "id" {
  description = "The name of the MLFlow Tracking Server."
  value       = aws_sagemaker_mlflow_tracking_server.this.id
}

output "tracking_server_url" {
  description = "The URL to connect to the MLflow user interface for the described tracking server."
  value       = aws_sagemaker_mlflow_tracking_server.this.tracking_server_url
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_sagemaker_mlflow_tracking_server.this.tags_all
}