resource "sentry_project" "monoweb_rpc" {
  organization = "dotkom"
  teams        = ["dotkom"]

  name = "Monoweb RPC"
  slug = "monoweb-rpc"

  platform = "node"
}

resource "sentry_key" "monoweb_rpc" {
  organization = sentry_project.monoweb_rpc.organization
  project      = sentry_project.monoweb_rpc.slug

  name = "Production"
}
