resource "aws_eip" "eip" {
  count = var.associate_eip == true ? 1 : 0
  vpc   = true
  tags = merge(
      var.tags,
      {
      Name       = "${var.name}-eip"
      }
  )
}

resource "aws_eip_association" "eip_assoc" {
  count = var.associate_eip == true ? 1 : 0
  instance_id   = aws_instance.bastion.id
  allocation_id =  var.associate_eip == true ? aws_eip.eip[0].id : null
}