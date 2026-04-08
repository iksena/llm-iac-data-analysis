# -----------------------------------------------------------------------------
# Outputs
# -----------------------------------------------------------------------------

output "name" {
  description = "The name of the GKE cluster created by the module."
  value       = module.gke-dev-jetic-cluster.name
}
