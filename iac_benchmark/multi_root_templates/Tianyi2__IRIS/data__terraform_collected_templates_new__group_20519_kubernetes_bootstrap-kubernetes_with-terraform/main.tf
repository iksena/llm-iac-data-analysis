# Read chart setting file
locals {
    charts_config = yamldecode(file("${path.module}/charts.yml"))["charts"]
}

# Create chart namespace
resource "kubernetes_namespace" "chart_ns" {
    for_each = { for chart in local.charts_config : chart.name => chart }
    metadata {
        name = each.value.namespace
    }
}

# Apply all helm charts
resource "helm_release" "charts" {
    for_each = { for chart in local.charts_config : chart.name => chart }
    name       = each.value.name
    repository = each.value.repository
    chart      = each.value.chart
    version    = each.value.version
    namespace  = each.value.namespace

    values     = [templatefile("${path.module}/values/${each.value.values_file}", {
        main_domain             = var.main_domain
        minio_root_username     = var.minio_root_username
        minio_root_password     = var.minio_root_password
        grafana_password        = var.grafana_password
        velero_bucket_name      = var.velero_bucket_name
        velero_minio_username   = var.velero_minio_username
        velero_minio_password   = var.velero_minio_password
    })] 

    depends_on = [kubernetes_namespace.chart_ns]
}

# Read files on manifests dir with extension yaml or yml
locals {
    manifests = toset(concat(
        tolist(fileset("${path.module}/manifests", "*.yaml")),
        tolist(fileset("${path.module}/manifests", "*.yml")),
    ))
}

# Apply all manifest from list
resource "kubernetes_manifest" "all" {
    for_each = local.manifests
    manifest = yamldecode(file("${path.module}/manifests/${each.key}"))
    depends_on = [helm_release.charts["cert-manager"]]
}

resource "minio_s3_bucket" "velero" {
    bucket = var.velero_bucket_name
    depends_on = [helm_release.charts["minio"]]
}

resource "minio_iam_user" "velero" {
    name = var.velero_minio_username
    secret = var.velero_minio_password
    depends_on = [minio_s3_bucket.velero]
}

resource "minio_iam_policy" "velero" {
    name = var.velero_policy_name
    depends_on = [minio_s3_bucket.velero]
    policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
        "Effect": "Allow",
        "Action": [
            "s3:*"
        ],
        "Resource": [
            "arn:aws:s3:::${var.velero_bucket_name}/*",
            "arn:aws:s3:::${var.velero_bucket_name}"
        ]
        }
    ]
}
EOF
}

resource "minio_iam_user_policy_attachment" "velero" {
    depends_on  = [minio_iam_user.velero,minio_iam_policy.velero]
    user_name   = minio_iam_user.velero.id
    policy_name = minio_iam_policy.velero.id
}