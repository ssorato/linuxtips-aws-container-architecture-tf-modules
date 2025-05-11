provider "aws" {
  region = var.region
}

terraform {
  required_providers {
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.19.0"
    }
  }
}

provider "kubernetes" {
  host                   = module.eks-control-plane.eks_api_endpoint
  cluster_ca_certificate = module.eks-control-plane.cluster_ca_certificate
  token                  = module.eks-control-plane.k8s_token
}

provider "helm" {
  kubernetes {
    host                   = module.eks-control-plane.eks_api_endpoint
    cluster_ca_certificate = module.eks-control-plane.cluster_ca_certificate
    token                  = module.eks-control-plane.k8s_token
  }
}

provider "kubectl" {
  host                   = module.eks-control-plane.eks_api_endpoint
  cluster_ca_certificate = module.eks-control-plane.cluster_ca_certificate
  token                  = module.eks-control-plane.k8s_token
}
