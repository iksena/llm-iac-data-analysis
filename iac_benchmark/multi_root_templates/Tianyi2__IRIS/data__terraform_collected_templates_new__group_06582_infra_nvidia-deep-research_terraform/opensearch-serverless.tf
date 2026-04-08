#---------------------------------------------------------------
# OpenSearch Serverless - Complete Setup
#
# This module creates:
# 1. OpenSearch Serverless collection (vector search)
# 2. Encryption, network, and data access policies
# 3. EKS Pod Identity-enabled Kubernetes service account for pod access
#
#---------------------------------------------------------------

#---------------------------------------------------------------
# Variables
#---------------------------------------------------------------
variable "enable_opensearch_serverless" {
  description = "Enable OpenSearch Serverless (collection, policies, Pod Identity, and service account)"
  type        = bool
  default     = true
}

variable "opensearch_collection_name" {
  description = "Name of the OpenSearch Serverless collection"
  type        = string
  default     = "osv-vector-dev"
}

variable "opensearch_collection_type" {
  description = "Type of OpenSearch Serverless collection (VECTORSEARCH, SEARCH, or TIMESERIES)"
  type        = string
  default     = "VECTORSEARCH"
}

variable "opensearch_policy_name" {
  description = "Name for OpenSearch Serverless policies (data access, network, encryption)"
  type        = string
  default     = ""
}

variable "opensearch_allow_public_access" {
  description = "Allow public access to OpenSearch collection"
  type        = bool
  default     = true
}

variable "opensearch_namespace" {
  description = "Kubernetes namespace for OpenSearch service account (must match where your application pods run)"
  type        = string
  default     = "rag"
}

variable "opensearch_service_account_name" {
  description = "Name of the Kubernetes service account for OpenSearch access"
  type        = string
  default     = "opensearch-access-sa"
}

#---------------------------------------------------------------
# Local variables
#---------------------------------------------------------------
locals {
  opensearch_policy_name = var.opensearch_policy_name != "" ? var.opensearch_policy_name : "${var.opensearch_collection_name}-policy"
}

#---------------------------------------------------------------
# Step 1: Encryption Policy (AWS Owned Key)
# Must be created before the collection
#---------------------------------------------------------------
resource "aws_opensearchserverless_security_policy" "encryption" {
  count = var.enable_opensearch_serverless ? 1 : 0

  name        = local.opensearch_policy_name
  type        = "encryption"
  description = "Encryption policy for ${var.opensearch_collection_name}"

  policy = jsonencode({
    Rules = [
      {
        Resource     = ["collection/${var.opensearch_collection_name}"]
        ResourceType = "collection"
      }
    ]
    AWSOwnedKey = true
  })
}

#---------------------------------------------------------------
# Step 2: Network Policy
# Must be created before the collection
#---------------------------------------------------------------
resource "aws_opensearchserverless_security_policy" "network" {
  count = var.enable_opensearch_serverless ? 1 : 0

  name        = local.opensearch_policy_name
  type        = "network"
  description = "Network policy for ${var.opensearch_collection_name}"

  policy = jsonencode([
    {
      Rules = [
        {
          Resource     = ["collection/${var.opensearch_collection_name}"]
          ResourceType = "collection"
        }
      ]
      AllowFromPublic = var.opensearch_allow_public_access
    }
  ])
}

#---------------------------------------------------------------
# Step 3: OpenSearch Serverless Collection
#---------------------------------------------------------------
resource "aws_opensearchserverless_collection" "this" {
  count = var.enable_opensearch_serverless ? 1 : 0

  name        = var.opensearch_collection_name
  type        = var.opensearch_collection_type
  description = "OpenSearch Serverless collection for vector search"

  tags = merge(local.tags, {
    Name = var.opensearch_collection_name
  })

  depends_on = [
    aws_opensearchserverless_security_policy.encryption,
    aws_opensearchserverless_security_policy.network
  ]
}

#---------------------------------------------------------------
# Step 4: EKS Pod Identity
#---------------------------------------------------------------
# IAM Role for Pod Identity
resource "aws_iam_role" "opensearch_pod_identity" {
  count = var.enable_opensearch_serverless ? 1 : 0

  name        = "${module.eks.cluster_name}-opensearch-pod-identity"
  description = "IAM role for OpenSearch access via EKS Pod Identity"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "pods.eks.amazonaws.com"
        }
        Action = [
          "sts:AssumeRole",
          "sts:TagSession"
        ]
      }
    ]
  })

  tags = local.tags
}

# Attach the OpenSearch policy to the role
resource "aws_iam_role_policy_attachment" "opensearch_pod_identity" {
  count = var.enable_opensearch_serverless ? 1 : 0

  role       = aws_iam_role.opensearch_pod_identity[0].name
  policy_arn = aws_iam_policy.opensearch_serverless[0].arn
}

# Create the Pod Identity Association
resource "aws_eks_pod_identity_association" "opensearch" {
  count = var.enable_opensearch_serverless ? 1 : 0

  cluster_name    = module.eks.cluster_name
  namespace       = var.opensearch_namespace
  service_account = var.opensearch_service_account_name
  role_arn        = aws_iam_role.opensearch_pod_identity[0].arn

  tags = local.tags
}

#---------------------------------------------------------------
# Step 5: IAM Policy for OpenSearch Serverless Access
#---------------------------------------------------------------
resource "aws_iam_policy" "opensearch_serverless" {
  count = var.enable_opensearch_serverless ? 1 : 0

  name_prefix = "${module.eks.cluster_name}-opensearch-serverless-"
  description = "IAM policy for OpenSearch Serverless access from EKS pods"
  policy      = data.aws_iam_policy_document.opensearch_serverless[0].json

  tags = local.tags
}

