resource "aws_elb" "web_elb" {
    name = "${var.app_name}-elb"
    subnets = [
        "${aws_subnet.main-publicsubnet-1.id}",
        "${aws_subnet.main-publicsubnet-2.id}"
    ]

    access_logs {
      bucket = "${aws_s3_bucket.elb_log.bucket}"
      bucket_prefix = "web_elb"
      interval = 60
    }

    listener {
      instance_port = 80
      instance_protocol = "http"
      lb_port = 80
      lb_protocol = "http"
    }

    # listener {
    #   instance_port = 80
    #   instance_protocol = "http"
    #   lb_port = 443
    #   lb_protocol = "https"
    #   ssl_certificate_id = "arn:aws:iam::123456789012:server-certificate/certName"
    # }

    health_check {
      healthy_threshold = 2
      unhealthy_threshold = 2
      timeout = 3
      target = "HTTP:80/"
      interval = 30
    }

    instances = aws_instance.web[*].id
    cross_zone_load_balancing = true
    idle_timeout = 400
    connection_draining = true
    connection_draining_timeout = 400
  
    tags = {
      Name = "${var.app_name}-elb"
    }
}