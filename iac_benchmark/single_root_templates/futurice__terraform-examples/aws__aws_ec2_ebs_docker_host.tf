# ── main.tf ────────────────────────────────────
# Create the main EC2 instance
# https://www.terraform.io/docs/providers/aws/r/instance.html
resource "aws_instance" "this" {
  instance_type          = "${var.instance_type}"
  ami                    = "${var.instance_ami}"
  availability_zone      = "${local.availability_zone}"
  key_name               = "${aws_key_pair.this.id}"                            # the name of the SSH keypair to use for provisioning
  vpc_security_group_ids = ["${aws_security_group.this.id}"]
  subnet_id              = "${data.aws_subnet.this.id}"
  user_data              = "${sha1(local.reprovision_trigger)}"                 # this value isn't used by the EC2 instance, but its change will trigger re-creation of the resource
  tags                   = "${merge(var.tags, map("Name", "${var.hostname}"))}"
  volume_tags            = "${merge(var.tags, map("Name", "${var.hostname}"))}" # give the root EBS volume a name (+ other possible tags) that makes it easier to identify as belonging to this host

  root_block_device {
    volume_size = "${var.root_volume_size}"
  }

  connection {
    user        = "${var.ssh_username}"
    private_key = "${file("${var.ssh_private_key_path}")}"
    agent       = false                                    # don't use SSH agent because we have the private key right here
  }

  provisioner "remote-exec" {
    inline = [
      "sudo hostnamectl set-hostname ${var.hostname}",
      "echo 127.0.0.1 ${var.hostname} | sudo tee -a /etc/hosts", # https://askubuntu.com/a/59517
    ]
  }

  provisioner "remote-exec" {
    script = "${path.module}/provision-docker.sh"
  }

  provisioner "file" {
    source      = "${path.module}/provision-swap.sh"
    destination = "/home/${var.ssh_username}/provision-swap.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "sh /home/${var.ssh_username}/provision-swap.sh ${var.swap_file_size} ${var.swap_swappiness}",
      "rm /home/${var.ssh_username}/provision-swap.sh",
    ]
  }
}

# Attach the separate data volume to the instance, if so configured

resource "aws_volume_attachment" "this" {
  count       = "${var.data_volume_id == "" ? 0 : 1}" # only create this resource if an external EBS data volume was provided
  device_name = "/dev/xvdh"                           # note: this depends on the AMI, and can't be arbitrarily changed
  instance_id = "${aws_instance.this.id}"
  volume_id   = "${var.data_volume_id}"
}

resource "null_resource" "provisioners" {
  count      = "${var.data_volume_id == "" ? 0 : 1}" # only create this resource if an external EBS data volume was provided
  depends_on = ["aws_volume_attachment.this"]        # because we depend on the EBS volume being available

  connection {
    host        = "${aws_instance.this.public_ip}"
    user        = "${var.ssh_username}"
    private_key = "${file("${var.ssh_private_key_path}")}"
    agent       = false                                    # don't use SSH agent because we have the private key right here
  }

  # When creating the attachment
  provisioner "remote-exec" {
    script = "${path.module}/provision-ebs.sh"
  }

  # When tearing down the attachment
  provisioner "remote-exec" {
    when   = "destroy"
    inline = ["sudo umount -v ${aws_volume_attachment.this.device_name}"]
  }
}


# ── variables.tf ────────────────────────────────────
# Whenever the contents of this block changes, the host should be re-provisioned
locals {
  reprovision_trigger = <<EOF
    # Trigger reprovision on variable changes:
    ${var.hostname}
    ${var.ssh_username}
    ${var.ssh_private_key_path}
    ${var.ssh_public_key_path}
    ${var.swap_file_size}
    ${var.swap_swappiness}
    ${var.reprovision_trigger}
    # Trigger reprovision on file changes:
    ${file("${path.module}/provision-docker.sh")}
    ${file("${path.module}/provision-ebs.sh")}
    ${file("${path.module}/provision-swap.sh")}
  EOF
}

locals {
  availability_zone = "${data.aws_availability_zones.this.names[0]}" # use the first available AZ in the region (AWS ensures this is constant per user)
}

variable "hostname" {
  description = "Hostname by which this service is identified in metrics, logs etc"
  default     = "aws-ec2-ebs-docker-host"
}

variable "instance_type" {
  description = "See https://aws.amazon.com/ec2/instance-types/ for options; for example, typical values for small workloads are `\"t2.nano\"`, `\"t2.micro\"`, `\"t2.small\"`, `\"t2.medium\"`, and `\"t2.large\"`"
  default     = "t2.micro"
}

variable "instance_ami" {
  description = "See https://cloud-images.ubuntu.com/locator/ec2/ for options"
  default     = "ami-0bdf93799014acdc4"                                        # Ubuntu 18.04.1 LTS (eu-central-1, amd64, hvm:ebs-ssd, 2018-09-12)
}

variable "ssh_private_key_path" {
  description = "SSH private key file path, relative to Terraform project root"
  default     = "ssh.private.key"
}

