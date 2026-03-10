# ── awscc_ecs_cluster_lookup_by_region.tf ────────────────────────────────────
# create variable type map call it cluster_name, set default to map of key us-east-1, us-west-2 and us-east-2, for each key, set the value to key + prod
variable "cluster_name" {
  type = map(string)
  default = {
    us-east-1 = "us-east-1-prod"
    us-west-2 = "us-west-2-prod"
    us-east-2 = "us-east-2-prod"
  }
}

# create ecs cluster using AWS CC provider, set the cluster name attribute using lookup function, lookup the var cluster_name map with key as aws region
resource "awscc_ecs_cluster" "this" {
  cluster_name = "${lookup(var.cluster_name, data.aws_region.current.name)}"
}

# data source to get current aws region
data "aws_region" "current" {}

# ── awscc_ecs_cluster_with_container_insights_enabled_p1.tf ────────────────────────────────────
# Create AWS ECS Cluster via the 'awscc' provider

resource "awscc_ecs_cluster" "this" {
  cluster_name = "example_cluster"
  cluster_settings = [{
    name  = "containerInsights"
    value = "enabled"
  }]

  tags = [{
    key   = "Modified By"
    value = "AWSCC"
  }]
}


# ── awscc_ecs_cluster_with_container_insights_enabled_p2.tf ────────────────────────────────────
# Terraform code to create AWS ECS Cluster via the 'awscc' provider

resource "awscc_ecs_cluster" "this" {
  cluster_name = "example_cluster"
  cluster_settings = [{
    name  = "containerInsights"
    value = "enabled"
  }]

  tags = [{
    key   = "Modified By"
    value = "AWSCC"
  }]
}


# ── awscc_ecs_cluster_with_container_insights_enabled_p3.tf ────────────────────────────────────
# Write Terraform configuration that creates AWS ECS Cluster, use awscc provider

resource "awscc_ecs_cluster" "this" {
  cluster_name = "example_cluster"
  cluster_settings = [{
    name  = "containerInsights"
    value = "enabled"
  }]

  tags = [{
    key   = "Modified By"
    value = "AWSCC"
  }]
}


# ── awscc_ecs_service_on_fargate_p1.tf ────────────────────────────────────
# Create AWS ECS Cluster via the 'awscc' provider

data "awscc_ec2_subnet" "subnet" {
  id = "subnet-0000000"
}

resource "awscc_iam_role" "nginx" {
  role_name                   = "ecs_Task_ExecutionRole"
  assume_role_policy_document = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": "sts:AssumeRole",
        "Principal": {
          "Service": "ecs-tasks.amazonaws.com"
        },
        "Effect": "Allow",
        "Sid": ""
      }
    ]
}
  EOF
  managed_policy_arns         = ["arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"]
}

resource "awscc_ecs_service" "nginx" {
  service_name    = "nginx_service"
  cluster         = awscc_ecs_cluster.this.id
  task_definition = aws_ecs_task_definition.nginx.arn
  launch_type     = "FARGATE"
  desired_count   = 1

  network_configuration = {
    awsvpc_configuration = {
      assign_public_ip = "ENABLED"
      subnets          = ["${data.awscc_ec2_subnet.subnet.subnet_id}"]
    }
  }

  tags = [{
    key   = "Modified By"
    value = "AWSCC"
  }]
  depends_on = [awscc_iam_role.nginx]
}


# ── awscc_ecs_service_on_fargate_p2.tf ────────────────────────────────────
# Terraform code to create AWS ECS Cluster via the 'awscc' provider

data "awscc_ec2_subnet" "subnet" {
  id = "subnet-0000000"
}

resource "awscc_iam_role" "nginx" {
  role_name                   = "ecs_Task_ExecutionRole"
  assume_role_policy_document = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": "sts:AssumeRole",
        "Principal": {
          "Service": "ecs-tasks.amazonaws.com"
        },
        "Effect": "Allow",
        "Sid": ""
      }
    ]
}
  EOF
  managed_policy_arns         = ["arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"]
}

resource "awscc_ecs_service" "nginx" {
  service_name    = "nginx_service"
  cluster         = awscc_ecs_cluster.this.id
  task_definition = aws_ecs_task_definition.nginx.arn
  launch_type     = "FARGATE"
  desired_count   = 1

  network_configuration = {
    awsvpc_configuration = {
      assign_public_ip = "ENABLED"
      subnets          = ["${data.awscc_ec2_subnet.subnet.subnet_id}"]
    }
  }

  tags = [{
    key   = "Modified By"
    value = "AWSCC"
  }]
  depends_on = [awscc_iam_role.nginx]
}


# ── awscc_ecs_service_on_fargate_p3.tf ────────────────────────────────────
# Write Terraform configuration that creates AWS ECS Cluster, use awscc provider

data "awscc_ec2_subnet" "subnet" {
  id = "subnet-0000000"
}

resource "awscc_iam_role" "nginx" {
  role_name                   = "ecs_Task_ExecutionRole"
  assume_role_policy_document = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": "sts:AssumeRole",
        "Principal": {
          "Service": "ecs-tasks.amazonaws.com"
        },
        "Effect": "Allow",
        "Sid": ""
      }
    ]
}
  EOF
  managed_policy_arns         = ["arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"]
}

resource "awscc_ecs_service" "nginx" {
  service_name    = "nginx_service"
  cluster         = awscc_ecs_cluster.this.id
  task_definition = aws_ecs_task_definition.nginx.arn
  launch_type     = "FARGATE"
  desired_count   = 1

  network_configuration = {
    awsvpc_configuration = {
      assign_public_ip = "ENABLED"
      subnets          = ["${data.awscc_ec2_subnet.subnet.subnet_id}"]
    }
  }

  tags = [{
    key   = "Modified By"
    value = "AWSCC"
  }]
  depends_on = [awscc_iam_role.nginx]
}
