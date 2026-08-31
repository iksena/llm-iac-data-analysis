resource "aws_security_group" "default" {
    name = "Default-sec"
    description = "Allow All From Local Network"
    vpc_id = "${aws_vpc.main-vpc.id}"
    ingress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["${var.aws_vpc_cidr}"]
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_security_group" "ssh" {
    name = "SSH-sec"
    description = "Allow SSH From Cybird IP"
    vpc_id = "${aws_vpc.main-vpc.id}"
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = [
            "${var.cybird_ips.1}",
            "${var.cybird_ips.2}",
            "${var.cybird_ips.3}"
        ]
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_security_group" "http" {
    name = "HTTP-sec"
    description = "Allow HTTP"
    vpc_id = "${aws_vpc.main-vpc.id}"
    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}