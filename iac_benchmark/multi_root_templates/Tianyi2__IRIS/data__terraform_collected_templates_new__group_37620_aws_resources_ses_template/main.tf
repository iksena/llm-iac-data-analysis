resource "aws_ses_template" "this" {
  region  = var.region
  name    = var.name
  html    = var.html
  subject = var.subject
  text    = var.text
}