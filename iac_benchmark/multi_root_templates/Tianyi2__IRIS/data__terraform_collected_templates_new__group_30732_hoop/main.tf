##
# (c) 2021-2025
#     Cloud Ops Works LLC - https://cloudops.works/
#     Find us on:
#       GitHub: https://github.com/cloudopsworks
#       WebSite: https://cloudops.works
#     Distributed Under Apache v2.0 License
#

resource "hoop_connection" "this" {
  name                 = var.name
  agent_id             = var.agent_id
  type                 = var.type
  subtype              = var.subtype
  secrets              = var.secrets
  access_mode_connect  = var.access_modes.connect
  access_mode_exec     = var.access_modes.exec
  access_mode_runbooks = var.access_modes.runbooks
  access_schema        = var.access_modes.schema
  tags                 = var.tags
  lifecycle {
    ignore_changes = [
      command,
    ]
  }
}

resource "hoop_plugin_connection" "this" {
  count         = length(try(var.access_control, [])) > 0 ? 1 : 0
  connection_id = hoop_connection.this.id
  plugin_name   = "access_control"
  config        = var.access_control
}