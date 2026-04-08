
################################################################################
# VPC and Networking Resources
################################################################################
module "vpc" {
  source = "../modules/vpc"
  name   = var.name
  azs    = slice(data.aws_availability_zones.available.names, 0, 3)
}

################################################################################
# SSM Parameters
################################################################################

resource "aws_ssm_parameter" "eks_optimized_al2023_level_1" {
  name  = "/cis_ami/${var.name}/EKS_Optimized_AL2023_Level_1/ami_id"
  type  = "String"
  value = "placeholder"

  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_ssm_parameter" "eks_optimized_al2023_level_2" {
  name  = "/cis_ami/${var.name}/EKS_Optimized_AL2023_Level_2/ami_id"
  type  = "String"
  value = "placeholder"

  lifecycle {
    ignore_changes = [value]
  }
}

################################################################################
# Create Hardened AMI EKS_Optimized_AL2023_Level_1
################################################################################

resource "null_resource" "create_hardened_ami_level_1" {
  depends_on = [module.vpc, aws_ssm_parameter.eks_optimized_al2023_level_1, aws_ssm_parameter.eks_optimized_al2023_level_2]
  triggers = {
    # Only trigger on changes to amazon-eks.pkr.hcl
    packer_file_sha1 = filesha1("./packer-files/amazon-eks.pkr.hcl")
    aws_region       = var.aws_region
  }

  provisioner "local-exec" {
    command = <<-EOT
      cd packer-files && \
      packer init -upgrade . && \
      packer build -only 'eks_optimized_ami_al2023.*' \
        -var-file=al2023_amd64_level_1.pkrvars.hcl \
        -var "subnet_id=${module.vpc.public_subnets[0]}" \
        -var "aws_region=${var.aws_region}" \
        . && \
      AMI_ID_Level_1=$(jq -r '(.builds | reverse[]) | select(.custom_data.hardened_ami_name | strings | contains("Level_1")) | .artifact_id | split(":")[1]' manifest.json | head -n1) && \
      echo $AMI_ID_Level_1 && \
      aws ssm put-parameter \
      --name "/cis_ami/EKS_Optimized_AL2023/EKS_Optimized_AL2023_Level_1/ami_id" \
      --type "String" \
      --value "$AMI_ID_Level_1" \
      --region ${var.aws_region} \
      --overwrite
    EOT
    working_dir = path.root  # Ensures we're in the right directory
  }
}

################################################################################
# Create Hardened AMI EKS_Optimized_AL2023_Level_2
################################################################################

resource "null_resource" "create_hardened_ami_level_2" {
  depends_on = [module.vpc, aws_ssm_parameter.eks_optimized_al2023_level_1, aws_ssm_parameter.eks_optimized_al2023_level_2]
  triggers = {
    # Only trigger on changes to amazon-eks.pkr.hcl
    packer_file_sha1 = filesha1("./packer-files/amazon-eks.pkr.hcl")
    aws_region       = var.aws_region
  }
  
  provisioner "local-exec" {
    command = <<-EOT
      cd packer-files && \
      packer init -upgrade . && \
      packer build -only 'eks_optimized_ami_al2023.*' \
        -var-file=al2023_amd64_level_2.pkrvars.hcl \
        -var "subnet_id=${module.vpc.public_subnets[0]}" \
        -var "aws_region=${var.aws_region}" \
        . && \
      AMI_ID_Level_2=$(jq -r '(.builds | reverse[]) | select(.custom_data.hardened_ami_name | strings | contains("Level_2")) | .artifact_id | split(":")[1]' manifest.json | head -n1) && \
      echo $AMI_ID_Level_2 && \
      aws ssm put-parameter \
      --name "/cis_ami/EKS_Optimized_AL2023/EKS_Optimized_AL2023_Level_2/ami_id" \
      --type "String" \
      --value "$AMI_ID_Level_2" \
      --region ${var.aws_region} \
      --overwrite
    EOT
    working_dir = path.root  # Ensures we're in the right directory
  }
}

################################################################################
# EKS Cluster
################################################################################

module "eks_cluster" {
  source = "../modules/eks-cluster"
  depends_on = [module.vpc]
  name   = var.name
  cluster_version = var.cluster_version
}

################################################################################
# EKS Managed Node Group Modules For AL2023 CIS Level 1
################################################################################

data "aws_ssm_parameter" "eks_optimized_al2023_level_1" {
  depends_on = [aws_ssm_parameter.eks_optimized_al2023_level_1, null_resource.create_hardened_ami_level_1]
  name = "/cis_ami/${var.name}/EKS_Optimized_AL2023_Level_1/ami_id"
}

module "eks_managed_node_group_level_1" {
  source = "../modules/eks_managed_node_group"
  depends_on = [module.eks_cluster, 
                null_resource.create_hardened_ami_level_1]

  name                              = "EKSOAL2023L1"
  cluster_name                      = module.eks_cluster.cluster_name
  cluster_version                   = module.eks_cluster.cluster_version
  kubernetes_version                = module.eks_cluster.cluster_version
  subnet_ids                        = module.vpc.private_subnets
  cluster_primary_security_group_id = module.eks_cluster.cluster_primary_security_group_id
  vpc_security_group_ids            = [module.eks_cluster.node_security_group_id]
  cluster_service_cidr              = module.eks_cluster.cluster_service_cidr
  ami_id                            = data.aws_ssm_parameter.eks_optimized_al2023_level_1.value
  cluster_endpoint                  = module.eks_cluster.cluster_endpoint
  cluster_auth_base64               = module.eks_cluster.cluster_certificate_authority_data
}

