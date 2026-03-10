# ── awscc_iam_oidc_provider_p1.tf ────────────────────────────────────
# Create AWS IAM OIDC provider via the 'awscc' provider

# Fetch TLS Certificate Info for defined URL
data "tls_certificate" "tfc_certificate" {
  url = "https://app.terraform.io"
}

# Create IAM OIDC Provider
resource "awscc_iam_oidc_provider" "this" {
  thumbprint_list = [data.tls_certificate.tfc_certificate.certificates[0].sha1_fingerprint]
  client_id_list  = ["aws.workload.identity", ]
  url             = data.tls_certificate.tfc_certificate.url
  tags = [{
    key   = "Name"
    value = "IAM OIDC Provider"
    },
    {
      key   = "Environment"
      value = "Development"
    },
    { key   = "Modified By"
      value = "AWSCC"
  }]
}


# ── awscc_iam_oidc_provider_p2.tf ────────────────────────────────────
# Terraform code to create IAM OIDC provider via the 'awscc' provider

# Fetch TLS Certificate Info for defined URL
data "tls_certificate" "tfc_certificate" {
  url = "https://app.terraform.io"
}

# Create IAM OIDC Provider
resource "awscc_iam_oidc_provider" "this" {
  thumbprint_list = [data.tls_certificate.tfc_certificate.certificates[0].sha1_fingerprint]
  client_id_list  = ["aws.workload.identity", ]
  url             = data.tls_certificate.tfc_certificate.url
  tags = [{
    key   = "Name"
    value = "IAM OIDC Provider"
    },
    {
      key   = "Environment"
      value = "Development"
    },
    { key   = "Modified By"
      value = "AWSCC"
  }]
}



# ── awscc_iam_oidc_provider_p3.tf ────────────────────────────────────
# Write Terraform configuration that creates IAM OIDC provider, use awscc provider

# Fetch TLS Certificate Info for defined URL
data "tls_certificate" "tfc_certificate" {
  url = "https://app.terraform.io"
}

# Create IAM OIDC Provider
resource "awscc_iam_oidc_provider" "this" {
  thumbprint_list = [data.tls_certificate.tfc_certificate.certificates[0].sha1_fingerprint]
  client_id_list  = ["aws.workload.identity", ]
  url             = data.tls_certificate.tfc_certificate.url
  tags = [{
    key   = "Name"
    value = "IAM OIDC Provider"
    },
    {
      key   = "Environment"
      value = "Development"
    },
    { key   = "Modified By"
      value = "AWSCC"
  }]
}


# ── awscc_iam_role_templatefile.tf ────────────────────────────────────
# create IAM role, use template file for the assume role policy , pass the account id as variable to the template file
resource "awscc_iam_role" "example" {
  assume_role_policy_document = templatefile("assume-role-policy.tpl", { account_id = var.account_id })
}

variable "account_id" {
  type = string
}