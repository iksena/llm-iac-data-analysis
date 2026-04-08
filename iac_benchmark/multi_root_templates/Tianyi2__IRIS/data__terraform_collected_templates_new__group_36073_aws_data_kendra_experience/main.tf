data "aws_kendra_experience" "this" {
  region        = var.region
  experience_id = var.experience_id
  index_id      = var.index_id
}