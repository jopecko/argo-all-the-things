terraform {
  required_providers {
    kubernetes = "~> 2.29.0"
    helm       = "~> 2.13.1"
  }
  required_version = "~> 1.5.7"
}

# We use K3d so this is good enough
provider "kubernetes" {
  config_path = "~/.kube/config"
}

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}