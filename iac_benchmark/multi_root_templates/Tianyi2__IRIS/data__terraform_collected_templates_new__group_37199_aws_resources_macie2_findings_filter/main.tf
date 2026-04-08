resource "aws_macie2_findings_filter" "this" {
  region      = var.region
  name        = var.name
  name_prefix = var.name_prefix
  description = var.description
  action      = var.action
  position    = var.position
  tags        = var.tags

  dynamic "finding_criteria" {
    for_each = var.finding_criteria != null ? [var.finding_criteria] : []
    content {
      dynamic "criterion" {
        for_each = finding_criteria.value.criterion != null ? finding_criteria.value.criterion : []
        content {
          field          = criterion.value.field
          eq_exact_match = criterion.value.eq_exact_match
          eq             = criterion.value.eq
          neq            = criterion.value.neq
          lt             = criterion.value.lt
          lte            = criterion.value.lte
          gt             = criterion.value.gt
          gte            = criterion.value.gte
        }
      }
    }
  }
}