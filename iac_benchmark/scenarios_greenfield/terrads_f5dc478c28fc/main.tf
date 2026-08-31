locals {
  name = "${var.name}-${var.environment_name}"
  path = var.workspace_name != "" ? "/${var.environment_name}/${var.workspace_name}/" : "/${var.environment_name}/"
}
