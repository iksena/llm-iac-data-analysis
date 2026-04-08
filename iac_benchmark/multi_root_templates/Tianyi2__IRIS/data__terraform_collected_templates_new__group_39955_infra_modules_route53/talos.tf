data "aws_iam_policy_document" "talos_route53" {
  statement {
    effect = "Allow"
    actions = [
      "route53:ListHostedZonesByName"
    ]
    resources = ["*"]
  }

  statement {
    effect = "Allow"
    actions = [
      "route53:GetChange",
      "route53:ChangeResourceRecordSets",
      "route53:ListResourceRecordSets"
    ]
    resources = [
      "arn:aws:route53:::hostedzone/${aws_route53_zone.main.zone_id}",
      "arn:aws:route53:::change/*"
    ]
  }
}

resource "aws_iam_policy" "talos_route53_policy" {
  name        = "talos_route53_policy"
  description = "Least-privilege policy for talos ACME DNS challenge via Route53"
  policy      = data.aws_iam_policy_document.talos_route53.json
  tags        = local.tags
}

resource "aws_iam_user" "talos" {
  name = "talos"
  tags = local.tags
}

resource "aws_iam_user_policy_attachment" "talos_attach" {
  user       = aws_iam_user.talos.name
  policy_arn = aws_iam_policy.talos_route53_policy.arn
}

resource "aws_iam_access_key" "talos" {
  user = aws_iam_user.talos.name
}
