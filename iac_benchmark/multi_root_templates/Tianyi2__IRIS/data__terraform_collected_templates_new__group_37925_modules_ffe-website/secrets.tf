resource "kubernetes_secret" "db" {
  metadata {
    name      = "wordpress-db"
    namespace = kubernetes_namespace.wordpress.metadata[0].name
  }

  data = {
    db_host     = var.db_host
    db_port     = tostring(var.db_port)
    db_name     = var.db_name
    db_user     = var.db_user
    db_password = var.db_password
  }
}

resource "kubernetes_secret" "dockerhub" {
  count = var.dockerhub_user != "" ? 1 : 0

  metadata {
    name      = "dockerhub-credentials"
    namespace = kubernetes_namespace.wordpress.metadata[0].name
  }

  type = "kubernetes.io/dockerconfigjson"

  data = {
    ".dockerconfigjson" = jsonencode({
      auths = {
        "https://index.docker.io/v1/" = {
          username = var.dockerhub_user
          password = var.dockerhub_pat
          email    = var.dockerhub_email
          auth     = base64encode("${var.dockerhub_user}:${var.dockerhub_pat}")
        }
      }
    })
  }
}
