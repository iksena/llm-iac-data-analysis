resource "aws_chimesdkvoice_global_settings" "this" {
  voice_connector {
    cdr_bucket = var.cdr_bucket
  }
}