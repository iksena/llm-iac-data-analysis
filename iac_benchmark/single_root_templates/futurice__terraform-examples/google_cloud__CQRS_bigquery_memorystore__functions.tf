# ── variables.tf ────────────────────────────────────
variable "config" {
  type = any
}

variable "prober_ingress_table" {
  type = any
}

variable "control_dataset" {
  type = any
}

variable "unified_values_table" {
  type = any
}

variable "current_totals_latest_table" {
  type = any
}

variable "historical_totals_latest_table" {
  type = any
}

variable "current_totals_table" {
  type = any
}

variable "historical_totals_table" {
  type = any
}

variable "memorystore_host" {
  type = any
}


# ── function_memorystoreloader.tf ────────────────────────────────────
locals {
  memorystoreloader_function_name = "memorystoreload"
}

resource "google_cloudfunctions_function" "memorystoreloader" {
  name    = "memorystoreloader"
  runtime = "nodejs10"
  /* Testing has minimal resource requirements */
  max_instances       = 2
  available_memory_mb = 2048 // Cache loading speed is improved with better instance type, linearly
  timeout             = 60
  entry_point         = "memorystoreload"
  region              = var.config.region

  source_archive_bucket = var.config.code_bucket.name
  source_archive_object = google_storage_bucket_object.memorystoreload_code.name

  // Function triggered by mutations in the upload bucket
  event_trigger {
    event_type = "providers/cloud.storage/eventTypes/object.change"
    resource   = google_storage_bucket.memorystore_uploads.name
    failure_policy {
      retry = false
    }
  }

  provider      = "google-beta"
  vpc_connector = google_vpc_access_connector.serverless_vpc_connector.name

  environment_variables = {
    REDIS_HOST = var.memorystore_host
    REDIS_PORT = 6379
    EXPIRY     = 60 * 60 * 24 * 30 // 30d expiry for keys
  }
}

data "archive_file" "memorystoreload_zip" {
  type        = "zip"
  source_dir  = "${path.module}/src/memorystoreload"
  output_path = ".tmp/${local.memorystoreloader_function_name}.zip"
}

resource "google_storage_bucket_object" "memorystoreload_code" {
  /* Name needs to be mangled to enable functions to be updated */
  name   = "${local.memorystoreloader_function_name}.${data.archive_file.memorystoreload_zip.output_md5}.zip"
  bucket = var.config.code_bucket.name
  source = data.archive_file.memorystoreload_zip.output_path
}


# ── function_prober.tf ────────────────────────────────────
locals {
  probe_function_name = "probe"
}

resource "google_cloudfunctions_function" "prober" {
  name    = "prober"
  runtime = "nodejs10"
  /* Probing has minimal resource requirements */
  max_instances       = 1
  available_memory_mb = 128
  timeout             = 30
  entry_point         = "probe"
  region              = var.config.region

  source_archive_bucket = var.config.code_bucket.name
  source_archive_object = google_storage_bucket_object.probe_code.name

  event_trigger {
    event_type = "providers/cloud.pubsub/eventTypes/topic.publish"
    resource   = google_pubsub_topic.version_every_minute.name
    failure_policy {
      retry = false
    }
  }

  environment_variables = {
    PROBE_DATASET   = var.prober_ingress_table.dataset_id
    PROBE_TABLE     = var.prober_ingress_table.table_id
    CONTROLS_DATASET = var.control_dataset.dataset_id
  }
}

data "archive_file" "probe_zip" {
  type        = "zip"
  source_dir  = "${path.module}/src/probe"
  output_path = ".tmp/${local.probe_function_name}.zip"
}

resource "google_storage_bucket_object" "probe_code" {
  /* Name needs to be mangled to enable functions to be updated */
  name   = "${local.probe_function_name}.${data.archive_file.probe_zip.output_md5}.zip"
  bucket = var.config.code_bucket.name
  source = data.archive_file.probe_zip.output_path
}


# ── function_test.tf ────────────────────────────────────
locals {
    test_function_name = "test"
}

resource "google_cloudfunctions_function" "test" {
  name                  = "test"
  runtime               = "nodejs10"
  /* Testing has minimal resource requirements */
  max_instances         = 1   
  available_memory_mb   = 128
  timeout               = 30
  entry_point           = "test"
  region                = var.config.region

  source_archive_bucket = var.config.code_bucket.name
  source_archive_object = google_storage_bucket_object.test_code.name

  trigger_http = true

  provider      = "google-beta"
  vpc_connector = google_vpc_access_connector.serverless_vpc_connector.name

  environment_variables = {
    CONFIG_BUCKET = var.config.code_bucket.name
    PROBER_DATASET = var.prober_ingress_table.dataset_id
    PROBER_TABLE = var.prober_ingress_table.table_id
    UNIFIED_VALUES_DATASET = var.unified_values_table.dataset_id
    UNIFIED_VALUES_TABLE = var.unified_values_table.table_id
    /*
    UNIFIED_METABOLICS_DATASET = var.unified_metabolics_table.dataset_id
    UNIFIED_METABOLICS_TABLE = var.unified_metabolics_table.table_id
    */
    CURRENT_TOTALS_DATASET = var.current_totals_table.dataset_id
    CURRENT_TOTALS_TABLE = var.current_totals_table.table_id
    /*
    DAILY_METABOLICS_PRECOMPUTE_DATASET = var.daily_metabolics_precompute_table.dataset_id
    DAILY_METABOLICS_PRECOMPUTE_TABLE = var.daily_metabolics_precompute_table.table_id
    */
    MEMORYSTORE_UPLOADS_BUCKET = google_storage_bucket.memorystore_uploads.name
    REDIS_HOST = var.memorystore_host
    REDIS_PORT = 6379
  }
}

