locals {
  pg_user_esc = urlencode(var.db_user)
  pg_pass_esc = urlencode(var.db_password)
  pg_url = format(
    "postgres://%s:%s@%s:%d/%s",
    local.pg_user_esc,
    local.pg_pass_esc,
    var.db_host,
    var.db_port,
    var.db_name
  )
}

resource "kubernetes_secret" "twenty_env" {
  metadata {
    name      = "twenty-env"
    namespace = kubernetes_namespace.twenty.metadata[0].name
  }

  data = {
    PG_DATABASE_URL = local.pg_url
    APP_SECRET      = var.app_secret
    DB_HOST         = var.db_host
    DB_PORT         = tostring(var.db_port)
    DB_NAME         = var.db_name
    DB_USER         = var.db_user
    DB_PASSWORD     = var.db_password
  }
}
