data "aws_iam_policy_document" "openldap_role_policy" {
  statement {
    sid    = "OpenLDAPRolePolicy"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }

    actions = [
      "sts:AssumeRole"
    ]
  }
}

resource "aws_iam_role" "openldap_role" {
  name               = "OpenLDAPInstanceRole"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.openldap_role_policy.json
}

resource "aws_iam_instance_profile" "openldap_instance_profile" {
  name = "OpenLDAPInstanceProfile"
  role = aws_iam_role.openldap_role.name
}
