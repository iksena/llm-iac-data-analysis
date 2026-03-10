# ── variables.tf ────────────────────────────────────
variable "config" {
  type = any
}


# ── outputs.tf ────────────────────────────────────
output "prober_ingress_table" {
  value = google_bigquery_table.prober_ingress
}

output "control_dataset" {
  value = google_bigquery_dataset.ingress
}
output "unified_values_table" {
  value = google_bigquery_table.unified_values
}
output "current_totals_latest_table" {
  value = google_bigquery_table.current_totals_latest
}

output "historical_totals_latest_table" {
  value = google_bigquery_table.historical_totals_latest
}

output "current_totals_table" {
  value = google_bigquery_table.current_totals
}

output "historical_totals_table" {
  value = google_bigquery_table.historical_totals
}

output "ingress_dataset" {
  value = google_bigquery_dataset.ingress
}


# ── controls.tf ────────────────────────────────────

locals {
  control_fields = ["multiplier"]
  control_types  = ["FLOAT"]
  default_value  = ["1.0"]
}

resource "google_bigquery_table" "control_operations" {
  count = length(local.control_fields)
  dataset_id = google_bigquery_dataset.ingress.dataset_id
  table_id   = "control_${element(local.control_fields, count.index)}"
  schema = templatefile(
      "${path.module}/schemas/control.template.schema.json", {
          FIELD = element(local.control_fields, count.index)
          TYPE = element(local.control_types, count.index)
      })
  time_partitioning {
    field = "timestamp"
    type = "DAY"
    require_partition_filter = false
  }
  lifecycle {
    prevent_destroy = true
  }
}

resource "google_bigquery_table" "control_range_view" {
  count = length(local.control_fields)
  dataset_id = google_bigquery_dataset.views.dataset_id
  table_id   = "control_value_range_${element(local.control_fields, count.index)}"
  view {
    query = templatefile("${path.module}/sql/control_range_view.sql", {
          NAME = element(local.control_fields, count.index),
          DEFAULT = element(local.default_value, count.index)
          OPERATIONS = "${var.config.project}.${google_bigquery_table.control_operations[count.index].dataset_id}.${google_bigquery_table.control_operations[count.index].table_id}"
    })
    use_legacy_sql = false
  }
}

# ── ingress.tf ────────────────────────────────────
resource "google_bigquery_dataset" "ingress" {
  dataset_id                  = "ingress"
  description                 = "Raw event data"
  location                    = "EU"
}

resource "google_bigquery_table" "vendor1_ingress" {
  dataset_id = google_bigquery_dataset.ingress.dataset_id
  table_id   = "vendor1_ingress"
  schema = file("${path.module}/schemas/vendor1.schema.json")
  time_partitioning {
    field = "timestamp"
    type = "DAY"
    require_partition_filter = true
  }
  lifecycle {
    prevent_destroy = true
  }
}

resource "google_bigquery_table" "prober_ingress" {
  dataset_id = google_bigquery_dataset.ingress.dataset_id
  table_id   = "prober_ingress"
  schema = "${file("${path.module}/schemas/prober.schema.json")}"
  time_partitioning {
    field = "timestamp"
    type = "DAY"
    require_partition_filter = true
  }
  lifecycle {
    prevent_destroy = true
  }
}



# ── reports.tf ────────────────────────────────────

resource "google_bigquery_dataset" "reports" {
  dataset_id                  = "reports"
  description                 = "Materialized reports"
  location                    = "EU"
}

resource "google_bigquery_table" "current_totals" {
  dataset_id = google_bigquery_dataset.reports.dataset_id
  table_id   = "current_totals"
  schema = "${file("${path.module}/schemas/report.schema.json")}"
}

resource "google_bigquery_table" "historical_totals" {
  dataset_id = google_bigquery_dataset.reports.dataset_id
  table_id   = "historical_totals"
  schema = "${file("${path.module}/schemas/report.schema.json")}"
  time_partitioning {
    field = "day"
    type = "DAY"
    require_partition_filter = true
  }
}


