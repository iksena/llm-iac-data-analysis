resource "aws_redshift_authentication_profile" "this" {
  region                         = var.region
  authentication_profile_name    = var.authentication_profile_name
  authentication_profile_content = var.authentication_profile_content
}