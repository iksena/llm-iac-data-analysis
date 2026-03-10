# ── awscc_rds_db_cluster_managed_master_passwords_with_secrets_manager_enabled_specify_azs_p1 copy.tf ────────────────────────────────────
# Create RDS db cluster with managed master passwords with secrets manager via the 'awscc' provider

resource "awscc_rds_db_cluster" "example_db_cluster" {
  availability_zones          = ["us-east-1b", "us-east-1c"]
  engine                      = "aurora-mysql"
  db_cluster_identifier       = "example-dbcluster"
  manage_master_user_password = true
  master_username             = "foo"
}


# ── awscc_rds_db_cluster_managed_master_passwords_with_secrets_manager_enabled_specify_azs_p2 copy.tf ────────────────────────────────────
# Terraform code to create RDS db cluster with managed master password with secrets manager enabled via the 'awscc' provider

resource "awscc_rds_db_cluster" "example_db_cluster" {
  availability_zones          = ["us-east-1b", "us-east-1c"]
  engine                      = "aurora-mysql"
  db_cluster_identifier       = "example-dbcluster"
  manage_master_user_password = true
  master_username             = "foo"
}


# ── awscc_rds_db_cluster_managed_master_passwords_with_secrets_manager_enabled_specify_azs_p3.tf ────────────────────────────────────
# Write Terraform configuration that creates RDS db cluster with managed master password with secrets manager enabled, use awscc provider

resource "awscc_rds_db_cluster" "example_db_cluster" {
  availability_zones          = ["us-east-1b", "us-east-1c"]
  engine                      = "aurora-mysql"
  db_cluster_identifier       = "example-dbcluster"
  manage_master_user_password = true
  master_username             = "foo"
}
