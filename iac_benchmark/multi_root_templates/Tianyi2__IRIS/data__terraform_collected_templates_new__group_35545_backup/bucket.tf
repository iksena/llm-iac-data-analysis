resource "null_resource" "create_backup_bucket" {
  depends_on = [helm_release.velero]

  triggers = {
    namespace_uid = kubernetes_namespace_v1.backup_namespace.id
    backup_bucket = var.s3_backup_bucket_name
  }

  provisioner "local-exec" {
    command = <<-EOT
      echo "Waiting for MinIO tenant to be ready..."

      # Wait for tenant pods to be created
      timeout=300
      elapsed=0
      while [ $elapsed -lt $timeout ]; do
        POD_NAME=$(kubectl get pods -n agartha-storage -l v1.min.io/tenant=minio-tenant -o jsonpath='{.items[0].metadata.name}' 2>/dev/null)
        if [ -n "$POD_NAME" ]; then
          echo "Found tenant pod: $POD_NAME, checking readiness..."
          break
        fi
        echo "Waiting for tenant pods to be created... ($elapsed/$timeout seconds)"
        sleep 5
        elapsed=$((elapsed + 5))
      done

      if [ -z "$POD_NAME" ]; then
        echo "ERROR: Timeout waiting for tenant pods"
        exit 1
      fi

      # Wait for the pod to be ready
      kubectl wait --for=condition=ready pod -n agartha-storage $POD_NAME --timeout=300s
      echo "MinIO pod $POD_NAME is ready"

      # Give MinIO time to fully initialize
      sleep 10

      # Create backup bucket with retry logic
      for i in 1 2 3; do
        if kubectl exec -n agartha-storage $POD_NAME -c minio -- sh -c 'mc alias set local http://localhost:9000 ${var.s3_access_key} ${var.s3_secret_key} && mc mb --ignore-existing local/${var.s3_backup_bucket_name}'; then
          echo "Backup bucket created successfully"
          exit 0
        fi
        echo "Bucket creation attempt $i failed, retrying..."
        sleep 5
      done
      echo "Failed to create backup bucket after 3 attempts"
      exit 1
    EOT
  }
}
