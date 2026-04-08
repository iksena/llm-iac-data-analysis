resource "aws_subnet" "example" {
  vpc_id     = aws_vpc.example.id
  cidr_block = "10.0.1.0/24"
}

resource "aws_vpc" "example" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_fsx_backup" "example" {
  file_system_id = aws_fsx_lustre_file_system.example.id
}

resource "aws_fsx_lustre_file_system" "example" {
  storage_capacity            = 1200
  subnet_ids                  = [aws_subnet.example.id]
  deployment_type             = "PERSISTENT_1"
  per_unit_storage_throughput = 50
}