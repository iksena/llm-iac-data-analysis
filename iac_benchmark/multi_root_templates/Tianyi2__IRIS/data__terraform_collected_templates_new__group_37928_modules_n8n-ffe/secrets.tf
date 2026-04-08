resource "kubernetes_secret" "n8n_external_postgres" {

  metadata {
    name      = "n8n-external-postgres"
    namespace = kubernetes_namespace.n8n.metadata[0].name
  }

  data = {
    # Chart expects key `postgres-password` for DB env injection
    "postgres-password" = var.db_password
  }
}