data "archive_file" "test_zip" {
  type        = "zip"
  source_dir  = "${path.module}/src/test"
  output_path = ".tmp/${local.test_function_name}.zip"
}

resource "google_storage_bucket_object" "test_code" {
  /* Name needs to be mangled to enable functions to be updated */
  name   = "${local.test_function_name}.${data.archive_file.test_zip.output_md5}.zip"
  bucket = var.config.code_bucket.name
  source = data.archive_file.test_zip.output_path
}


# ── function_update_current.tf ────────────────────────────────────
locals {
  materializer_function_name = "materialize"
}

resource "google_cloudfunctions_function" "update_current" {
  name    = "update_current"
  runtime = "nodejs10"
  /* Running BQ client has minimal resource requirements */
  max_instances       = 1
  available_memory_mb = 128
  timeout             = 30
  entry_point         = "materialize"
  region              = var.config.region

  source_archive_bucket = var.config.code_bucket.name
  source_archive_object = google_storage_bucket_object.materialize_code.name

  // Function triggered by mutations in the upload bucket
  event_trigger {
    event_type = "providers/cloud.pubsub/eventTypes/topic.publish"
    resource   = google_pubsub_topic.version_every_two_minutes.name
    failure_policy {
      retry = false
    }
  }

  environment_variables = {
    PROJECT        = var.config.project
    DATASET        = var.current_totals_table.dataset_id
    TABLE          = var.current_totals_table.table_id
    SOURCE_DATASET = var.current_totals_latest_table.dataset_id
    SOURCE_TABLE   = var.current_totals_latest_table.table_id
    BUCKET         = google_storage_bucket.memorystore_uploads.name
    FILE           = "current_totals.json"
  }
}

data "archive_file" "materialize_zip" {
  type        = "zip"
  source_dir  = "${path.module}/src/materialize"
  output_path = ".tmp/${local.materializer_function_name}.zip"
}

resource "google_storage_bucket_object" "materialize_code" {
  /* Name needs to be mangled to enable functions to be updated */
  name   = "${local.materializer_function_name}.${data.archive_file.materialize_zip.output_md5}.zip"
  bucket = var.config.code_bucket.name
  source = data.archive_file.materialize_zip.output_path
}


# ── function_update_historical.tf ────────────────────────────────────
resource "google_cloudfunctions_function" "update_historical" {
  name    = "update_historical"
  runtime = "nodejs10"
  /* Running BQ client has minimal resource requirements */
  max_instances       = 1
  available_memory_mb = 128
  timeout             = 30
  entry_point         = "materialize"
  region              = var.config.region

  source_archive_bucket = var.config.code_bucket.name
  // Note we reuse source code setup in function_update_current.tf
  source_archive_object = google_storage_bucket_object.materialize_code.name

  // Function triggered by mutations in the upload bucket
  event_trigger {
    event_type = "providers/cloud.pubsub/eventTypes/topic.publish"
    resource   = google_pubsub_topic.version_every_hour.name
    failure_policy {
      retry = false
    }
  }

  environment_variables = {
    PROJECT        = var.config.project
    DATASET        = var.historical_totals_table.dataset_id
    TABLE          = var.historical_totals_table.table_id
    SOURCE_DATASET = var.historical_totals_latest_table.dataset_id
    SOURCE_TABLE   = var.historical_totals_latest_table.table_id
    N_DAYS         = var.config.retention_days
    BUCKET         = google_storage_bucket.memorystore_uploads.name
    FILE           = "historical_totals.json"
  }
}


# ── gcs.tf ────────────────────────────────────
resource "google_storage_bucket" "memorystore_uploads" {
  name     = "${var.config.project}_memorystore_uploads"
  location = "${var.config.region}"
}


# ── pubsub.tf ────────────────────────────────────
resource "google_pubsub_topic" "version_every_minute" {
  name = "version_every_minute"
}

resource "google_pubsub_topic" "version_every_two_minutes" {
  name = "version_every_two_minutes"
}

resource "google_pubsub_topic" "version_every_hour" {
  name = "version_every_hour"
}


# ── scheduler.tf ────────────────────────────────────
resource "google_cloud_scheduler_job" "version_every_minute" {
  name        = "version_every_minute"
  description = "Pings topic with version once a min"
  schedule    = "* * * * *"
  project     = var.config.project
  region      = var.config.region

  pubsub_target {
    topic_name = "${google_pubsub_topic.version_every_minute.id}"
    data = "${base64encode(jsonencode({
      version = "${var.config.version}"
    }))}"
  }
}

resource "google_cloud_scheduler_job" "version_every_two_minutes" {
  name        = "version_every_two_minutes"
  description = "Pings topic with version once every 2 mins"
  schedule    = "*/2 * * * *"
  project     = "${var.config.project}"
  region      = "${var.config.region}"

  pubsub_target {
    topic_name = "${google_pubsub_topic.version_every_two_minutes.id}"
    data = "${base64encode(jsonencode({
      version = "${var.config.version}"
    }))}"
  }
}

resource "google_cloud_scheduler_job" "version_every_hour" {
  name        = "version_every_hour"
  description = "Pings topic with version once every hour"
  schedule    = "0 * * * *"
  region      = "${var.config.region}"
  project     = "${var.config.project}"

  pubsub_target {
    topic_name = "${google_pubsub_topic.version_every_hour.id}"
    data = "${base64encode(jsonencode({
      version = "${var.config.version}"
    }))}"
  }
}


# ── vpc.tf ────────────────────────────────────
resource "google_vpc_access_connector" "serverless_vpc_connector" {
  name          = "${var.config.network}-connector"
  provider      = "google-beta"
  region        = var.config.region
  ip_cidr_range = var.config.ip_cidr_range
  network       = var.config.network
}
