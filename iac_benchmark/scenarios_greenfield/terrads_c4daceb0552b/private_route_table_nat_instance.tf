// Only with has_nat_instance = true

// Nat AMI

data "aws_ami" "nat_instance" {
  count       = var.has_nat_instance ? 1 : 0
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn-ami-vpc-nat-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["137112412989"] # Amazon
}


// Nat Instance

resource "aws_instance" "nat_a" {
    ami = "${ data.aws_ami.nat_instance[0].id}"
    availability_zone = "${var.region_az[0]}"
    instance_type = "m1.small"
    // key_name = "${var.aws_key_name}"
    vpc_security_group_ids = ["${aws_security_group.nat[0].id}"]
    subnet_id = "${aws_subnet.public_a.id}"
    associate_public_ip_address = true
    source_dest_check = false
    tags = merge ({
        Name = "${var.name}_nat_instance_${var.region_az[0]}"
    },var.tags)
    count = "${var.has_nat_instance?1:0}"
}

resource "aws_instance" "nat_b" {
    ami = "${ data.aws_ami.nat_instance[0].id}"
    availability_zone = "${var.region_az[1]}"
    instance_type = "m1.small"
    // key_name = "${var.aws_key_name}"
    vpc_security_group_ids = ["${aws_security_group.nat[0].id}"]
    subnet_id = "${aws_subnet.public_b.id}"
    associate_public_ip_address = true
    source_dest_check = false
    tags = merge ({
        Name = "${var.name}_nat_instance_${var.region_az[1]}"
    },var.tags)
    count = "${var.has_nat_instance?1:0}"
}

// Route Tables
resource "aws_route_table" "nat_instance_private_table_a" {
  vpc_id = "${aws_vpc.main.id}"
  route {
        cidr_block = "0.0.0.0/0"
        network_interface_id = "${aws_instance.nat_a[0].primary_network_interface_id}"
  }
  tags = merge ({
    Name = "${var.name}_private_table_a"
    type = "private"
  },var.tags)
  count = "${var.has_nat_instance?1:0}"
}

resource "aws_route_table" "nat_instance_private_table_b" {
  vpc_id = "${aws_vpc.main.id}"
  route {
        cidr_block = "0.0.0.0/0"
        network_interface_id = "${aws_instance.nat_b[0].primary_network_interface_id}"
  }
  tags = merge ({
    Name = "${var.name}_private_table_b"
    type = "private"
  },var.tags)

  count = "${var.has_nat_instance?1:0}"
}

// Association

resource "aws_route_table_association" "nat_instance_route_route_a" {
  subnet_id      = aws_subnet.private_a[0].id
  route_table_id = aws_route_table.nat_instance_private_table_a[0].id
  count = "${var.has_nat_instance?1:0}"
}

resource "aws_route_table_association" "nat_instance_route_route_b" {
  subnet_id      = aws_subnet.private_b[0].id
  route_table_id = aws_route_table.nat_instance_private_table_b[0].id
  count = "${var.has_nat_instance?1:0}"
}

// Security Group

resource "aws_security_group" "nat" {
	name = "nat"
	description = "Allow services from the private subnet through NAT"
	vpc_id = "${aws_vpc.main.id}"
	ingress {
		from_port = 80
		to_port = 80
		protocol = "tcp"
		cidr_blocks = ["0.0.0.0/0"]
	}
	ingress {
		from_port = 443
		to_port = 443
		protocol = "tcp"
		cidr_blocks = ["0.0.0.0/0"]
	}
	ingress {
		from_port = 0
		to_port = 65535
		protocol = "tcp"
		security_groups = ["${aws_default_security_group.default.id}"]
	}
	ingress {
		from_port = 0
		to_port = 65535
		protocol = "udp"
		security_groups = ["${aws_default_security_group.default.id}"]
	}
	egress {
		from_port = 0
		to_port = 0
		protocol = "-1"
		cidr_blocks = ["0.0.0.0/0"]
	}
  tags = merge ({
    Name = "${var.name}_sg_nat"
    type = "private"
  },var.tags)
  count = "${var.has_nat_instance?1:0}"
}
