resource "google_bigquery_dataset" "spre_styringsinfo_dataset" {
  dataset_id = "spre_styringsinfo_dataset"
  location   = var.gcp_project["region"]
  project    = var.gcp_project["project"]
  labels     = {}

  access {
    role          = "OWNER"
    special_group = "projectOwners"
  }
  access {
    role          = "READER"
    special_group = "projectReaders"
  }
  access {
    role          = "WRITER"
    special_group = "projectWriters"
  }
  access {
    view {
      dataset_id = google_bigquery_dataset.saksbehandlingsstatistikk_til_team_sak_dataset.dataset_id
      project_id = var.gcp_project["project"]
      table_id   = "behandlingshendelse_view"
    }
  }
  timeouts {}
}

resource "google_datastream_connection_profile" "spre_styringsinfo_postgresql_connection_profile" {
  location              = var.gcp_project["region"]
  display_name          = "spre-styringsinfo-postgresql-connection-profile"
  connection_profile_id = "spre-styringsinfo-postgresql-connection-profile"

  postgresql_profile {
    hostname = google_compute_instance.tbd_datastream_cloud_sql_proxy_vm.network_interface[0].network_ip
    port     = var.spre_styringsinfo_cloud_sql_port
    username = local.spre_styringsinfo_db_credentials["username"]
    password = local.spre_styringsinfo_db_credentials["password"]
    database = "spre-styringsinfo"
  }

  private_connectivity {
    private_connection = google_datastream_private_connection.tbd_datastream_private_connection.id
  }
}

resource "google_datastream_stream" "spre_styringsinfo_datastream" {
  stream_id     = "spre-styringsinfo-datastream"
  display_name  = "spre-styringsinfo-datastream"
  desired_state = "RUNNING"
  project       = var.gcp_project["project"]
  location      = var.gcp_project["region"]
  labels        = {}
  backfill_all {}
  timeouts {}

  source_config {
    source_connection_profile = google_datastream_connection_profile.spre_styringsinfo_postgresql_connection_profile.id

    postgresql_source_config {
      max_concurrent_backfill_tasks = 0
      publication                   = "spre_styringsinfo_publication"
      replication_slot              = "spre_styringsinfo_replication"

      exclude_objects {
        postgresql_schemas {
          schema = "public"

          postgresql_tables {
            table = "flyway_schema_history"
          }

          postgresql_tables {
            table = "hendelse"
          }

          postgresql_tables {
            table = "behandlingshendelse"
            postgresql_columns {
              column = "hendelseid"
            }
            postgresql_columns {
              column = "er_korrigert"
            }
            postgresql_columns {
              column = "siste"
            }
          }
        }
      }

      include_objects {
        postgresql_schemas {
          schema = "public"
        }
      }
    }
  }

  destination_config {
    destination_connection_profile = google_datastream_connection_profile.datastream_bigquery_connection_profile.id

    bigquery_destination_config {
      data_freshness = "3600s"

      single_target_dataset {
        dataset_id = "${var.gcp_project["project"]}:${google_bigquery_dataset.spre_styringsinfo_dataset.dataset_id}"
      }
    }
  }
}
