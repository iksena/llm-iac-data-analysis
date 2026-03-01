To meet the business need, we will provision a secure PostgreSQL database instance using AWS RDS within a specified VPC. The configuration will include:

1. **AWS Provider Configuration**: Set up the AWS provider to deploy resources in a specified region.
2. **VPC and Subnets**: Use existing VPC and subnets to host the RDS instance.
3. **KMS Key**: Create a KMS key for encrypting the RDS instance.
4. **RDS Parameter Group**: Define a custom parameter group for PostgreSQL settings.
5. **Security Group**: Create a security group to manage access to the RDS instance.
6. **RDS Instance**: Provision a PostgreSQL RDS instance with the specified engine version, storage size, multi-AZ deployment, and encryption using the KMS key.

The following Terraform HCL template will implement this infrastructure:

<iac_template>
```hcl
provider "aws" {
  region = "us-west-2"
}

resource "aws_kms_key" "rds_encryption" {
  description             = "KMS key for RDS encryption"
  deletion_window_in_days = 10
}

resource "aws_db_parameter_group" "postgresql_parameters" {
  name   = "custom-postgresql-15"
  family = "postgres15"

  parameter {
    name  = "max_connections"
    value = "100"
  }
}

resource "aws_security_group" "rds_sg" {
  name        = "rds-security-group"
  description = "Security group for RDS instance"

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Adjust this to restrict access
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_db_instance" "postgresql" {
  identifier              = "my-postgresql-db"
  engine                  = "postgres"
  engine_version          = "15"
  instance_class          = "db.t3.medium"
  allocated_storage       = 50
  storage_encrypted       = true
  kms_key_id              = aws_kms_key.rds_encryption.arn
  db_subnet_group_name    = "my-db-subnet-group" # Ensure this exists
  vpc_security_group_ids  = [aws_security_group.rds_sg.id]
  multi_az                = true
  parameter_group_name    = aws_db_parameter_group.postgresql_parameters.name
  username                = "admin"
  password                = "securepassword" # Use a more secure method in production
  skip_final_snapshot     = true
}
```
</iac_template>

This configuration sets up a PostgreSQL RDS instance with the specified requirements, including encryption, a custom parameter group, and a security group to manage access. Adjust the `db_subnet_group_name` and security group ingress rules as needed for your specific VPC setup.