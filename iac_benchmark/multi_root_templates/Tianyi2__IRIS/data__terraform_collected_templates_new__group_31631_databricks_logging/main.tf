locals {
  init_script      = "${path.module}/appinsights_logging_init.sh"
  ai_core          = format("${path.module}/applicationinsights-core-%s.jar", var.ai_jar_version)
  ai_logging       = format("${path.module}/applicationinsights-logging-log4j1_2-%s.jar", var.ai_jar_version)
  dbfs_ai_core     = format("/databricks/appinsights/applicationinsights-core-%s.jar", var.ai_jar_version)
  dbfs_ai_logging  = format("/databricks/appinsights/applicationinsights-logging-log4j1_2-%s.jar", var.ai_jar_version)
  dbfs_init_script = "/databricks/appinsights/appinsights_logging_init.sh"
}

data "external" "download_ai_core" {
  program = ["pwsh", "${path.module}/pwsh/Download-File.ps1", path.module, local.ai_core, var.ai_jar_version]
}

data "external" "download_ai_logging" {
  program = ["pwsh", "${path.module}/pwsh/Download-File.ps1", path.module, local.ai_logging, var.ai_jar_version]
}

resource "databricks_dbfs_file" "ai_core" {
  source = lookup(data.external.download_ai_core.result, "library")
  path   = local.dbfs_ai_core

  depends_on = [
    data.external.download_ai_core
  ]
}

resource "databricks_dbfs_file" "ai_logging" {
  source = lookup(data.external.download_ai_logging.result, "library")
  path   = local.dbfs_ai_logging

  depends_on = [
    data.external.download_ai_logging
  ]
}

data "template_file" "databricks_init" {
  template = templatefile("${path.module}/appinsights_logging_init.tpl", {
    ai_key     = var.ai_key
    oms_id     = var.oms_id
    oms_key    = var.oms_key
    ai_version = var.ai_jar_version
  })
}

resource "local_file" "databricks_init" {
  content  = data.template_file.databricks_init.rendered
  filename = local.init_script
}

resource "databricks_dbfs_file" "dbfs_init_script" {
  source = local_file.databricks_init.filename
  path   = local.dbfs_init_script

  depends_on = [
    local_file.databricks_init,
    databricks_dbfs_file.ai_core,
    databricks_dbfs_file.ai_logging
  ]
}