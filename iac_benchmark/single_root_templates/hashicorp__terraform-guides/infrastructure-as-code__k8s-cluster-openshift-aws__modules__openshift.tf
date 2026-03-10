# ── 00-variables.tf ────────────────────────────────────
variable "region" {
  description = "The region to deploy the cluster in, e.g: us-east-1."
}

variable "amisize" {
  description = "The size of the cluster nodes, e.g: t2.large. Note that OpenShift will not run on anything smaller than t2.large"
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC, e.g: 10.0.0.0/16"
}

variable "subnetaz" {
  description = "The AZ for the public subnet, e.g: us-east-1a"
  type = "map"
}

variable "subnet_cidr" {
  description = "The CIDR block for the public subnet, e.g: 10.0.1.0/24"
}

variable "key_name" {
  description = "The name of the key to user for ssh access"
}

variable "private_key_data" {
  description = "contents of the private key"
}

variable "name_tag_prefix" {
  description = "prefixed to Name tag added to EC2 instances and other AWS resources"
}

variable "owner" {
  description = "value set on EC2 owner tag"
}

variable "ttl" {
  description = "value set on EC2 TTL tag. -1 means forever. Measured in hours."
}


# ── 01-amis.tf ────────────────────────────────────
# Define the RHEL 7.2 AMI by:
# RedHat, Latest, x86_64, EBS, HVM, RHEL 7.5
data "aws_ami" "rhel7_5" {
  most_recent = true

  owners = ["309956199498"] // Red Hat's account ID.

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "name"
    values = ["RHEL-7.5*"]
  }
}

# Define an Amazon Linux AMI.
data "aws_ami" "amazonlinux" {
  most_recent = true

  owners = ["137112412989"]

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "name"
    values = ["amzn-ami-hvm-2018.03.0.20190611-x86_64-gp2"]
  }
}


# ── 02-vpc.tf ────────────────────────────────────
//  Define the VPC.
resource "aws_vpc" "openshift" {
  cidr_block           = "${var.vpc_cidr}"
  enable_dns_hostnames = true

  tags {
    Name    = "${var.name_tag_prefix}-openshift VPC"
    Project = "openshift"
  }
}

//  Create an Internet Gateway for the VPC.
resource "aws_internet_gateway" "openshift" {
  vpc_id = "${aws_vpc.openshift.id}"

  tags {
    Name    = "${var.name_tag_prefix}-openshift IGW"
    Project = "openshift"
  }
}

//  Create a public subnet.
resource "aws_subnet" "public-subnet" {
  vpc_id                  = "${aws_vpc.openshift.id}"
  cidr_block              = "${var.subnet_cidr}"
  availability_zone       = "${lookup(var.subnetaz, var.region)}"
  map_public_ip_on_launch = true
  depends_on              = ["aws_internet_gateway.openshift"]

  tags {
    Name    = "${var.name_tag_prefix}-openshift Public Subnet"
    Project = "openshift"
  }
}

//  Create a route table allowing all addresses access to the IGW.
resource "aws_route_table" "public" {
  vpc_id = "${aws_vpc.openshift.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.openshift.id}"
  }

  tags {
    Name    = "${var.name_tag_prefix}-openshift Public Route Table"
    Project = "openshift"
  }
}

//  Now associate the route table with the public subnet - giving
//  all public subnet instances access to the internet.
resource "aws_route_table_association" "public-subnet" {
  subnet_id      = "${aws_subnet.public-subnet.id}"
  route_table_id = "${aws_route_table.public.id}"
}


# ── 03-security-groups.tf ────────────────────────────────────
//  This security group allows intra-node communication on all ports with all
//  protocols.
resource "aws_security_group" "openshift-vpc" {
  name        = "${var.name_tag_prefix}-openshift-vpc"
  description = "Default security group that allows all instances in the VPC to talk to each other over any port and protocol."
  vpc_id      = "${aws_vpc.openshift.id}"

  ingress {
    from_port = "0"
    to_port   = "0"
    protocol  = "-1"
    self      = true
  }

  egress {
    from_port = "0"
    to_port   = "0"
    protocol  = "-1"
    self      = true
  }

  tags {
    Name    = "OpenShift Internal VPC"
    Project = "openshift"
  }
}

//  This security group allows public ingress to the instances for HTTP, HTTPS
//  and common HTTP/S proxy ports.
resource "aws_security_group" "openshift-public-ingress" {
  name        = "${var.name_tag_prefix}-openshift-public-ingress"
  description = "Security group that allows public ingress to instances, HTTP, HTTPS and more."
  vpc_id      = "${aws_vpc.openshift.id}"

  //  HTTP
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  //  HTTP Proxy
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  //  HTTPS
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  //  HTTPS Proxy
  ingress {
    from_port   = 8443
    to_port     = 8443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name    = "OpenShift Public Access"
    Project = "openshift"
  }
}

