data "aws_iam_policy_document" "coredns_route53" {
  statement {
    effect = "Allow"
    actions = [
      "route53:ListHostedZonesByName",
      "route53:ListHostedZones"
    ]
    resources = ["*"]
  }

  statement {
    effect = "Allow"
    actions = [
      "route53:GetChange",
      "route53:ListResourceRecordSets"
    ]
    resources = [
      "arn:aws:route53:::hostedzone/${aws_route53_zone.main.zone_id}",
      "arn:aws:route53:::change/*"
    ]
  }
}


resource "aws_iam_policy" "coredns_route53_policy" {
  name        = "coredns_route53_policy"
  description = "Least-privilege policy for CoreDNS Route53 plugin"
  policy      = data.aws_iam_policy_document.coredns_route53.json
  tags        = local.tags
}

resource "aws_iam_user" "coredns" {
  name = "coredns"
  tags = local.tags
}

resource "aws_iam_user_policy_attachment" "coredns_attach" {
  user       = aws_iam_user.coredns.name
  policy_arn = aws_iam_policy.coredns_route53_policy.arn
}

resource "aws_iam_access_key" "coredns" {
  user = aws_iam_user.coredns.name
}
