resource "helm_release" "argo_workflows" {
  depends_on = [kubernetes_namespace.argo_workflows]
  name = "argo-workflows"

  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-workflows"
  version          = "0.45.4" # v3.6.2
  namespace        = kubernetes_namespace.argo_workflows.metadata[0].name
}

data "kubernetes_service" "argo_workflows_server" {
  metadata {
    name      = "argo-workflows-server"
    namespace = helm_release.argo_workflows.namespace
  }
}

resource "kubernetes_role_v1" "argooperator_role" {
  metadata {
    name = "argooperatorrole"
    namespace = helm_release.argo_workflows.namespace
  }

  rule {
    api_groups = ["", "apps", "argoproj.io", "batch"]
    resources  = ["*"]
    verbs      = ["create", "delete", "get", "list", "patch"]
  }
}

resource "kubernetes_role_binding" "argooperator_rolebinding" {
  metadata {
    name      = "argooperatorrolebinding"
    namespace = helm_release.argo_workflows.namespace
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = "argooperatorrole"
  }
  subject {
    kind      = "ServiceAccount"
    name      = "argooperator"
    namespace = helm_release.argo_workflows.namespace
  }
}

resource "kubernetes_service_account" "argooperator_sa" {
  metadata {
    name = "argooperator"
    namespace = helm_release.argo_workflows.namespace
  }
  secret {
    name = "argooperator-sa"
  }
}

resource "kubernetes_secret" "argooperator_secret" {
  metadata {
    annotations = {
      "kubernetes.io/service-account.name" = kubernetes_service_account.argooperator_sa.metadata.0.name
    }
    namespace = helm_release.argo_workflows.namespace
    name = "argooperator-sa"
  }

  type                           = "kubernetes.io/service-account-token"
  wait_for_service_account_token = true
}
