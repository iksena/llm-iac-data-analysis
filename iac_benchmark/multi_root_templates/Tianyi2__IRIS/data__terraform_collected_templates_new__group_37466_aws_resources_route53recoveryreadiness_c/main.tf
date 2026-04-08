resource "aws_route53recoveryreadiness_cell" "this" {
  cell_name = var.cell_name
  cells     = var.cells
  tags      = var.tags

  timeouts {
    delete = var.timeouts_delete
  }
}