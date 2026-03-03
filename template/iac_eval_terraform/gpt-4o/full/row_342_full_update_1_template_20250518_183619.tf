The Terraform program will set up an AWS environment with the following components:

1. **VPC**: A main Virtual Private Cloud (VPC) to host the infrastructure.
2. **Subnets**: Two subnets distributed across different availability zones within the specified region.
3. **Security Group**: A security group configured to allow inbound access to the PostgreSQL database on port 5432.
4. **RDS Instance**: A PostgreSQL RDS instance with the following specifications:
   - Instance class: `db.t4g.micro`
   - Storage: 200 GB of `gp2` type
   - Publicly accessible
   - Linked to the created subnets and security group
5. **Outputs**: The database endpoint will be outputted for connectivity purposes.

The configuration will use the AWS provider and will be set in a valid AWS region.

```hcl
<iac_template>
provider "aws" {
  region = "us-west-2"
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "subnet_a" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-west-2a"
  map_public_ip_on_launch = true
}

resource "aws_subnet" "subnet_b" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "us-west-2b"
  map_public_ip_on_launch = true
}

resource "aws_security_group" "db_access" {
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 5432
    to_port     = 5432
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

resource "aws_db_subnet_group" "main" {
  name       = "main-subnet-group"
  subnet_ids = [aws_subnet.subnet_a.id, aws_subnet.subnet_b.id]
}

resource "aws_db_instance" "postgres" {
  allocated_storage    = 200
  storage_type         = "gp2"
  engine               = "postgres"
  engine_version       = "15.3"
  instance_class       = "db.t4g.micro"
  name                 = "mydatabase"
  username             = "admin"
  password             = "password123"
  publicly_accessible  = true
  vpc_security_group_ids = [aws_security_group.db_access.id]
  db_subnet_group_name = aws_db_subnet_group.main.name
  skip_final_snapshot  = true
}

output "db_endpoint" {
  value = aws_db_instance.postgres.endpoint
}
</iac_template>
```