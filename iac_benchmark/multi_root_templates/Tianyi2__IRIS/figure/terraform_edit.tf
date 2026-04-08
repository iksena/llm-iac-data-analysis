resource "aws_security_group" "db_security_group" {
  ingress {
    cidr_blocks = ["0.0.0.0/0"]             # SMELL 1 - Unrestricted IP addres
  }
}
resource "aws_db_instance" "database" {
  count = var.environment == "prod" ? 1 : 0
  vpc_security_group_ids = [
    aws_security_group.db_security_group.id]
}
resource "aws_cloudwatch_metric_alarm" "db_cpu" { # SMELL 2 - Cascading Provision Failure
  dimensions = {
    DBInstanceIdentifier = aws_db_instance.database[0].id
  }
}