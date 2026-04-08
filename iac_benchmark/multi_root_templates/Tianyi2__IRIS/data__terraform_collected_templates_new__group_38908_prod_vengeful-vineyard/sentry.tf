resource "sentry_project" "vengeful_vineyard_frontend" {
  organization = "dotkom"
  teams        = ["dotkom"]

  name = "Vengeful Vineyard Frontend"
  slug = "vengeful-vineyard-frontend"

  platform = "javascript-react"
}

resource "sentry_project" "vengeful_vineyard_backend" {
  organization = "dotkom"
  teams        = ["dotkom"]

  name = "Vengeful Vineyard Backend"
  slug = "vengeful-vineyard-backend"

  platform = "python-fastapi"
}
