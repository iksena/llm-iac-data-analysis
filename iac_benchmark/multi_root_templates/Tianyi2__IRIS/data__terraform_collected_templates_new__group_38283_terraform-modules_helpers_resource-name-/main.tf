##########################
#     Naming Config      #
##########################
locals {
  name = "${var.name}-${var.tags["Environment"]}"
}