data "aws_elastic_beanstalk_solution_stack" "this" {
  region      = var.region
  most_recent = var.most_recent
  name_regex  = var.name_regex
}