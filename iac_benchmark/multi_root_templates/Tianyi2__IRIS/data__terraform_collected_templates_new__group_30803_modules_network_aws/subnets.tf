resource "aws_subnet" "public_subnet" {
    vpc_id = aws_vpc.vpc.id

    cidr_block = var.public_subnet_cidr
    availability_zone = var.availability_zone

    tags = {
        Name = "${var.env_name}-public-subnet"
    }
}


resource "aws_subnet" "private_subnet" {
    vpc_id = aws_vpc.vpc.id

    cidr_block = var.private_subnet_cidr
    availability_zone = var.availability_zone

    tags = {
        Name = "${var.env_name}-private-subnet"
    }
}
