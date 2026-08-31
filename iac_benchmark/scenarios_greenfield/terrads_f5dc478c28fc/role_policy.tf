locals {
  # Work around merge() breaking for_each.
  role_policy_document_keys = setunion(
    keys(var.role_policy_documents),
  )
  role_policy_documents = merge(
    var.role_policy_documents,
  )
}

resource "aws_iam_role_policy" "role_policy" {
  for_each = local.role_policy_document_keys

  name   = each.key
  policy = local.role_policy_documents[each.key]
  role   = aws_iam_role.role.id
}
