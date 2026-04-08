output "cluster_init_script" {
  value = databricks_dbfs_file.dbfs_init_script.id
}