# ── urdf.tf ────────────────────────────────────
resource "google_bigquery_dataset" "urdfs" {
  dataset_id                  = "urdfs"
  description                 = "Data processing"
  location                    = "EU"
}
resource "google_storage_bucket_object" "jsonpath" {
  name   = "udf/jsonpath-0.8.0.js"
  source = "${path.module}/udf/jsonpath-0.8.0.js"
  bucket = "${var.config.code_bucket.name}"
}

resource "null_resource" "CUSTOM_JSON_EXTRACT_ARRAY_FLOAT" {
  triggers = {
    version = "0.0.4" // Bump to force apply to this resource
  }
  provisioner "local-exec" {
    command = "bq query --project=${var.config.project} --use_legacy_sql=false '${templatefile("${path.module}/udf/CUSTOM_JSON_EXTRACT_ARRAY_FLOAT.sql", {
        dataset = google_bigquery_dataset.urdfs.dataset_id
        library = "gs://${var.config.code_bucket.name}/${google_storage_bucket_object.jsonpath.output_name}"
    })}'"
  }
}


# ── views.tf ────────────────────────────────────
resource "google_bigquery_dataset" "views" {
  dataset_id                  = "views"
  description                 = "Data processing"
  location                    = "EU"
}

resource "google_bigquery_table" "vendor1" {
  dataset_id = google_bigquery_dataset.views.dataset_id
  table_id   = "vendor1"
  view {
    query = templatefile("${path.module}/sql/vendor1_cleanup.sql", {
      urdfs = "${var.config.project}.${google_bigquery_dataset.urdfs.dataset_id}"
      ingress = "${var.config.project}.${google_bigquery_table.vendor1_ingress.dataset_id}.${google_bigquery_table.vendor1_ingress.table_id}"
    })
    use_legacy_sql = false
  }
  depends_on = [null_resource.CUSTOM_JSON_EXTRACT_ARRAY_FLOAT]
}

resource "google_bigquery_table" "unified_values" {
  dataset_id = google_bigquery_dataset.views.dataset_id
  table_id   = "unified_values"
  view {
    query = templatefile("${path.module}/sql/unified_values.sql", {
      prober = "${var.config.project}.${google_bigquery_table.prober_ingress.dataset_id}.${google_bigquery_table.prober_ingress.table_id}",
      vendor1 = "${var.config.project}.${google_bigquery_table.vendor1.dataset_id}.${google_bigquery_table.vendor1.table_id}"
    })
    use_legacy_sql = false
  }
}

resource "google_bigquery_table" "daily_adjusted_totals" {
  dataset_id = google_bigquery_dataset.views.dataset_id
  table_id   = "daily_adjusted_totals"
  view {
    query = templatefile("${path.module}/sql/daily_adjusted_totals.sql", {
      values = "${var.config.project}.${google_bigquery_table.unified_values.dataset_id}.${google_bigquery_table.unified_values.table_id}",
      control_prefix = "${var.config.project}.${google_bigquery_table.control_range_view[0].dataset_id}.control_value_range_",
      control_fields = ["multiplier"]
    })
    use_legacy_sql = false
  }
}

resource "google_bigquery_table" "current_totals_latest" {
  dataset_id = google_bigquery_dataset.views.dataset_id
  table_id   = "current_totals"
  view {
    query = templatefile("${path.module}/sql/last_n_days_totals.sql", {
      n_days = 1
      PREFIX = "current_totals/"
      daily_totals = "${var.config.project}.${google_bigquery_table.daily_adjusted_totals.dataset_id}.${google_bigquery_table.daily_adjusted_totals.table_id}"
    })
    use_legacy_sql = false
  }
}

resource "google_bigquery_table" "historical_totals_latest" {
  dataset_id = google_bigquery_dataset.views.dataset_id
  table_id   = "historical_totals"
  view {
    query = templatefile("${path.module}/sql/last_n_days_totals.sql", {
      n_days = "${var.config.retention_days}"
      PREFIX = "historic_totals/"
      daily_totals = "${var.config.project}.${google_bigquery_table.daily_adjusted_totals.dataset_id}.${google_bigquery_table.daily_adjusted_totals.table_id}"
    })
    use_legacy_sql = false
  }
}
