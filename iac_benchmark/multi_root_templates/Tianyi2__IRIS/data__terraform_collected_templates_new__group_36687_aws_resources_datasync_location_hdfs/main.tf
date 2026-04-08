resource "aws_datasync_location_hdfs" "this" {
  agent_arns          = var.agent_arns
  authentication_type = var.authentication_type

  block_size                = var.block_size
  kerberos_keytab           = var.kerberos_keytab
  kerberos_keytab_base64    = var.kerberos_keytab_base64
  kerberos_krb5_conf        = var.kerberos_krb5_conf
  kerberos_krb5_conf_base64 = var.kerberos_krb5_conf_base64
  kerberos_principal        = var.kerberos_principal
  kms_key_provider_uri      = var.kms_key_provider_uri
  replication_factor        = var.replication_factor
  simple_user               = var.simple_user
  subdirectory              = var.subdirectory
  tags                      = var.tags

  name_node {
    hostname = var.name_node.hostname
    port     = var.name_node.port
  }

  dynamic "qop_configuration" {
    for_each = var.qop_configuration != null ? [var.qop_configuration] : []
    content {
      data_transfer_protection = qop_configuration.value.data_transfer_protection
      rpc_protection           = qop_configuration.value.rpc_protection
    }
  }
}