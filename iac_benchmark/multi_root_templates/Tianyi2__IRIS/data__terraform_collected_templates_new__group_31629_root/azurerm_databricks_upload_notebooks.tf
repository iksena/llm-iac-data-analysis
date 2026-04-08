locals {
  python_notebook                 = "${path.module}/notebooks/logging_python.py"
  scala_notebook                  = "${path.module}/notebooks/logging_scala.scala"
  adf_calling_databricks_notebook = "${path.module}/notebooks/adf_calling_databricks.py"
}

data "local_file" "logging_python" {
  filename = local.python_notebook
}

resource "databricks_notebook" "logging_python" {
  source   = data.local_file.logging_python.content_base64
  path     = "/Shared/logging_python"
  language = "PYTHON"

  depends_on = [
    azurerm_databricks_workspace.databricks
  ]
}

data "local_file" "logging_scala" {
  filename = local.scala_notebook
}

resource "databricks_notebook" "logging_scala" {
  source   = data.local_file.logging_scala.content_base64
  path     = "/Shared/logging_scala"
  language = "SCALA"

  depends_on = [
    azurerm_databricks_workspace.databricks
  ]
}

data "local_file" "adf_calling_databricks" {
  filename = local.adf_calling_databricks_notebook
}

resource "databricks_notebook" "adf_calling_databricks" {
  source   = data.local_file.adf_calling_databricks.content_base64
  path     = "/Shared/adf_calling_databricks"
  language = "PYTHON"

  depends_on = [
    azurerm_databricks_workspace.databricks
  ]
}