data "aws_iam_policy_document" "opensearch_serverless" {
  count = var.enable_opensearch_serverless ? 1 : 0

  # OpenSearch Serverless data and index operations
  statement {
    sid    = "OpenSearchServerlessDataAccess"
    effect = "Allow"
    actions = [
      "aoss:CreateCollectionItems",
      "aoss:DeleteCollectionItems",
      "aoss:UpdateCollectionItems",
      "aoss:DescribeCollectionItems",
      "aoss:ReadDocument",
      "aoss:WriteDocument",
      "aoss:CreateIndex",
      "aoss:DeleteIndex",
      "aoss:UpdateIndex",
      "aoss:DescribeIndex",
      "aoss:APIAccessAll"
    ]
    resources = ["*"]
  }

  # OpenSearch Serverless collection operations
  statement {
    sid    = "OpenSearchServerlessCollectionAccess"
    effect = "Allow"
    actions = [
      "aoss:ListCollections",
      "aoss:BatchGetCollection",
      "aoss:GetCollectionItems",
      "aoss:DescribeCollection"
    ]
    resources = ["*"]
  }
}

#---------------------------------------------------------------
# Step 6: Data Access Policy
# This grants the Pod Identity role permissions to access the collection
#---------------------------------------------------------------
resource "aws_opensearchserverless_access_policy" "data" {
  count = var.enable_opensearch_serverless ? 1 : 0

  name        = local.opensearch_policy_name
  type        = "data"
  description = "Data access policy for ${var.opensearch_collection_name}"

  policy = jsonencode([
    {
      Rules = [
        {
          ResourceType = "collection"
          Resource     = ["collection/${var.opensearch_collection_name}"]
          Permission = [
            "aoss:CreateCollectionItems",
            "aoss:DeleteCollectionItems",
            "aoss:UpdateCollectionItems",
            "aoss:DescribeCollectionItems"
          ]
        },
        {
          ResourceType = "index"
          Resource     = ["index/${var.opensearch_collection_name}/*"]
          Permission = [
            "aoss:ReadDocument",
            "aoss:WriteDocument",
            "aoss:CreateIndex",
            "aoss:DeleteIndex",
            "aoss:UpdateIndex",
            "aoss:DescribeIndex"
          ]
        }
      ]
      Principal = [
        # Grant access to the Pod Identity role
        aws_iam_role.opensearch_pod_identity[0].arn
      ]
    }
  ])

  depends_on = [
    aws_opensearchserverless_collection.this,
    aws_iam_role.opensearch_pod_identity
  ]
}

#---------------------------------------------------------------
# Step 7: Kubernetes Namespace
#---------------------------------------------------------------
resource "kubernetes_namespace_v1" "opensearch" {
  count = var.enable_opensearch_serverless ? 1 : 0

  metadata {
    name = var.opensearch_namespace
  }

  lifecycle {
    ignore_changes = [metadata[0].labels, metadata[0].annotations]
  }
}

#---------------------------------------------------------------
# Step 8: Kubernetes Service Account
#---------------------------------------------------------------
resource "kubernetes_service_account_v1" "opensearch" {
  count = var.enable_opensearch_serverless ? 1 : 0

  metadata {
    name      = var.opensearch_service_account_name
    namespace = var.opensearch_namespace
  }

  automount_service_account_token = true

  depends_on = [kubernetes_namespace_v1.opensearch]
}

#---------------------------------------------------------------
# Outputs
#---------------------------------------------------------------
output "opensearch_collection_id" {
  description = "ID of the OpenSearch Serverless collection"
  value       = var.enable_opensearch_serverless ? aws_opensearchserverless_collection.this[0].id : null
}

output "opensearch_collection_arn" {
  description = "ARN of the OpenSearch Serverless collection"
  value       = var.enable_opensearch_serverless ? aws_opensearchserverless_collection.this[0].arn : null
}

output "opensearch_collection_endpoint" {
  description = "Endpoint of the OpenSearch Serverless collection"
  value       = var.enable_opensearch_serverless ? aws_opensearchserverless_collection.this[0].collection_endpoint : null
}

output "opensearch_dashboard_endpoint" {
  description = "Dashboard endpoint of the OpenSearch Serverless collection"
  value       = var.enable_opensearch_serverless ? aws_opensearchserverless_collection.this[0].dashboard_endpoint : null
}

output "opensearch_policy_name" {
  description = "Name of the OpenSearch policies"
  value       = var.enable_opensearch_serverless ? local.opensearch_policy_name : null
}

output "opensearch_service_account_name" {
  description = "Name of the OpenSearch service account"
  value       = var.enable_opensearch_serverless ? kubernetes_service_account_v1.opensearch[0].metadata[0].name : null
}

output "opensearch_iam_role_arn" {
  description = "ARN of the IAM role for OpenSearch service account"
  value       = var.enable_opensearch_serverless ? aws_iam_role.opensearch_pod_identity[0].arn : null
}

output "opensearch_iam_role_name" {
  description = "Name of the IAM role for OpenSearch service account"
  value       = var.enable_opensearch_serverless ? aws_iam_role.opensearch_pod_identity[0].name : null
}

output "opensearch_namespace" {
  description = "Namespace where OpenSearch service account is created"
  value       = var.enable_opensearch_serverless ? var.opensearch_namespace : null
}
