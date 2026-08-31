/*
 * DBSubnetGroup
 */
resource "aws_db_subnet_group" "db-sg" {
    name        = "${var.app_name}-main-sg"
    description = "Our main group of subnets"
    subnet_ids  = [
        "${aws_subnet.main-privatesubnet-1.id}",
        "${aws_subnet.main-privatesubnet-2.id}"
    ]
    tags = {
        Name = "${var.app_name}-db-sg"
    }
}

/*
 * DBParameterGroup
 */
resource "aws_db_parameter_group" "db-pg-mysql56" {
    name        = "${var.app_name}-mysql56-pg"
    family      = "mysql5.6"
    description = "${var.app_name}-db-pg-mysql56"

    parameter {
      name  = "character_set_server"
      value = "utf8"
    }

    parameter {
      name  = "character_set_client"
      value = "utf8"
    }
}

/*
 * Instances
 */
# resource "aws_db_instance" "db-instance" {
#     allocated_storage    = 10
#     engine               = "mysql"
#     engine_version       = "5.6.29"
#     instance_class       = "db.t1.micro"
#     name                 = "${var.app_name}"
#     username             = "foo"
#     password             = "barbarbar"
#     multi_az             = false
#     port                 = 3306
#     db_subnet_group_name = "${aws_db_subnet_group.db-sg.name}"
#     parameter_group_name = "${aws_db_parameter_group.db-pg-mysql56.name}"
# }
