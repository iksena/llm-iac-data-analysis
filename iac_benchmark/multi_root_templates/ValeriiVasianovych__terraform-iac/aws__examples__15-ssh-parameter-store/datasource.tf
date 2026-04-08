data "aws_region" "current" {}
data "aws_ssm_parameter" "rds_password" {
  name = "/prod/mysql"
  depends_on = [aws_ssm_parameter.rds_password]
}