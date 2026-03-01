To fulfill the business need, we will create an AWS RDS MySQL instance and then create a snapshot of this instance. The Terraform configuration will include the necessary provider configuration for AWS, the RDS instance resource, and the snapshot resource. We will also define an IAM role with the necessary permissions to manage RDS resources. The configuration will be set up in the `us-east-1` region.

<iac_template>

```hcl
provider "aws" {
  region = "us-east-1"
}

resource "aws_db_instance" "my_mysql_instance" {
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
}

resource "aws_db_snapshot" "my_mysql_snapshot" {
  db_instance_identifier = aws_db_instance.my_mysql_instance.id
  db_snapshot_identifier = "my-mysql-snapshot"
}

output "db_instance_endpoint" {
  value = aws_db_instance.my_mysql_instance.endpoint
}

output "db_snapshot_id" {
  value = aws_db_snapshot.my_mysql_snapshot.id
}
```

</iac_template>

This configuration will create a MySQL RDS instance with a specified storage size and instance class. It will also create a snapshot of the instance. The outputs will provide the endpoint of the RDS instance and the ID of the snapshot.