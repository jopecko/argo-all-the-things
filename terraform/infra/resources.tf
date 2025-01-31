resource "kubernetes_ingress_v1" "argocd_ingress" {
  depends_on = [data.kubernetes_service.argocd_server]
  metadata {
    name = "argocd-ingress"
    namespace = "argocd"
    labels = {
      app = "argocd"
    }
    annotations = {
      "ingress.kubernetes.io/ssl-redirect" = false
    }
  }

  spec {
    rule {
      http {
        path {
          backend {
            service {
              name = "argocd-server"
              port {
                number = 80
              }
            }
          }
          path = "/argocd"
        }
      }
    }
  }
}

resource "kubernetes_ingress_v1" "argo_workflows_ingress" {
  depends_on = [helm_release.argo_workflows]
  metadata {
    name = "argo-workflows-ingress"
    namespace = helm_release.argo_workflows.namespace
    labels = {
      app = "argo-workflows"
    }
    annotations = {
      "ingress.kubernetes.io/ssl-redirect" = false
    }
  }

  spec {
    rule {
      http {
        path {
          backend {
            service {
              name = "argo-workflows-server"
              port {
                number = 2746
              }
            }
          }
          path = "/"
        }
      }
    }
  }
}
