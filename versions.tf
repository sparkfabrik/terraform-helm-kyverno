terraform {
  required_version = ">= 1.5"

  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.3"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.0"
    }
  }
}
