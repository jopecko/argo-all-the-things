resource "helm_release" "argocd" {
  depends_on = [kubernetes_namespace.argocd]
  name = "argocd"

  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  version          = "7.7.16" # v2.3
  namespace        = "argocd"
  values = [
    file("${path.module}/configs/argocd-values.yaml")
  ]
}

data "kubernetes_service" "argocd_server" {
  metadata {
    name      = "argocd-server"
    namespace = helm_release.argocd.namespace
  }
}
