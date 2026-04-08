
# Make workload pool
resource "google_iam_workload_identity_pool" "dbt-workload-pool" {
  workload_identity_pool_id = "bomlo-dbt-identity-pool2"
  display_name              = "Bømlo dbt identity pool"
  description               = "Identity pool for dbt from bomlo-dbt GitHub project"
  project                   = var.project_id
}

# Make provider for GitHub OIDC in the workload pool
resource "google_iam_workload_identity_pool_provider" "github-provider" {
  workload_identity_pool_id          = google_iam_workload_identity_pool.dbt-workload-pool.workload_identity_pool_id
  workload_identity_pool_provider_id = "dbt-github-provider"
  display_name                       = "OIDC provider for bomlo-dbt repo"

  attribute_mapping = {
    "google.subject"="assertion.sub"
    "attribute.actor"="assertion.actor"
    "attribute.repository"="assertion.repository"
    "attribute.repository_owner"="assertion.repository_owner"
  }

  attribute_condition = "assertion.repository == \"${var.repo_full_name}\""

  oidc {
    issuer_uri="https://token.actions.githubusercontent.com"
  } 
}

# Make a SA for the dbt workload pool
# This is the SA that will be used to run dbt jobs
resource "google_service_account" "dbt-workload-pool-sa" {
  account_id   = "bomlo-dbt-sa-uvigcy"
  display_name = "Bømlo dbt service account"
  project      = var.project_id
  description  = "Service konto for dbt prosjektet i Bømlo. Brukes av dbt fra GitHub repoet bomlo-dbt via workload pool. 'uvigcy' er random og er der fordi den orginale email'en ble lekket 27.11.25 i GitHub gate."
}

# Grant the workload pool provider access to the SA
resource "google_service_account_iam_member" "workpool-user" {
  service_account_id = google_service_account.dbt-workload-pool-sa.name
  role               = "roles/iam.workloadIdentityUser"
  member             = "principalSet://iam.googleapis.com/${google_iam_workload_identity_pool.dbt-workload-pool.name}/attribute.repository/${var.repo_full_name}" 
}

# Grant roles to the service account
resource "google_project_iam_member" "dbt-workload-pool-grants" {
  for_each = toset(var.grants)
  project  = var.project_id
  role     = each.value
  member   = "serviceAccount:${google_service_account.dbt-workload-pool-sa.email}"

  depends_on = [ google_iam_workload_identity_pool_provider.github-provider ]
}

output "workpool-sa-email" {
  value = "serviceAccount:${google_service_account.dbt-workload-pool-sa.email}"
}