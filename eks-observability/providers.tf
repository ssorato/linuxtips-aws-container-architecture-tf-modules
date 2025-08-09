provider "aws" {
  region = var.region
}

terraform {
  required_providers {
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.19.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.37.1"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "3.0.2"
    }
  }
}

provider "kubernetes" {
  host                   = module.eks-observability.eks_api_endpoint
  cluster_ca_certificate = module.eks-observability.cluster_ca_certificate
  token                  = module.eks-observability.k8s_token
}

provider "helm" {
  kubernetes = {
    host                   = module.eks-observability.eks_api_endpoint
    cluster_ca_certificate = module.eks-observability.cluster_ca_certificate
    token                  = module.eks-observability.k8s_token
  }
}

#
# Error: failed to create kubernetes rest client for read of resource: Get "http://localhost/api?timeout=32s": dial tcp 127.0.0.1:80: connect: connection refused
# use
# load_config_file       = false
#
provider "kubectl" {
  host                   = module.eks-observability.eks_api_endpoint
  cluster_ca_certificate = module.eks-observability.cluster_ca_certificate
  token                  = module.eks-observability.k8s_token
  load_config_file       = false
}
