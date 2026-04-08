locals {
  databases = {
    vengeful_prod    = { role = data.doppler_secrets.rds.map.VENGEFUL_PROD_ROLE, password = sensitive(data.doppler_secrets.rds.map.VENGEFUL_PROD_PASSWORD) }
    vengeful_staging = { role = data.doppler_secrets.rds.map.VENGEFUL_STAGING_ROLE, password = sensitive(data.doppler_secrets.rds.map.VENGEFUL_STAGING_PASSWORD) }
    monoweb_prod     = { role = data.doppler_secrets.rds.map.MONOWEB_PROD_ROLE, password = sensitive(data.doppler_secrets.rds.map.MONOWEB_PROD_PASSWORD) }
    monoweb_staging  = { role = data.doppler_secrets.rds.map.MONOWEB_STAGING_ROLE, password = sensitive(data.doppler_secrets.rds.map.MONOWEB_STAGING_PASSWORD) }
    grades_prod      = { role = data.doppler_secrets.rds.map.GRADES_PROD_ROLE, password = sensitive(data.doppler_secrets.rds.map.GRADES_PROD_PASSWORD) }
    grades_staging   = { role = data.doppler_secrets.rds.map.GRADES_STAGING_ROLE, password = sensitive(data.doppler_secrets.rds.map.GRADES_STAGING_PASSWORD) }
  }
}

resource "postgresql_role" "roles" {
  for_each = local.databases
  provider = postgresql

  name     = each.value.role
  login    = true
  password = each.value.password
}

resource "postgresql_database" "databases" {
  for_each = local.databases
  provider = postgresql

  name     = each.key
  owner    = each.value.role
  template = "template0"
}
