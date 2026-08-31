resource "aws_eip" "nat_eip" {
  count = var.vpc_nat_gateways_number

  vpc = true
}

resource "aws_eip" "ec2_eip" {

  for_each = toset(var.ec2_instances)
  vpc      = true

  instance                  = module.ec2_instance[each.key].id
  associate_with_private_ip = module.ec2_instance[each.key].private_ip

  depends_on = [
    module.vpc,
    module.ec2_instance
  ]
}
