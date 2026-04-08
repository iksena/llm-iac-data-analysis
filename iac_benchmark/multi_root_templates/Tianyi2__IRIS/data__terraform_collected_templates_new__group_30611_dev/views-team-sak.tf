resource "google_bigquery_dataset" "saksbehandlingsstatistikk_til_team_sak_dataset" {
  dataset_id    = "saksbehandlingsstatistikk_til_team_sak_dataset"
  location      = var.gcp_project["region"]
  friendly_name = "saksbehandlingsstatistikk_til_team_sak_dataset"
  labels        = {}
  description   = "Datagrunnlag tiltenkt delt med Team Sak for saksbehandlingsstatistikk. Basert på hendelser i ny sykepengeløsning (hentet fra tbd.rapid.v1)"

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
    role          = "READER"
    user_by_email = "sykepenger-ptsak-reader@ptsak-dev-7196.iam.gserviceaccount.com"
  }
  timeouts {}
}


module "saksbehandlingsstatistikk_til_team_sak_view" {
  source              = "../modules/google-bigquery-view"
  deletion_protection = false
  dataset_id          = google_bigquery_dataset.saksbehandlingsstatistikk_til_team_sak_dataset.dataset_id
  view_id             = "behandlingshendelse_view"
  view_description    = "Basert på en rekke hendelser på tbd.rapid.v1 som påvirker saksbehandling på sykepenger"
  view_schema = jsonencode(
    [
      {
        name        = "sekvensnummer"
        type        = "INT64"
        description = "Løpenummer tildelt ved lagring av rad i spre-styringsinfo. Brukt som identifikator for raden."
        mode        = "NULLABLE"
      },
      {
        name        = "sakYtelse"
        type        = "STRING"
        description = "Settes alltid til SYKEPENGER"
        mode        = "NULLABLE"
      },
      {
        name        = "sakUtland"
        type        = "STRING"
        description = "Settes alltid til NASJONAL"
        mode        = "NULLABLE"
      },
      {
        name        = "avsender"
        type        = "STRING"
        description = "Settes alltid til Speil (ny vedtaksløsning for sykepenger)"
        mode        = "NULLABLE"
      },
      {
        name        = "sakUuid"
        type        = "STRING"
        description = "UUID som identifiserer saken (vedtaksperioden)"
        mode        = "NULLABLE"
      },
      {
        name        = "behandlingUuid"
        type        = "STRING"
        description = "UUID som identifiserer behandlingen (generasjonen)"
        mode        = "NULLABLE"
      },
      {
        name        = "funksjonelltid"
        type        = "TIMESTAMP"
        description = "Funksjonell tid. @opprettet på hendelsen som har generert raden"
        mode        = "NULLABLE"
      },
      {
        name        = "teknisktid"
        type        = "TIMESTAMP"
        description = "Teknisk tid. Når hendelsen (raden) legges inn i databasen."
        mode        = "NULLABLE"
      },
      {
        name        = "relatertBehandlingUuid"
        type        = "STRING"
        description = "peker på relatert behandlingUuid hvis behandlingen gjelder samme sak"
        mode        = "NULLABLE"
      },
      {
        name        = "mottattTid"
        type        = "TIMESTAMP"
        description = "Tidspunktet da behandlingen oppstår"
        mode        = "NULLABLE"
      },
      {
        name        = "registrertTid"
        type        = "TIMESTAMP"
        description = "Tidspunkt da behandlingen første gang ble registrert i fagsystemet"
        mode        = "NULLABLE"
      },
      {
        name        = "behandlingstype"
        type        = "STRING"
        description = "Hvorvidt behandlingen er en søknad, gjenåpning eller revurdering"
        mode        = "NULLABLE"
      },
      {
        name        = "behandlingstatus"
        type        = "STRING"
        description = "Status for behandlingen. Endrer seg i løpet av livsløpet til en behandling"
        mode        = "NULLABLE"
      },
      {
        name        = "behandlingskilde"
        type        = "STRING"
        description = "Hva/hvem som er kilden til at behandlingen har oppstått i utgangspunktet"
        mode        = "NULLABLE"
      },
      {
        name        = "behandlingsresultat"
        type        = "STRING"
        description = "Resultatet av behandlingen"
        mode        = "NULLABLE"
      },
      {
        name        = "behandlingsmetode"
        type        = "STRING"
        description = "Om behandlingen var manuell eller automatisk."
        mode        = "NULLABLE"
      },
      {
        name        = "aktorId"
        type        = "STRING"
        description = "Identifiserer hvem behandlingen gjelder for"
        mode        = "NULLABLE"
      },
      {
        name        = "ansvarligenhet"
        type        = "STRING"
        description = "Identifiserer hvilken enhet som er ansvarlig for behandlingen"
        mode        = "NULLABLE"
      },
      {
        name        = "saksbehandlerenhet"
        type        = "STRING"
        description = "Identifiserer hvilken enhet saksbehandler tilhører"
        mode        = "NULLABLE"
      },
      {
        name        = "beslutterenhet"
        type        = "STRING"
        description = "Identifiserer hvilken enhet beslutter tilhører"
        mode        = "NULLABLE"
      },
      {
        name        = "periodetype"
        type        = "STRING"
        description = "Angir om saken er en førstegangsbehandling der inngangsvilkår skal vurderes, eller om det er en forlengelse der dette ikke er nødvendig"
        mode        = "NULLABLE"
      },
      {
        name        = "mottaker"
        type        = "STRING"
        description = "Angir hvem det utbetales eller trekkes penger fra"
        mode        = "NULLABLE"
      },
      {
        name        = "versjon"
        type        = "STRING"
        description = "Skjemaversjon. Ved endringer og utvidelser i felter øker vi versjon"
        mode        = "NULLABLE"
      }
    ]
  )
  view_query = <<EOF
SELECT
  sekvensnummer,
  "SYKEPENGER" AS sakYtelse,
  "NASJONAL" AS sakUtland,
  "Speil" AS avsender,
  "4488" AS ansvarligenhet,
  sakid AS sakUuid,
  behandlingid AS behandlingUuid,
  funksjonelltid,
  teknisktid,
  JSON_VALUE(DATA, "$.relatertBehandlingId") AS relatertBehandlingUuid,
  TIMESTAMP(JSON_VALUE(DATA, "$.mottattTid")) AS mottattTid,
  TIMESTAMP(JSON_VALUE(DATA, "$.registrertTid")) AS registrertTid,
  JSON_VALUE(DATA, "$.behandlingstype") AS behandlingstype,
  JSON_VALUE(DATA, "$.behandlingstatus") AS behandlingstatus,
  JSON_VALUE(DATA, "$.behandlingskilde") AS behandlingskilde,
  JSON_VALUE(DATA, "$.behandlingsresultat") AS behandlingsresultat,
  JSON_VALUE(DATA, "$.aktørId") AS aktorId,
  JSON_VALUE(DATA, "$.behandlingsmetode") AS behandlingsmetode,
  JSON_VALUE(DATA, "$.saksbehandlerEnhet") AS saksbehandlerenhet,
  JSON_VALUE(DATA, "$.beslutterEnhet") AS beslutterenhet,
  JSON_VALUE(DATA, "$.periodetype") AS periodetype,
  JSON_VALUE(DATA, "$.mottaker") AS mottaker,
  versjon
FROM
  `${var.gcp_project["project"]}.${google_bigquery_dataset.spre_styringsinfo_dataset.dataset_id}.public_behandlingshendelse`
ORDER BY sekvensnummer
EOF
}


resource "google_bigquery_table_iam_binding" "behandlingshendelse_view_iam_binding" {
  project    = var.gcp_project.project
  dataset_id = google_bigquery_dataset.saksbehandlingsstatistikk_til_team_sak_dataset.dataset_id
  table_id   = module.saksbehandlingsstatistikk_til_team_sak_view.bigquery_view_id
  role       = "roles/bigquery.dataViewer"
  members    = ["user:${local.team_sak_epost}", "serviceAccount:sykepenger-ptsak-reader@ptsak-dev-7196.iam.gserviceaccount.com"]
}
