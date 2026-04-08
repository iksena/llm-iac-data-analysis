resource "aws_devopsguru_event_sources_config" "this" {
  region = var.region

  event_sources {
    amazon_code_guru_profiler {
      status = var.amazon_code_guru_profiler_status
    }
  }
}