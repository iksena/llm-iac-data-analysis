resource "aws_ecs_service" "kunlaquota" {
  name            = "springboot-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.kunlaquota.arn
  desired_count   = 1
  launch_type     = "FARGATE"
  network_configuration {
    subnets         = [aws_subnet.subnet_a.id, aws_subnet.subnet_b.id]
    security_groups = [aws_security_group.ecs.id]
  }
  load_balancer {
    target_group_arn = aws_lb_target_group.app_lb_tg.arn
    container_name   = "kunlaquota"
    container_port   = 8080
  }

  tags = {
    Owner: "TimS"
    Name: "tims-kunlaquota-ecs-service"
  }
}