The Terraform program will set up an AWS environment with the following components:

1. **VPC**: A Virtual Private Cloud to host the network resources.
2. **Subnets**: Two subnets will be created in different availability zones within the specified region.
3. **Security Group**: A security group will be configured to allow inbound access to the MySQL database on port 3306.
4. **RDS Instance**: A MySQL RDS instance with version 5.7, 500 GB of allocated storage, and public accessibility enabled. The instance will be associated with the created subnets and security group.
5. **Outputs**: The database endpoint will be outputted for connectivity purposes.

The configuration will use the AWS provider and specify a valid region. IAM roles will be created as needed to allow the RDS instance to function correctly.

```hcl
<iac_template>
provider "aws" {
  region = "us-west-2"
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "subnet_a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-west-2a"
}

resource "aws_subnet" "subnet_b" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-west-2b"
}

resource "aws_security_group" "db_access" {
  vpc_id = aws_vpc.main.id

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

resource "aws_db_subnet_group" "main" {
  name       = "main-subnet-group"
  subnet_ids = [aws_subnet.subnet_a.id, aws_subnet.subnet_b.id]
}

resource "aws_db_instance" "mysql" {
  allocated_storage    = 500
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t3.medium"
  name                 = "mydb"
  username             = "admin"
  password             = "password123"
  publicly_accessible  = true
  vpc_security_group_ids = [aws_security_group.db_access.id]
  db_subnet_group_name = aws_db_subnet_group.main.name
  skip_final_snapshot  = true
}

output "db_endpoint" {
  value = aws_db_instance.mysql.endpoint
}
</iac_template>
```