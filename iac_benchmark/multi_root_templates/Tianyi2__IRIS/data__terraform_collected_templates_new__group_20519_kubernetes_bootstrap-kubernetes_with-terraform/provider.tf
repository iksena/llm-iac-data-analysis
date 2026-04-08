terraform {
    required_providers {
        helm = {
            source  = "hashicorp/helm"
            version = "~> 2.12"
        }
        kubernetes = {
            source  = "hashicorp/kubernetes"
            version = "~> 2.23"
        }
        minio = {
            source = "aminueza/minio"
            version = "3.3.0"
        }
    }  
}

provider "kubernetes" {
    config_path = "~/.kube/config"
    config_context = "dena"
}

provider "helm" {
    kubernetes {
        config_path = "~/.kube/config"
        config_context = "dena"
    }
}

provider "minio" {
    minio_server   = var.minio_server
    minio_region   = "us-east-1"
    minio_user     = var.minio_root_username
    minio_password = var.minio_root_password
    minio_ssl      = true
}
