resource "aws_iam_role" "ecs-autoscale-role" {
  count = var.enable_autoscaling ? 1 : 0

  name = "${var.cluster_name}-scale-application"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "application-autoscaling.amazonaws.com"
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "ecs-autoscale" {
  count = var.enable_autoscaling ? 1 : 0

  role = aws_iam_role.ecs-autoscale-role[0].id
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceAutoscaleRole"
}


resource "aws_appautoscaling_target" "ecs_target" {
  count = var.enable_autoscaling ? 1 : 0

  max_capacity       = var.max_task_count
  min_capacity       = var.desired_task_count
  resource_id        = "service/${var.cluster_name}/${var.service_name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
  role_arn           = aws_iam_role.ecs-autoscale-role[0].arn
}

resource "aws_appautoscaling_policy" "ecs_target_cpu" {
  count = var.enable_autoscaling ? 1 : 0

  name               = "application-scaling-policy-cpu"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.ecs_target[0].resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_target[0].scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_target[0].service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }
    target_value = var.target_average_cpu_utilizazion
  }
  depends_on = [aws_appautoscaling_target.ecs_target]
}

resource "aws_appautoscaling_policy" "ecs_target_memory" {
  count = var.enable_autoscaling ? 1 : 0

  name               = "application-scaling-policy-memory"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.ecs_target[0].resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_target[0].scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_target[0].service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageMemoryUtilization"
    }
    target_value = var.target_average_memory_utilizazion
  }
  depends_on = [aws_appautoscaling_target.ecs_target]
}