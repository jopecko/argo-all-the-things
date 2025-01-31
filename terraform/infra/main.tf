resource "kubernetes_namespace" "argocd" {
  metadata {
    name = "argocd"
  }
}

resource "kubernetes_namespace" "argo_rollouts" {
  metadata {
    name = "argo-rollouts"
  }
}

resource "kubernetes_namespace" "argo_workflows" {
  metadata {
    name = "argo-workflows"
  }
}

resource "kubernetes_namespace" "minio-operator" {
  metadata {
    name = "minio-operator"
  }
}

resource "kubernetes_namespace" "tenant" {
  metadata {
    name = "block-storage"
  }
}
