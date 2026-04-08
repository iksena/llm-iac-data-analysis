resource "aws_macie2_account" "this" {
  region                       = var.region
  finding_publishing_frequency = var.finding_publishing_frequency
  status                       = var.status
}