//  This security group allows public egress from the instances for HTTP and
//  HTTPS, which is needed for yum updates, git access etc etc.
// Also for Vault on port 8200
resource "aws_security_group" "openshift-public-egress" {
  name        = "${var.name_tag_prefix}-openshift-public-egress"
  description = "Security group that allows egress to the internet for instances over HTTP and HTTPS."
  vpc_id      = "${aws_vpc.openshift.id}"

  //  HTTP
  egress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  //  HTTPS
  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  //  Vault
  egress {
    from_port   = 8200
    to_port     = 8200
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name    = "OpenShift Public Access"
    Project = "openshift"
  }
}

//  Security group which allows SSH access to a host. Used for the bastion.
resource "aws_security_group" "openshift-ssh" {
  name        = "${var.name_tag_prefix}-openshift-ssh"
  description = "Security group that allows public ingress over SSH."
  vpc_id      = "${aws_vpc.openshift.id}"

  //  SSH
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name    = "OpenShift SSH Access"
    Project = "openshift"
  }
}


# ── 04-roles.tf ────────────────────────────────────
//  Create a role which OpenShift instances will assume.
//  This role has a policy saying it can be assumed by ec2
//  instances.
resource "aws_iam_role" "openshift-instance-role" {
  name = "${var.name_tag_prefix}-openshift-instance-role"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
                "Service": "ec2.amazonaws.com"
            },
            "Effect": "Allow",
            "Sid": ""
        }
    ]
}
EOF
}

//  This policy allows an instance to forward logs to CloudWatch, and
//  create the Log Stream or Log Group if it doesn't exist.
resource "aws_iam_policy" "openshift-policy-forward-logs" {
  name        = "${var.name_tag_prefix}-openshift-instance-forward-logs"
  path        = "/"
  description = "Allows an instance to forward logs to CloudWatch"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "logs:DescribeLogStreams"
    ],
      "Resource": [
        "arn:aws:logs:*:*:*"
    ]
  }
 ]
}
EOF
}


//  Attach the policies to the role.
resource "aws_iam_policy_attachment" "openshift-attachment-forward-logs" {
  name       = "${var.name_tag_prefix}-openshift-attachment-forward-logs"
  roles      = ["${aws_iam_role.openshift-instance-role.name}"]
  policy_arn = "${aws_iam_policy.openshift-policy-forward-logs.arn}"
}

//  Create a instance profile for the role.
resource "aws_iam_instance_profile" "openshift-instance-profile" {
  name  = "${var.name_tag_prefix}-openshift-instance-profile"
  role = "${aws_iam_role.openshift-instance-role.name}"
}


# ── 05-nodes.tf ────────────────────────────────────
//  Create the master userdata script.
data "template_file" "setup-master" {
  template = "${file("${path.module}/files/setup-master.sh")}"

  //  Currently, no vars needed.
}

//  Launch configuration for the master
resource "aws_instance" "master" {
  ami                  = "${data.aws_ami.rhel7_5.id}"
  # Master nodes require at least 16GB of memory.
  instance_type        = "m4.xlarge"
  subnet_id            = "${aws_subnet.public-subnet.id}"
  iam_instance_profile = "${aws_iam_instance_profile.openshift-instance-profile.id}"
  user_data            = "${data.template_file.setup-master.rendered}"

  vpc_security_group_ids = [
    "${aws_security_group.openshift-vpc.id}",
    "${aws_security_group.openshift-public-ingress.id}",
    "${aws_security_group.openshift-public-egress.id}",
  ]

  //  We need at least 30GB for OpenShift, let's be greedy...
  root_block_device {
    volume_size = 50
  }

  # Storage for Docker, see:
  # https://docs.openshift.org/latest/install_config/install/host_preparation.html#configuring-docker-storage
  ebs_block_device {
    device_name = "/dev/sdf"
    volume_size = 80
  }

  key_name = "${var.key_name}"

  tags {
    Name    = "${var.name_tag_prefix} OpenShift Master"
    Project = "openshift"
    owner = "${var.owner}"
    TTL = "${var.ttl}"
  }
}

//  Create the node userdata script.
data "template_file" "setup-node" {
  template = "${file("${path.module}/files/setup-node.sh")}"

  //  Currently, no vars needed.
}

