output "out_adx_cluster_name" {
  value = azurerm_kusto_cluster.kusto.name
}

output "out_adx_cluster_uri" {
  value = azurerm_kusto_cluster.kusto.uri
}

output "out_adx_cluster_ingestion_uri" {
  value = azurerm_kusto_cluster.kusto.data_ingestion_uri
}

output "out_adx_cluster_principal_id" {
  value = azurerm_kusto_cluster.kusto.identity.0.principal_id
}