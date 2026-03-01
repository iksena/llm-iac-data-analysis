To fulfill the business need, we will create an AWS Lightsail managed database using Terraform. AWS Lightsail provides a simplified way to manage cloud resources, and in this case, we will set up a Lightsail database instance. The configuration will include specifying the database engine, version, instance size, and other necessary parameters. We will also configure the AWS provider to ensure the resources are created in a specified region.

<iac_template>
```hcl
provider "aws" {
  region = "us-west-2"
}

resource "aws_lightsail_database" "example" {
  name                = "example-database"
  availability_zone   = "us-west-2a"
  blueprint_id        = "mysql_5_7"
  bundle_id           = "medium_1_0"
  master_database_name = "exampledb"
  master_username     = "admin"
  master_user_password = "examplepassword123"

  tags = {
    Environment = "Production"
    Name        = "ExampleDatabase"
  }
}

output "database_endpoint" {
  value = aws_lightsail_database.example.endpoint
}

output "database_port" {
  value = aws_lightsail_database.example.port
}
```
</iac_template>

This Terraform configuration sets up a Lightsail managed database with MySQL 5.7 in the `us-west-2` region. The database is configured with a medium bundle size, and the master database name, username, and password are specified. The configuration also includes outputs for the database endpoint and port, which can be used to connect to the database.