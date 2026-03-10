# ── main.tf ────────────────────────────────────
# Data source: query the list of availability zones
data "aws_availability_zones" "all" {}

# Data source: DB remote state
data "terraform_remote_state" "db" {
  backend = "s3"
  
  config {
	bucket = "${var.db_remote_state_bucket}"
	key    = "${var.db_remote_state_key}"
	region = "eu-west-1"
  }
}

# Data source: Template file
data "template_file" "user_data" {
  count = "${1 - var.enable_new_user_data}"

  template = "${file("${path.module}/user-data.sh")}"
  
  vars {
    server_port = "${var.server_port}"
	db_address  = "${data.terraform_remote_state.db.address}"
	db_port     = "${data.terraform_remote_state.db.port}"
  }
}

# Data source: Template file
data "template_file" "user_data_new" {
  count = "${var.enable_new_user_data}"
  
  template = "${file("${path.module}/user-data-new.sh")}"
  
  vars {
    server_port = "${var.server_port}"
  }
}

# Create a Security Group for an EC2 instance
resource "aws_security_group" "instance" {
  name = "${var.cluster_name}-instance"
  
  lifecycle {
    create_before_destroy = true
  }
}

# Create a Security Group Rule
resource "aws_security_group_rule" "allow_server_http_inbound" {
  type = "ingress"
  security_group_id = "${aws_security_group.instance.id}"
  
  from_port	  = "${var.server_port}"
  to_port	  = "${var.server_port}"
  protocol	  = "tcp"
  cidr_blocks = ["0.0.0.0/0"]

}

# Create a Security Group for an ELB
resource "aws_security_group" "elb" {
  name = "${var.cluster_name}-elb"
}

# Create a Security Group Rule, inbound
resource "aws_security_group_rule" "allow_http_inbound" {
  type              = "ingress"
  security_group_id = "${aws_security_group.elb.id}"
  
  from_port	  = 80
  to_port	  = 80
  protocol	  = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}

# Create a Security Group Rule, outbound
resource "aws_security_group_rule" "allow_all_outbound" {
  type              = "egress"
  security_group_id = "${aws_security_group.elb.id}"
  
  from_port	  = 0
  to_port	  = 0
  protocol	  = "-1"
  cidr_blocks = ["0.0.0.0/0"]
}

# Create a Launch Configuration
resource "aws_launch_configuration" "example" {
  image_id		  = "ami-785db401"
  instance_type   = "${var.instance_type}"
  security_groups = ["${aws_security_group.instance.id}"]
  
  user_data       = "${element(
    concat(data.template_file.user_data.*.rendered,
           data.template_file.user_data_new.*.rendered),
           0)}"
  
  lifecycle {
    create_before_destroy = true
  }
}

# Create an Autoscaling Group
resource "aws_autoscaling_group" "example" {
  launch_configuration = "${aws_launch_configuration.example.id}"
  availability_zones   = ["${data.aws_availability_zones.all.names}"]
  load_balancers       = ["${aws_elb.example.name}"]
  health_check_type    = "ELB"
  
  min_size = "${var.min_size}"
  max_size = "${var.max_size}"
  
  tag {
    key                 = "Name"
    value               = "${var.cluster_name}"
    propagate_at_launch = true
  }
}

# Create an ELB
resource "aws_elb" "example" {
  name               = "${var.cluster_name}"
  availability_zones = ["${data.aws_availability_zones.all.names}"]
  security_groups    = ["${aws_security_group.elb.id}"]
  
  listener {
    lb_port           = 80
    lb_protocol       = "http"
    instance_port     = "${var.server_port}"
    instance_protocol = "http"
  }
  
  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    interval            = 30
    target              = "HTTP:${var.server_port}/"
  }
}

# Create an Autoscaling Schedule
resource "aws_autoscaling_schedule" "scale_out_during_business_hours" {
  count = "${var.enable_autoscaling}"

  scheduled_action_name = "scale-out-during-business-hours"
  min_size              = 2
  max_size              = 10
  desired_capacity      = 10
  recurrence            = "0 9 * * *"
  
  autoscaling_group_name = "${aws_autoscaling_group.example.name}"
}

# Create an Autoscaling Schedule
resource "aws_autoscaling_schedule" "scale_in_at_night" {
  count = "${var.enable_autoscaling}"
  
  scheduled_action_name = "scale-in-at-night"
  min_size              = 2
  max_size              = 10
  desired_capacity      = 2
  recurrence            = "0 17 * * *"

  autoscaling_group_name = "${aws_autoscaling_group.example.name}"
}

# Create an Autoscaling Metric Alarm
resource "aws_cloudwatch_metric_alarm" "high_cpu_utilisation" {
  alarm_name  = "${var.cluster_name}-high-cpu-utilisation"
  namespace   = "AWS/EC2"
  metric_name = "CPUUtilization"
  
  dimensions = {
    AutoScalingGroupName = "${aws_autoscaling_group.example.name}"
  }
  
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  period              = 300
  statistic           = "Average"
  threshold           = 90
  unit                = "Percent"
}

# Create an Autoscaling Metric Alarm
resource "aws_cloudwatch_metric_alarm" "low_cpu_credit_balance" {
  count = "${format("%.1s", var.instance_type) == "t" ? 1 : 0}"
  
  alarm_name  = "${var.cluster_name}-low-cpu-credit-balance"
  namespace   = "AWS/EC2"
  metric_name = "CPUCreditBalance"
  
  dimensions = {
    AutoScalingGroupName = "${aws_autoscaling_group.example.name}"
  }
  
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 1
  period              = 300
  statistic           = "Minimum"
  threshold           = 10
  unit                = "Count"
}


# ── outputs.tf ────────────────────────────────────
# Output variable: DNS Name of ELB
output "elb_dns_name" {
  value = "${aws_elb.example.dns_name}"
}

# Output variable: Auto Scaling Group name
output "asg_name" {
  value = "${aws_autoscaling_group.example.name}"
}

# Output variable: ELB Security Group Id
output "elb_security_group_id" {
  value = "${aws_security_group.elb.id}"
}


# ── vars.tf ────────────────────────────────────
# Input variable: server port
variable "server_port" {
  description = "The port the server will use for HTTP requests"
  default = "8080"
}

# Input variable: Cluster name
variable "cluster_name" {
  description = "The name to use for all the cluster resources"
}

# Input variable: DB remote state bucket name
variable "db_remote_state_bucket" {
  description = "The name of the S3 bucket for the database's remote state"
}

# Input variable: DB remote state bucket key
variable "db_remote_state_key" {
  description = "The path for database's remote state in S3"
}

# Input variable: Instance type
variable "instance_type" {
  description = "The type of EC2 Instances to run (e.g. t2.micro)"
}

# Input variable: Instance min size
variable "min_size" {
  description = "The minimum number of EC2 Instances in the ASG"
}

# Input variable: Instance max size
variable "max_size" {
  description = "The maximum number of EC2 Instances in the ASG"
}

# Input variable: Enable Autoscaling
variable "enable_autoscaling" {
  description = "If set to true, enable autoscaling"

}

# Input variable: Enable new user data
variable "enable_new_user_data" {
  description = "If set to true, use the new User Data script"
}
