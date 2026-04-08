data "aws_codeguruprofiler_profiling_group" "this" {
  region = var.region
  name   = var.name
}