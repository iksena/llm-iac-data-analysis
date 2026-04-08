resource "aws_sagemaker_mlflow_tracking_server" "this" {
  region                          = var.region
  artifact_store_uri              = var.artifact_store_uri
  role_arn                        = var.role_arn
  tracking_server_name            = var.tracking_server_name
  mlflow_version                  = var.mlflow_version
  automatic_model_registration    = var.automatic_model_registration
  tracking_server_size            = var.tracking_server_size
  weekly_maintenance_window_start = var.weekly_maintenance_window_start
  tags                            = var.tags
}