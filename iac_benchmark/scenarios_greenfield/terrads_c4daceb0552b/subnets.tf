// Public Subnet
resource "aws_subnet" "public_a" {
  vpc_id     = "${aws_vpc.main.id}"
  cidr_block = "${var.cidr_subnets[0]}"
  availability_zone = "${var.region_az[0]}"
  map_public_ip_on_launch = "${var.public_subnet_map_public_ip_on_launch}"
  tags = merge({
    Name = "${var.name}_public_${var.region_az[0]}"
    Type = "public"
    },var.tags)
}

resource "aws_subnet" "public_b" {
  vpc_id     = "${aws_vpc.main.id}"
  cidr_block = "${var.cidr_subnets[1]}"
  availability_zone = "${var.region_az[1]}"
  map_public_ip_on_launch = "${var.public_subnet_map_public_ip_on_launch}"
  tags = merge({
    Name = "${var.name}_public_${var.region_az[1]}"
    Type = "public"
  },var.tags)
}

// Public Subnet Optional

resource "aws_subnet" "public_c" {
  vpc_id     = "${aws_vpc.main.id}"
  cidr_block = "${var.cidr_subnets[2]}"
  availability_zone = "${var.region_az[2]}"
  tags = merge({
    Name = "${var.name}_public_${var.region_az[2]}"
    Type = "public"
  },var.tags)
  count = "${!var.has_private_subnet ? 1 : 0}"
}

resource "aws_subnet" "public_d" {
  vpc_id     = "${aws_vpc.main.id}"
  cidr_block = "${var.cidr_subnets[3]}"
  availability_zone = "${var.region_az[3]}"
  tags = merge({
    Name = "${var.name}_public_${var.region_az[3]}"
    type = "public"
  },var.tags)
  count = "${!var.has_private_subnet ? 1 : 0}"
}

// Private Subnet
resource "aws_subnet" "private_a" {
  vpc_id     = "${aws_vpc.main.id}"
  cidr_block = "${var.cidr_subnets[2]}"
  availability_zone = "${var.region_az[0]}"
  tags = merge({
    Name = "${var.name}_private_${var.region_az[0]}"
    Type = "private"
  },var.tags)
  count = "${var.has_private_subnet ? 1 : 0}"
}

resource "aws_subnet" "private_b" {
  vpc_id     = "${aws_vpc.main.id}"
  cidr_block = "${var.cidr_subnets[3]}"
  availability_zone = "${var.region_az[1]}"
  tags = merge({
    Name = "${var.name}_private_${var.region_az[1]}"
    type = "private"
  },var.tags)
  count = "${var.has_private_subnet ? 1 : 0}"
}
