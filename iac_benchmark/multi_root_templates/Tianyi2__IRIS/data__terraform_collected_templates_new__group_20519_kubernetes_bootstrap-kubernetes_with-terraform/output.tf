output "deployed_charts" {
    description = "List of deployed Helm charts with their details"
    value = {
        for chart_key, release in helm_release.charts : chart_key => {
            name      = release.name
            namespace = release.namespace
            version   = release.version
            status    = release.status
        }
    }
}


output "all_manifests_metadata" {
    value = {
        for k, v in kubernetes_manifest.all : k => v.manifest.metadata
    }
}


output "bucket_name" {
    value = minio_s3_bucket.velero
}

output "username" {
    value = minio_iam_user.velero.id
}

output "user_status" {
    value = minio_iam_user.velero.status
}

output "policy_raw" {
    value = minio_iam_policy.velero.policy
}
