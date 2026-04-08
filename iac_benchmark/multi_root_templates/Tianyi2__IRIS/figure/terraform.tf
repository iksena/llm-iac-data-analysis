variable "environment" {
  type = string
  validation {
    condition = contains(["dev", "prod"], var.environment)
    error_message = "Must be dev or prod."
  }
}
variable "backup_retention" {               # SMELL 3 - Unused parameter
  type    = number
  default = 7
}
resource "aws_security_group" "db_security_group" {
  name        = "db-access"
  description = "Database access"
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]             # SMELL 1 - Unrestricted IP address
  }
}
resource "aws_db_instance" "database" {
  count          = var.environment == "prod" ? 1 : 0
  engine         = "mysql"
  instance_class = "db.t3.micro"
  username       = "admin"
  password       = "Admin123!"              # SMELL 4 - Hardcoded password
  vpc_security_group_ids = [
    aws_security_group.db_security_group.id]
}
resource "aws_cloudwatch_metric_alarm" "db_cpu_alarm" {
  alarm_name  = "db-high-cpu"               # SMELL 2 - Cascading Provision Failure
  namespace   = "AWS/RDS"
  metric_name = "CPUUtilization"
  dimensions  = {
    DBInstanceIdentifier = aws_db_instance.database[0].id
  }
  comparison_operator = "GreaterThanThreshold"
  threshold           = 80
  evaluation_periods  = 2
  period              = 300
  statistic           = "Average"
}
