# All modules, and all postgresql resources within these modules, have dependencies between them
# This is because Postgres itself does not allow multiple concurrent edits for certain
#   types of permissions information, and the postgresql provider does not contain
#   sufficient serialization mechanisms.
# To protect against "pq: tuple concurrently updated" errors, we serialize any operations that
#   may potentially update permissions
# Reference: https://github.com/cyrilgdn/terraform-provider-postgresql/issues/178

module "database" {
  source = "./database"
}

module "admin_role" {
  depends_on = [ module.database ]
  source = "./admin-role"

  project_id = var.project_id
  database_instance_name = var.database_instance_name
  database_name = module.database.database_name
  schema_name = module.database.schema_name
}

module "read_write_role" {
  depends_on = [ module.database ]
  source = "./read-write-role"

  project_id = var.project_id
  database_instance_name = var.database_instance_name
  database_name = module.database.database_name
  schema_name = module.database.schema_name
}

module "iam_admin" {
  depends_on = [ module.admin_role ]
  source = "./iam-admin"

  project_id = var.project_id
  database_instance_name = var.database_instance_name
  database_name = module.database.database_name
  schema_name = module.database.schema_name
}

