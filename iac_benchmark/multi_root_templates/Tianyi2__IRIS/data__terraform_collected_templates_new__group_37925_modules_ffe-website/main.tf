/*
    Extra config injected into wp-config.php via WORDPRESS_CONFIG_EXTRA
    (AS3CF + WP Mail SMTP + langue).
*/
locals {
  wordpress_config_extra = <<-EOT
    define('AS3CF_SETTINGS', serialize([
        'provider'          => '${var.as3_provider}',
        'access-key-id'     => '${var.as3_access_key}',
        'secret-access-key' => '${var.as3_secret_key}',
    ]));

    define('WP_CACHE', ${var.wp_cache});

    define('WPMS_ON', ${var.wpms_on});
    define('WPMS_MAIL_FROM', '${var.mail_from}');
    define('WPMS_MAIL_FROM_FORCE', true);
    define('WPMS_MAIL_FROM_NAME', '${var.mail_from_name}');
    define('WPMS_MAIL_FROM_NAME_FORCE', true);
    define('WPMS_SET_RETURN_PATH', true);
    define('WPMS_SMTP_HOST', '${var.smtp_host}');
    define('WPMS_SMTP_PORT', '${var.smtp_port}');
    define('WPMS_SSL', '${var.smtp_ssl}');
    define('WPMS_SMTP_AUTH', ${var.smtp_auth});
    define('WPMS_SMTP_USER', '${var.smtp_user}');
    define('WPMS_SMTP_PASS', '${var.smtp_pass}');
    define('WPMS_SMTP_AUTOTLS', false);
    define('WPMS_MAILER', 'smtp');

    // Begin AIOWPSEC Firewall
    if (file_exists('/var/www/html/aios-bootstrap.php')) {
        include_once('/var/www/html/aios-bootstrap.php');
    }
    // End AIOWPSEC Firewall

    define('WPCACHEHOME', '/var/www/html/wp-content/plugins/wp-super-cache/');

    define('WPLANG', '${var.wp_lang}');
  EOT
}

resource "kubernetes_deployment" "wordpress" {
  metadata {
    name      = "wordpress"
    namespace = kubernetes_namespace.wordpress.metadata[0].name
    labels = {
      app = "ffe-website"
    }
  }

  lifecycle {
    precondition {
      condition     = var.replicas == 1
      error_message = "WordPress uses a ReadWriteOnce PVC; replicas must stay at 1 (otherwise volume multi-attach will break)."
    }
  }

  /*
      Vanilla WordPress deployment:
      - external MariaDB
      - PVC for wp-content
  */
  spec {
    replicas = var.replicas
    strategy {
      type = "Recreate"
    }

    selector {
      match_labels = {
        app = "ffe-website"
      }
    }

    template {
      metadata {
        labels = {
          app = "ffe-website"
        }
      }

      spec {
        container {
          name    = "wordpress"
          image   = var.image
          command = ["bash", "-c"]
          args    = ["a2enmod headers >/dev/null 2>&1 || true; apache2-foreground"]

          port {
            name           = "http"
            container_port = 80
          }

          resources {
            requests = {
              cpu = "250m"
            }
            limits = {
              cpu    = "500m"
              memory = "512Mi"
            }
          }

          env {
            name = "WORDPRESS_DB_HOST"
            value_from {
              secret_key_ref {
                name = kubernetes_secret.db.metadata[0].name
                key  = "db_host"
              }
            }
          }
          env {
            name = "WORDPRESS_DB_PORT"
            value_from {
              secret_key_ref {
                name = kubernetes_secret.db.metadata[0].name
                key  = "db_port"
              }
            }
          }
          env {
            name = "WORDPRESS_DB_NAME"
            value_from {
              secret_key_ref {
                name = kubernetes_secret.db.metadata[0].name
                key  = "db_name"
              }
            }
          }
          env {
            name = "WORDPRESS_DB_USER"
            value_from {
              secret_key_ref {
                name = kubernetes_secret.db.metadata[0].name
                key  = "db_user"
              }
            }
          }
          env {
            name = "WORDPRESS_DB_PASSWORD"
            value_from {
              secret_key_ref {
                name = kubernetes_secret.db.metadata[0].name
                key  = "db_password"
              }
            }
          }
          env {
            name  = "WORDPRESS_CONFIG_EXTRA"
            value = local.wordpress_config_extra
          }

          volume_mount {
            name       = "wordpress-content"
            mount_path = "/var/www/html"
          }

          volume_mount {
            name       = "apache-servername"
            mount_path = "/etc/apache2/conf-enabled/servername.conf"
            sub_path   = "servername.conf"
            read_only  = true
          }

          volume_mount {
            name       = "apache-webp"
            mount_path = "/etc/apache2/conf-enabled/webp.conf"
            sub_path   = "webp.conf"
            read_only  = true
          }

          volume_mount {
            name       = "apache-security"
            mount_path = "/etc/apache2/conf-enabled/security.conf"
            sub_path   = "security.conf"
            read_only  = true
          }

          volume_mount {
            name       = "php-uploads"
            mount_path = "/usr/local/etc/php/conf.d/uploads.ini"
            sub_path   = "uploads.ini"
            read_only  = true
          }

          volume_mount {
            name       = "wordpress-htaccess"
            mount_path = "/var/www/html/.htaccess"
            sub_path   = ".htaccess"
            read_only  = true
          }

          volume_mount {
            name       = "wordpress-text-files"
            mount_path = "/var/www/html/security.txt"
            sub_path   = "security.txt"
            read_only  = true
          }

          volume_mount {
            name       = "wordpress-text-files"
            mount_path = "/var/www/html/security.txt.sig"
            sub_path   = "security.txt.sig"
            read_only  = true
          }

          volume_mount {
            name       = "wordpress-text-files"
            mount_path = "/var/www/html/humans.txt"
            sub_path   = "humans.txt"
            read_only  = true
          }
        }

        volume {
          name = "wordpress-content"

          persistent_volume_claim {
            claim_name = kubernetes_persistent_volume_claim.wp_content.metadata[0].name
          }
        }

        volume {
          name = "apache-servername"

          config_map {
            name = kubernetes_config_map.apache_servername.metadata[0].name
          }
        }

        volume {
          name = "apache-webp"

          config_map {
            name = kubernetes_config_map.apache_webp_htaccess.metadata[0].name
          }
        }

        volume {
          name = "apache-security"

          config_map {
            name = kubernetes_config_map.apache_security.metadata[0].name
          }
        }

        volume {
          name = "php-uploads"

          config_map {
            name = kubernetes_config_map.php_uploads.metadata[0].name
          }
        }

        volume {
          name = "wordpress-htaccess"

          config_map {
            name = kubernetes_config_map.wordpress_htaccess.metadata[0].name
          }
        }

        volume {
          name = "wordpress-text-files"

          config_map {
            name = kubernetes_config_map.wordpress_text_files.metadata[0].name
          }
        }

        dynamic "image_pull_secrets" {
          for_each = var.dockerhub_user != "" ? [1] : []
          content {
            name = kubernetes_secret.dockerhub[0].metadata[0].name
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "wordpress" {
  metadata {
    name      = "wordpress"
    namespace = kubernetes_namespace.wordpress.metadata[0].name
    labels = {
      app = "ffe-website"
    }
  }

  spec {
    selector = {
      app = "ffe-website"
    }

    port {
      name        = "http"
      port        = 80
      target_port = 80
    }
  }
}