################################################################################
# EKS Managed Node Group Modules For AL2023 CIS Level 2
################################################################################

data "aws_ssm_parameter" "eks_optimized_al2023_level_2" {
  depends_on = [aws_ssm_parameter.eks_optimized_al2023_level_2, null_resource.create_hardened_ami_level_2]
  name = "/cis_ami/${var.name}/EKS_Optimized_AL2023_Level_2/ami_id"
}

module "eks_managed_node_group_level_2" {
  source = "../modules/eks_managed_node_group"
  depends_on = [module.eks_cluster, 
                null_resource.create_hardened_ami_level_2]

  name                              = "EKSOAL2023L2"
  cluster_name                      = module.eks_cluster.cluster_name
  cluster_version                   = module.eks_cluster.cluster_version
  kubernetes_version                = module.eks_cluster.cluster_version
  subnet_ids                        = module.vpc.private_subnets
  cluster_primary_security_group_id = module.eks_cluster.cluster_primary_security_group_id
  vpc_security_group_ids            = [module.eks_cluster.node_security_group_id]
  cluster_service_cidr              = module.eks_cluster.cluster_service_cidr
  ami_id                            = data.aws_ssm_parameter.eks_optimized_al2023_level_2.value
  cluster_endpoint                  = module.eks_cluster.cluster_endpoint
  cluster_auth_base64               = module.eks_cluster.cluster_certificate_authority_data
}

################################################################################
# EKS Add-ons
################################################################################

module "eks_blueprints_addons" {
  depends_on = [module.eks_cluster, module.eks_managed_node_group_level_1, module.eks_managed_node_group_level_2]
  source     = "../modules/eks-addons"

  cluster_name      = module.eks_cluster.cluster_name
  cluster_endpoint  = module.eks_cluster.cluster_endpoint
  cluster_version   = module.eks_cluster.cluster_version
  oidc_provider_arn = module.eks_cluster.oidc_provider_arn
}

################################################################################
# Run CIS SCAN AWS Inspector
################################################################################
resource "null_resource" "run_cis_scan" {
  depends_on = [module.eks_managed_node_group_level_1, module.eks_managed_node_group_level_2]
  triggers = {
    cluster_name = var.name
    force_scan   = timestamp()
  }

  provisioner "local-exec" {
    command = <<-EOT
      echo "Initiating CIS scan using AWS Inspector..." && \
      echo "Account ID: ${data.aws_caller_identity.current.account_id}" && \
      SCAN_ARN=$(aws inspector2 create-cis-scan-configuration \
        --scan-name "${var.name}" \
        --schedule "oneTime={}" \
        --security-level LEVEL_2 \
        --targets "accountIds=${data.aws_caller_identity.current.account_id},targetResourceTags={eks:cluster-name=${var.name}}" \
        --region ${var.aws_region} \
        --query 'scanArn' \
        --output text) && \
      
      if [ -z "$SCAN_ARN" ]; then
        echo "Error: Failed to create CIS scan configuration"
        exit 1
      fi && \
      
      echo "Successfully created CIS scan"
    EOT
  }
}

################################################################################
# Create Hardened AMI EKS_Optimized_AL2023_Level_1 Only
################################################################################

resource "null_resource" "only_create_hardened_ami_level_1" {
  count = var.create_ami_level1 ? 1 : 0

  triggers = {
    packer_file_sha1 = filesha1("./packer-files/amazon-eks.pkr.hcl")
    subnet_id        = var.public_subnet_id
    aws_region        = var.aws_region
  }

  provisioner "local-exec" {
    command = <<-EOT
      cd packer-files && \
      packer init -upgrade . && \
      packer build -only 'eks_optimized_ami_al2023.*' \
        -var-file=al2023_amd64_level_1.pkrvars.hcl \
        -var "subnet_id=${var.public_subnet_id}" \
        -var "aws_region=${var.aws_region}" \
        . && \
      AMI_ID_Level_1=$(jq -r '(.builds | reverse[]) | select(.custom_data.hardened_ami_name | strings | contains("Level_1")) | .artifact_id | split(":")[1]' manifest.json | head -n1) && \
      echo $AMI_ID_Level_1
    EOT
    working_dir = path.root
  }
}

################################################################################
# Create Hardened AMI EKS_Optimized_AL2023_Level_2 Only
################################################################################

resource "null_resource" "only_create_hardened_ami_level_2" {
  count = var.create_ami_level2 ? 1 : 0

  triggers = {
    packer_file_sha1 = filesha1("./packer-files/amazon-eks.pkr.hcl")
    aws_region        = var.aws_region
  }

  provisioner "local-exec" {
    command = <<-EOT
      cd packer-files && \
      packer init -upgrade . && \
      packer build -only 'eks_optimized_ami_al2023.*' \
        -var-file=al2023_amd64_level_2.pkrvars.hcl \
        -var "subnet_id=${var.public_subnet_id}" \
        -var "aws_region=${var.aws_region}" \
        . && \
      AMI_ID_Level_2=$(jq -r '(.builds | reverse[]) | select(.custom_data.hardened_ami_name | strings | contains("Level_2")) | .artifact_id | split(":")[1]' manifest.json | head -n1) && \
      echo $AMI_ID_Level_2
    EOT
    working_dir = path.root
  }
}
