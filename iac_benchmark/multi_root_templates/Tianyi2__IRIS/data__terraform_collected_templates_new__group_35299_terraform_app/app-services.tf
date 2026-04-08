resource "null_resource" "login" {
    provisioner "local-exec" {
        command = "aws ecr get-login-password --region var.aws_region | docker login --username AWS --password-stdin var.ecr_url "
    }
}
resource "null_resource" "build" {
    depends_on  = ["null_resource.login"]
    provisioner "local-exec" {
        command = "cd .. ; docker build . -t var.ecr_url "
    }
}
resource "null_resource" "push" {
    depends_on  = ["null_resource.build"]
    provisioner "local-exec" {
        command = "docker push var.ecr_url "
    }
}
resource "kubernetes_service" "service_tomcat" {
  depends_on  = ["null_resource.push"]
  metadata {
    name      = "service-tomcat"
    namespace = "tomcat"
  }

  spec {
    port {
      protocol    = "TCP"
      port        = 8080
      target_port = "8080"
    }

    selector = {
      app = "tomcat"
    }

    type = "LoadBalancer"
  }
}

