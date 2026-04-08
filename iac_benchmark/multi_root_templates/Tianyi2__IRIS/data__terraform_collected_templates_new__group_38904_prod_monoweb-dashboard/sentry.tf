resource "sentry_project" "monoweb_dashboard" {
  organization = "dotkom"
  teams        = ["dotkom"]

  name = "Monoweb Dashboard"
  slug = "monoweb-dashboard"

  platform = "javascript-nextjs"
}

resource "sentry_key" "monoweb_dashboard" {
  organization = sentry_project.monoweb_dashboard.organization
  project      = sentry_project.monoweb_dashboard.slug

  name = "Production"
}