resource "helm_release" "argo_workflows" {
  depends_on = [kubernetes_namespace.argo_workflows]
  name = "argo-workflows"

  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-workflows"
  version          = "0.45.4" # v3.6.2
  namespace        = "argo-workflows"
#  values = [
#    file("${path.module}/configs/argo-workflows-values.yaml")
#  ]
}

data "kubernetes_service" "argo_workflows_server" {
  metadata {
    name      = "argo-workflows-server"
    namespace = helm_release.argo_workflows.namespace
  }
}