//  Create the two nodes.
resource "aws_instance" "node1" {
  ami                  = "${data.aws_ami.rhel7_5.id}"
  instance_type        = "${var.amisize}"
  subnet_id            = "${aws_subnet.public-subnet.id}"
  iam_instance_profile = "${aws_iam_instance_profile.openshift-instance-profile.id}"
  user_data            = "${data.template_file.setup-node.rendered}"

  vpc_security_group_ids = [
    "${aws_security_group.openshift-vpc.id}",
    "${aws_security_group.openshift-public-ingress.id}",
    "${aws_security_group.openshift-public-egress.id}",
  ]

  //  We need at least 30GB for OpenShift, let's be greedy...
  root_block_device {
    volume_size = 50
  }

  # Storage for Docker, see:
  # https://docs.openshift.org/latest/install_config/install/host_preparation.html#configuring-docker-storage
  ebs_block_device {
    device_name = "/dev/sdf"
    volume_size = 80
  }

  key_name = "${var.key_name}"

  tags {
    Name    = "${var.name_tag_prefix} OpenShift Node 1"
    Project = "openshift"
    owner = "${var.owner}"
    TTL = "${var.ttl}"
  }
}


# ── 06-dns.tf ────────────────────────────────────
//  Notes: We could make the internal domain a variable, but not sure it is
//  really necessary.

//  Create the internal DNS.
resource "aws_route53_zone" "internal" {
  name = "${var.name_tag_prefix}-openshift.local"
  comment = "OpenShift Cluster Internal DNS"
  vpc {
    vpc_id = "${aws_vpc.openshift.id}"
  }
  tags {
    Name    = "OpenShift Internal DNS"
    Project = "openshift"
  }
}

//  Routes for 'master' and 'node1'.
resource "aws_route53_record" "master-a-record" {
    zone_id = "${aws_route53_zone.internal.zone_id}"
    name = "master.${var.name_tag_prefix}-openshift.local"
    type = "A"
    ttl  = 300
    records = [
        "${aws_instance.master.private_ip}"
    ]
}
resource "aws_route53_record" "node1-a-record" {
    zone_id = "${aws_route53_zone.internal.zone_id}"
    name = "node1.${var.name_tag_prefix}-openshift.local"
    type = "A"
    ttl  = 300
    records = [
        "${aws_instance.node1.private_ip}"
    ]
}


# ── 07-bastion.tf ────────────────────────────────────
data "external" "delay" {
  program = ["./modules/openshift/delay-aws"]

  depends_on = ["aws_instance.master", "aws_instance.node1"]
}

data "template_file" "inventory" {
  template = "${file("${path.module}/files/install-from-bastion.sh")}"

  vars {
    wait = "${data.external.delay.result["wait"]}"
    master_ip = "${aws_instance.master.public_ip}"
    private_key = "${var.private_key_data}"
    name_tag_prefix = "${var.name_tag_prefix}"
    region = "${var.region}"
  }
}

resource "local_file" "inventory" {
  content = "${data.template_file.inventory.rendered}"
  filename = "${path.module}/files/install-openshift.sh"
}

//  Launch configuration for the bastion.
resource "aws_instance" "bastion" {
  ami                  = "${data.aws_ami.amazonlinux.id}"
  instance_type        = "t2.micro"
  subnet_id            = "${aws_subnet.public-subnet.id}"

  vpc_security_group_ids = [
    "${aws_security_group.openshift-vpc.id}",
    "${aws_security_group.openshift-ssh.id}",
    "${aws_security_group.openshift-public-egress.id}",
  ]

  key_name = "${var.key_name}"

  tags {
    Name    = "${var.name_tag_prefix} OpenShift Bastion"
    Project = "openshift"
    owner = "${var.owner}"
    TTL = "${var.ttl}"
  }

  provisioner "remote-exec" {
    script = "${local_file.inventory.filename}"
    on_failure = "continue"
    connection {
      type     = "ssh"
      user     = "ec2-user"
      private_key = "${var.private_key_data}"
    }
  }
}


# ── 08-outputs.tf ────────────────────────────────────
//  Output some useful variables for quick SSH access etc.
output "master_public_dns" {
  value = "${aws_instance.master.public_dns}"
}
output "master_public_ip" {
  value = "${aws_instance.master.public_ip}"
}
output "master_private_dns" {
  value = "${aws_instance.master.private_dns}"
}
output "master_private_ip" {
  value = "${aws_instance.master.private_ip}"
}

output "node1_public_dns" {
  value = "${aws_instance.node1.public_dns}"
}
output "node1_public_ip" {
  value = "${aws_instance.node1.public_ip}"
}
output "node1_private_dns" {
  value = "${aws_instance.node1.private_dns}"
}
output "node1_private_ip" {
  value = "${aws_instance.node1.private_ip}"
}

output "bastion_public_dns" {
  value = "${aws_instance.bastion.public_dns}"
}
output "bastion_public_ip" {
  value = "${aws_instance.bastion.public_ip}"
}
output "bastion_private_dns" {
  value = "${aws_instance.bastion.private_dns}"
}
output "bastion_private_ip" {
  value = "${aws_instance.bastion.private_ip}"
}
