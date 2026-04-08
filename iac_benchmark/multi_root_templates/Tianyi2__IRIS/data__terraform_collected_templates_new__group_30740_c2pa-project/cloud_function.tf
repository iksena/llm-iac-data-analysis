# cloud_function.tf

# -----------------------------------------------------------------------------
# 1. Service Accounts & IAM Setup
# -----------------------------------------------------------------------------

# Get the Google-managed service account for GCS (to publish notifications)
data "google_storage_project_service_account" "gcs_account" {
  project = var.project_id
}

# Create the dedicated Service Account for the Function Runtime
resource "google_service_account" "function_sa" {
  account_id   = "c2pa-signer-sa"
  display_name = "C2PA Signer Service Account"
  project      = var.project_id
}

# Grant Runtime Permissions (KMS, Secret Manager, Storage, etc.)
resource "google_project_iam_member" "function_permissions" {
  for_each = toset([
    "roles/cloudkms.signerVerifier",
    "roles/privateca.certificateManager",
    "roles/storage.objectAdmin",
    "roles/secretmanager.secretAccessor",
    "roles/artifactregistry.reader",
    "roles/logging.logWriter",
    "roles/eventarc.eventReceiver",
    "roles/run.invoker" 
  ])
  project = var.project_id
  role    = each.key
  member  = "serviceAccount:${google_service_account.function_sa.email}"
}
# Required for Eventarc to invoke authenticated Cloud Run services
resource "google_project_iam_member" "pubsub_token_creator" {
  project = var.project_id
  role    = "roles/iam.serviceAccountTokenCreator"
  member  = "serviceAccount:service-${data.google_project.project.number}@gcp-sa-pubsub.iam.gserviceaccount.com"
}

resource "google_project_iam_member" "gcs_pubsub_publisher" {
  project = var.project_id
  role    = "roles/pubsub.publisher"
  member  = "serviceAccount:${data.google_storage_project_service_account.gcs_account.email_address}"
}

# -----------------------------------------------------------------------------
# 2. Build System Permissions
# -----------------------------------------------------------------------------

# NOTE: Gen 2 uses Cloud Build. We grant the default Compute Service Account 
# (often used by Cloud Build) access to read the source code bucket.
resource "google_storage_bucket_iam_member" "build_source_reader" {
  for_each = toset(var.regions)
  bucket = google_storage_bucket.uploads[each.key].name
  role   = "roles/storage.objectViewer"
  member = "serviceAccount:${data.google_project.project.number}-compute@developer.gserviceaccount.com"
}

resource "google_project_iam_member" "cloud_build_permissions" {
  project = var.project_id
  role    = "roles/cloudbuild.builds.builder"
  member  = "serviceAccount:${data.google_project.project.number}-compute@developer.gserviceaccount.com"
}

# -----------------------------------------------------------------------------
# 3. Function Source & Deployment (Gen 2)
# -----------------------------------------------------------------------------

data "archive_file" "source" {
  type        = "zip"
  source_dir  = "${path.module}/function_source"
  output_path = "/tmp/function_source.zip"

  # Exclude temporary files that change automatically and alter the zip hash
  excludes = [
    "__pycache__",
    "*.pyc",
    ".DS_Store",
    ".git",
    ".gitignore",
    ".venv",
    "venv",
    ".terraform",
    "terraform.tfstate",
    "terraform.tfstate.backup"
  ]
}


resource "google_storage_bucket_object" "function_archive" {
  for_each = toset(var.regions)
  name   = "function_source.zip" 
  bucket = google_storage_bucket.uploads[each.key].name
  source = data.archive_file.source.output_path
}

resource "google_cloudfunctions2_function" "c2pa_signer" {
  for_each = toset(var.regions)

  name        = "c2pa-signer-function-${each.key}"
  location    = each.key
  description = "C2PA signing function triggered by GCS uploads via Pub/Sub (Gen 2)."

  labels = {
    deployment-checksum = data.archive_file.source.output_md5
  }

  build_config {
    runtime     = "python311" # Recommended to stick to 3.11 for broader C2PA compatibility/stability
    entry_point = "c2pa_sign_pubsub"
    source {
      storage_source {
        bucket = google_storage_bucket.uploads[each.key].name
        object = google_storage_bucket_object.function_archive[each.key].name
      }
    }
  }

  service_config {
    max_instance_count    = 10
    # Increased memory and timeout for image processing resilience
    available_memory      = "1Gi"
    timeout_seconds       = 300 
    service_account_email = google_service_account.function_sa.email
    
    environment_variables = {
      PROJECT_ID                = var.project_id
      SIGNED_BUCKET_NAME        = google_storage_bucket.signed.name
      # TODO: Currently appending version explicitly to avoid runtime resolution (due to bug in crypto_key provider)
      KMS_KEY_ID                = "${google_kms_crypto_key.signing_key[each.key].id}/cryptoKeyVersions/1"
      CA_POOL_ID                = google_privateca_ca_pool.pool[each.key].id
      AUTHOR_NAME_SECRET_ID     = google_secret_manager_secret.author_name_secret.secret_id
      CLAIM_GENERATOR_SECRET_ID = google_secret_manager_secret.claim_generator_secret.secret_id
      # Fix: to prevent re-deploying function even when it hasn't changed
      LOG_EXECUTION_ID          = "true"
    }
  }

  event_trigger {
    trigger_region = each.key 
    event_type     = "google.cloud.storage.object.v1.finalized"
    retry_policy   = "RETRY_POLICY_RETRY" # safe because Python code handles permanent errors
    service_account_email = google_service_account.function_sa.email
    event_filters {
      attribute = "bucket"
      value     = google_storage_bucket.uploads[each.key].name
    }
  }

  lifecycle {
    ignore_changes = [
      # Fix: to prevent re-deploying function even when it hasn't changed
      # GCF automatically assigns a docker repository. Stop Terraform from fighting it.
      build_config[0].docker_repository
    ]
  }

  depends_on = [
    google_project_iam_member.function_permissions,
    google_project_iam_member.gcs_pubsub_publisher,
    google_project_iam_member.cloud_build_permissions,
    google_project_iam_member.pubsub_token_creator
  ]
}
