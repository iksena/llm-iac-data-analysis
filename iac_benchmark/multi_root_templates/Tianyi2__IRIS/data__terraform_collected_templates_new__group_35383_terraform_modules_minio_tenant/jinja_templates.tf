data "jinja_template" "configuration" {
  context {
    type = "json"
    data = local.jinja_context
  }

  source {
    directory = dirname(local.configuration_template_path)
    template  = file(local.configuration_template_path)
  }
}
