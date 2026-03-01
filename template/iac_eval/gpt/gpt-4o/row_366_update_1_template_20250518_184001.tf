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