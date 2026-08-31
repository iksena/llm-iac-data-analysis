#tfsec:ignore:aws-ec2-enforce-http-token-imds
module "ec2_instance" {
  source = "terraform-aws-modules/ec2-instance/aws"

  for_each = toset(var.ec2_instances)

  name = "${each.key}-${local.bootcamp_id}"

  ami           = data.aws_ami.ubuntu.id
  instance_type = var.ec2_instance_type
  key_name      = aws_key_pair.main[each.key].id
  monitoring    = false
  vpc_security_group_ids = [
    aws_security_group.main.id
  ]
  subnet_id = module.vpc.public_subnets[0]

  root_block_device = [
    {
      volume_type = "gp2"
      volume_size = var.ec2_instance_size
    }
  ]

  tags = {
    fameMachineId = each.key
  }

  version = "5.0.0"
}
