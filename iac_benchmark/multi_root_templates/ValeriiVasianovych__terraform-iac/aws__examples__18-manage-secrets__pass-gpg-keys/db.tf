resource "aws_db_instance" "mysql" {
  identifier           = "mysql-db"         # It is the name of the database instance.
  publicly_accessible  = true               # It means that the database is accessible from the internet.
  allocated_storage    = 5                  # It is the size of the storage in GB.
  storage_type         = "gp2"              # It is the type of storage.
  engine               = "mysql"            # It is the engine of the database.
  engine_version       = "5.7"              # It is the version of MySQL.
  instance_class       = "db.t3.micro"      # It is the smallest instance class.
  parameter_group_name = "default.mysql5.7" # It is the default parameter group for MySQL 5.7.
  skip_final_snapshot  = true               # It means that when the instance is deleted, it will not take the final snapshot.
  apply_immediately    = true               # It means that the changes (for example, changing the engine version) will be applied immediately.

  username = var.db_username
  password = var.db_password
}
