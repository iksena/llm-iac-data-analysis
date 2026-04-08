resource "aws_sagemaker_human_task_ui" "this" {
  region             = var.region
  human_task_ui_name = var.human_task_ui_name
  tags               = var.tags

  ui_template {
    content = var.ui_template_content
  }
}