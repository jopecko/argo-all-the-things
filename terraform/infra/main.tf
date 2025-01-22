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