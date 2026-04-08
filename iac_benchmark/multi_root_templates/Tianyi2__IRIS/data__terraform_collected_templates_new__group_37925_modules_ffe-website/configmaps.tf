locals {
  security_contact_email = var.wp_security_contact_email != "" ? var.wp_security_contact_email : "security@${var.host}"
  security_signature_url = var.wp_security_txt_signature_url != "" ? var.wp_security_txt_signature_url : (var.wp_security_txt_sig != "" ? "https://${var.host}/security.txt.sig" : "")
  security_txt_content = var.wp_security_txt != "" ? var.wp_security_txt : format(
    "%s\n",
    join(
      "\n",
      compact([
        format("Contact: mailto:%s", local.security_contact_email),
        local.security_signature_url != "" ? format("Signature: %s", local.security_signature_url) : "",
      ])
    )
  )

  humans_txt_content = var.wp_humans_txt != "" ? var.wp_humans_txt : <<-EOT
    Team: Full Front-End
    Website: https://${var.host}
  EOT
}

resource "kubernetes_config_map" "apache_servername" {
  metadata {
    name      = "wordpress-apache-servername"
    namespace = kubernetes_namespace.wordpress.metadata[0].name
  }

  data = {
    "servername.conf" = "ServerName ${var.host}"
  }
}

resource "kubernetes_config_map" "php_uploads" {
  metadata {
    name      = "wordpress-php-uploads"
    namespace = kubernetes_namespace.wordpress.metadata[0].name
  }

  data = {
    "uploads.ini" = <<-EOT
      upload_max_filesize = 100M
      post_max_size = 100M
    EOT
  }
}

resource "kubernetes_config_map" "apache_webp_htaccess" {
  metadata {
    name      = "wordpress-apache-webp"
    namespace = kubernetes_namespace.wordpress.metadata[0].name
  }

  data = {
    "webp.conf" = <<-EOT
      <Directory /var/www/html>
        <IfModule mod_rewrite.c>
          RewriteEngine On
          RewriteCond %%{HTTP_ACCEPT} image/webp
          RewriteCond %%{REQUEST_FILENAME} (.*)\.(jpe?g|png|gif)$
          RewriteCond %%{REQUEST_FILENAME}\\.webp -f
          RewriteCond %%{QUERY_STRING} !type=original
          RewriteRule (.+)\\.(jpe?g|png|gif)$ %%{REQUEST_URI}.webp [T=image/webp,L]
        </IfModule>
        <IfModule mod_headers.c>
          <FilesMatch "\\.(jpe?g|png|gif)$">
            Header append Vary Accept
          </FilesMatch>
        </IfModule>
        AddType image/webp .webp
      </Directory>
    EOT
  }
}

resource "kubernetes_config_map" "apache_security" {
  metadata {
    name      = "wordpress-apache-security"
    namespace = kubernetes_namespace.wordpress.metadata[0].name
  }

  data = {
    "security.conf" = <<-EOT
      ServerSignature Off
      ServerTokens Prod

      <IfModule mod_headers.c>
        Header always setifempty X-Frame-Options "SAMEORIGIN"
        Header always set X-Content-Type-Options "nosniff"
        Header always set X-XSS-Protection "0"
        Header always set Referrer-Policy "strict-origin-when-cross-origin"
        Header always set Permissions-Policy "geolocation=(), microphone=(), camera=()"
        Header always set Strict-Transport-Security "max-age=${var.wp_hsts_max_age}; includeSubDomains${var.wp_hsts_preload ? "; preload" : ""}"
      </IfModule>
    EOT
  }
}

resource "kubernetes_config_map" "wordpress_text_files" {
  metadata {
    name      = "wordpress-text-files"
    namespace = kubernetes_namespace.wordpress.metadata[0].name
  }

  data = {
    "security.txt"     = local.security_txt_content
    "security.txt.sig" = var.wp_security_txt_sig
    "humans.txt"       = local.humans_txt_content
  }
}

resource "kubernetes_config_map" "wordpress_htaccess" {
  metadata {
    name      = "wordpress-htaccess"
    namespace = kubernetes_namespace.wordpress.metadata[0].name
  }

  data = {
    ".htaccess" = <<-EOT
      # BEGIN WordPress

      RewriteEngine On
      RewriteRule .* - [E=HTTP_AUTHORIZATION:%%{HTTP:Authorization}]
      RewriteBase /
      RewriteRule ^index\\.php$ - [L]
      RewriteCond %%{REQUEST_FILENAME} !-f
      RewriteCond %%{REQUEST_FILENAME} !-d
      RewriteRule . /index.php [L]

      # END WordPress

      Options -Indexes

      <Files wp-config.php>
        Require all denied
      </Files>

      # Begin AIOWPSEC Firewall
      <IfModule mod_php5.c>
        php_value auto_prepend_file '/var/www/html/aios-bootstrap.php'
      </IfModule>
      <IfModule mod_php7.c>
        php_value auto_prepend_file '/var/www/html/aios-bootstrap.php'
      </IfModule>
      <IfModule mod_php.c>
        php_value auto_prepend_file '/var/www/html/aios-bootstrap.php'
      </IfModule>
      # End AIOWPSEC Firewall
    EOT
  }
}
