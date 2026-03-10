# ── main.tf ────────────────────────────────────
terraform {
  backend "gcs" {
    prefix = "terraform/state"
    bucket = "terraform-larkworthy-camunda" // Must be pre-provisioned
  }
}

provider "google" {
  project = "larkworthy-tester"
  region  = "europe-west1"
}

locals {
  project = "larkworthy-tester"
  config = {
    project         = local.project
    base_image_name = "camunda/camunda-bpm-platform"
    base_image_tag  = "7.12.0"
    region          = "europe-west1"
  }
}


# ── build.tf ────────────────────────────────────
# Copy Camunda base image from Dockerhub image into Google Container Registry
module "docker-mirror-camunda-bpm-platform" {
  source      = "github.com/neomantra/terraform-docker-mirror"
  image_name  = local.config.base_image_name
  image_tag   = local.config.base_image_tag
  dest_prefix = "eu.gcr.io/${local.project}"
}

# Hydrate docker template file into .build directory
resource "local_file" "dockerfile" {
  content = templatefile("${path.module}/Dockerfile.template", {
    project = local.project
    image   = local.config.base_image_name
    tag     = local.config.base_image_tag
  })
  filename = "${path.module}/.build/Dockerfile"
}

# Hydrate bpm-platform config into .build directory
resource "local_file" "bpm-platform" {
  content = templatefile("${path.module}/config/bpm-platform.xml.template", {
    maxJobsPerAcquisition = null
    lockTimeInMillis = null
    waitTimeInMillis = 1
    maxWait = null
    history = "none"
    databaseSchemaUpdate = null # default
    authorizationEnabled = null # default
    jobExecutorDeploymentAware = "false"
    historyCleanupBatchWindowStartTime = null # default
  })
  filename = "${path.module}/.build/bpm-platform.xml"
}

# Build a customized image of Camunda to include the cloud sql postgres socket factory library
# Required to connect to Cloud SQL
# Built using Cloud Build, image stored in GCR
resource "null_resource" "camunda_cloudsql_image" {
  depends_on = [module.docker-mirror-camunda-bpm-platform]
  triggers = {
    # Rebuild if we change the base image, dockerfile, or bpm-platform config
    image = "eu.gcr.io/${local.project}/camunda_cloudsql:${local.config.base_image_tag}_${
      sha1(
        "${sha1(local_file.dockerfile.content)}${sha1(local_file.bpm-platform.content)}"
      )  
    }"
  }
  provisioner "local-exec" {
    command = <<-EOT
        gcloud builds submit \
        --project ${local.project} \
        --tag ${self.triggers.image} \
        ${path.module}/.build
    EOT
  }
}


# ── camunda.tf ────────────────────────────────────

# Policy to allow public access to Cloud Run endpoint
data "google_iam_policy" "noauth" {
  binding {
    role    = "roles/run.invoker"
    members = ["allUsers"]
  }
}

# Bind public policy to our Camunda Cloud Run service
resource "google_cloud_run_service_iam_policy" "noauth" {
  location    = google_cloud_run_service.camunda.location
  project     = google_cloud_run_service.camunda.project
  service     = google_cloud_run_service.camunda.name
  policy_data = data.google_iam_policy.noauth.policy_data
}

# Create service account to run service
resource "google_service_account" "camunda" {
  account_id   = "camunda-worker"
  display_name = "Camunda Worker"
}

# Give the service account access to Cloud SQL
resource "google_project_iam_member" "project" {
  role   = "roles/cloudsql.client"
  member = "serviceAccount:${google_service_account.camunda.email}"
}

# Cloud Run Camunda service
resource "google_cloud_run_service" "camunda" {
  name     = "camunda"
  location = local.config.region
  template {
    spec {
      # Use locked down Service Account
      service_account_name = google_service_account.camunda.email
      containers {
        image = null_resource.camunda_cloudsql_image.triggers.image
        resources {
          limits = {
            # Default of 256Mb is not enough to start Camunda 
            memory = "2Gi"
            cpu    = "1000m"
          }
        }
        env {
          name = "DB_URL"
          # Complicated DB URL to Cloud SQL
          # See https://github.com/GoogleCloudPlatform/cloud-sql-jdbc-socket-factory
          value = "jdbc:postgresql:///${google_sql_database.database.name}?cloudSqlInstance=${google_sql_database_instance.camunda-db.connection_name}&socketFactory=com.google.cloud.sql.postgres.SocketFactory"
        }

        env {
          name  = "DB_DRIVER"
          value = "org.postgresql.Driver"
        }
        env {
          name  = "DB_USERNAME"
          value = google_sql_user.user.name
        }
        env {
          name  = "DB_PASSWORD"
          value = google_sql_user.user.password
        }
        # Test instance of Cloud SQL has low connection limit
        # So we turn down the connection pool size
        env {
          name  = "DB_CONN_MAXACTIVE"
          value = "5"
        }
        env {
          name  = "DB_CONN_MAXIDLE"
          value = "5"
        }
        env {
          name  = "DB_CONN_MINIDLE"
          value = "0"
        }
        env {
          name  = "DB_VALIDATE_ON_BORROW"
          value = "true"
        }
      }
    }

    metadata {
      annotations = {
        "autoscaling.knative.dev/maxScale"      = "1" # no clusting
        "run.googleapis.com/cloudsql-instances" = google_sql_database_instance.camunda-db.connection_name
      }
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }
}


# ── cloudsql.tf ────────────────────────────────────
resource "google_sql_database_instance" "camunda-db" {
  name             = "camunda-db-postgres"
  database_version = "POSTGRES_11"
  region           = local.config.region

  settings {
    # Very small instance for testing.
    tier = "db-f1-micro"
    ip_configuration {
        ipv4_enabled = true
    }
  }
}

resource "google_sql_user" "user" {
  name     = "camunda"
  instance = google_sql_database_instance.camunda-db.name
  password = "futurice"
}

resource "google_sql_database" "database" {
  name     = "camunda"
  instance = google_sql_database_instance.camunda-db.name
}
