data "aws_polly_voices" "this" {
  region                            = var.region
  engine                            = var.engine
  include_additional_language_codes = var.include_additional_language_codes
  language_code                     = var.language_code
}