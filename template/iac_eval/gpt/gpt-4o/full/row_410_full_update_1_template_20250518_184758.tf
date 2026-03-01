To fulfill the business need, we will create an AWS RDS MySQL instance using Terraform. The configuration will include the necessary provider setup, an RDS instance with the MySQL engine, and settings to apply changes immediately. We will also create a security group to allow access to the MySQL instance. The Terraform configuration will ensure that any changes to the instance are applied immediately by setting the `apply_immediately` parameter to `true`.

Here is the Terraform HCL configuration:

<iac_template>
```hcl
provider "aws" {
  region = "us-west-2"
}

resource "aws_db_instance" "mysql_instance" {
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = "db.t3.micro"
  name                 = "mydb"
  username             = "admin"
  password             = "password123"
  parameter_group_name = "default.mysql8.0"
  skip_final_snapshot  = true
  apply_immediately    = true

  vpc_security_group_ids = [aws_security_group.mysql_sg.id]
}

resource "aws_security_group" "mysql_sg" {
  name        = "mysql_sg"
  description = "Allow MySQL access"

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
```
</iac_template>

This configuration sets up a MySQL RDS instance with immediate application of changes, a security group to allow access on port 3306, and uses the `us-west-2` region. The database credentials and other parameters are specified directly in the configuration.