variable "ssh_public_key_path" {
  description = "SSH public key file path, relative to Terraform project root"
  default     = "ssh.public.key"
}

variable "ssh_username" {
  description = "Default username built into the AMI (see 'instance_ami')"
  default     = "ubuntu"
}

variable "vpc_id" {
  description = "ID of the VPC our host should join; if empty, joins your Default VPC"
  default     = ""
}

variable "reprovision_trigger" {
  description = "An arbitrary string value; when this value changes, the host needs to be reprovisioned"
  default     = ""
}

variable "root_volume_size" {
  description = "Size (in GiB) of the EBS volume that will be created and mounted as the root fs for the host"
  default     = 8                                                                                              # this matches the other defaults, including the selected AMI
}

variable "data_volume_id" {
  description = "The ID of the EBS volume to mount as `/data`"
  default     = ""                                             # empty string means no EBS volume will be attached
}

variable "swap_file_size" {
  description = "Size of the swap file allocated on the root volume"
  default     = "512M"                                               # a smallish default to match default 8 GiB EBS root volume
}

variable "swap_swappiness" {
  description = "Swappiness value provided when creating the swap file"
  default     = "10"                                                    # 100 will make the host use the swap as much as possible, 0 will make it use only in case of emergency
}

variable "allow_incoming_http" {
  description = "Whether to allow incoming HTTP traffic on the host security group"
  default     = false
}

variable "allow_incoming_https" {
  description = "Whether to allow incoming HTTPS traffic on the host security group"
  default     = false
}

variable "allow_incoming_dns" {
  description = "Whether to allow incoming DNS traffic on the host security group"
  default     = false
}

variable "tags" {
  description = "AWS Tags to add to all resources created (where possible); see https://aws.amazon.com/answers/account-management/aws-tagging-strategies/"
  type        = "map"
  default     = {}
}


# ── outputs.tf ────────────────────────────────────
output "hostname" {
  description = "Hostname by which this service is identified in metrics, logs etc"
  value       = "${var.hostname}"
}

output "public_ip" {
  description = "Public IP address assigned to the host by EC2"
  value       = "${aws_instance.this.public_ip}"
}

output "instance_id" {
  description = "AWS ID for the EC2 instance used"
  value       = "${aws_instance.this.id}"
}

output "availability_zone" {
  description = "AWS Availability Zone in which the EC2 instance was created"
  value       = "${local.availability_zone}"
}

output "ssh_username" {
  description = "Username that can be used to access the EC2 instance over SSH"
  value       = "${var.ssh_username}"
}

output "ssh_private_key_path" {
  description = "Path to SSH private key that can be used to access the EC2 instance"
  value       = "${var.ssh_private_key_path}"
}

output "ssh_private_key" {
  description = "SSH private key that can be used to access the EC2 instance"
  value       = "${file("${var.ssh_private_key_path}")}"
}

output "security_group_id" {
  description = "Security Group ID, for attaching additional security rules externally"
  value       = "${aws_security_group.this.id}"
}


# ── data.tf ────────────────────────────────────
# Access data about available availability zones in the current region
data "aws_availability_zones" "this" {}

# Retrieve info about the VPC this host should join

data "aws_vpc" "this" {
  default = "${var.vpc_id == "" ? true : false}"
  id      = "${var.vpc_id}"
}

data "aws_subnet" "this" {
  vpc_id            = "${data.aws_vpc.this.id}"
  availability_zone = "${local.availability_zone}"
}


# ── security.tf ────────────────────────────────────
# Create an SSH key pair for accessing the EC2 instance
resource "aws_key_pair" "this" {
  public_key = "${file("${var.ssh_public_key_path}")}"
}

# Create our default security group to access the instance, over specific protocols
resource "aws_security_group" "this" {
  vpc_id = "${data.aws_vpc.this.id}"
  tags   = "${merge(var.tags, map("Name", "${var.hostname}"))}"
}

# Incoming SSH & outgoing ANY needs to be allowed for provisioning to work

resource "aws_security_group_rule" "outgoing_any" {
  security_group_id = "${aws_security_group.this.id}"
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "incoming_ssh" {
  security_group_id = "${aws_security_group.this.id}"
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

# The rest of the security rules are opt-in

resource "aws_security_group_rule" "incoming_http" {
  count             = "${var.allow_incoming_http ? 1 : 0}"
  security_group_id = "${aws_security_group.this.id}"
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "incoming_https" {
  count             = "${var.allow_incoming_https ? 1 : 0}"
  security_group_id = "${aws_security_group.this.id}"
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "incoming_dns_tcp" {
  count             = "${var.allow_incoming_dns ? 1 : 0}"
  security_group_id = "${aws_security_group.this.id}"
  type              = "ingress"
  from_port         = 53
  to_port           = 53
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "incoming_dns_udp" {
  count             = "${var.allow_incoming_dns ? 1 : 0}"
  security_group_id = "${aws_security_group.this.id}"
  type              = "ingress"
  from_port         = 53
  to_port           = 53
  protocol          = "udp"
  cidr_blocks       = ["0.0.0.0/0"]
}
