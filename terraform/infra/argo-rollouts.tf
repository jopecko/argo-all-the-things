resource "helm_release" "argo_rollouts" {
  depends_on = [kubernetes_namespace.argo_rollouts]
  name = "argo-rollouts"

  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-rollouts"
  version          = "2.38.2" # v1.7.2
  namespace        = "argo-rollouts"
  values = [
    file("${path.module}/configs/argo-rollouts-values.yaml")
  ]
}

# data "kubernetes_service" "argo_rollouts_dashboard" {
#  metadata {
#    name      = "argo-rollouts-dashboard"
#    namespace = helm_release.argo_rollouts.namespace
#  }
#}
