data "jinja_template" "credentials" {
  context {
    type = "json"
    data = local.jinja_context
  }

  source {
    directory = dirname(local.credentials_template_path)
    template  = file(local.credentials_template_path)
  }
}
