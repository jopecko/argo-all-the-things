# https://stepan111.github.io/Terraform/Minio.html

resource "helm_release" "minio_operator" {
  depends_on = [kubernetes_namespace.minio-operator]
  name = "minio-operator"

  repository       = "https://operator.min.io/"
  chart            = "operator"
  version          = "7.0.0"
  namespace        = "minio-operator"
}

resource "helm_release" "minio_tenant" {
  depends_on = [kubernetes_namespace.tenant]
  name = "tenant"

  repository       = "https://operator.min.io/"
  chart            = "tenant"
  version          = "7.0.0"
  namespace        = "block-storage"

  values = [
    file("${path.module}/configs/minio-tenant-values.yaml")
  ]
}

resource "kubernetes_secret" "minio_creds" {
  metadata {
    name = "minio-creds"
    namespace = kubernetes_namespace.argo_workflows.metadata.0.name
  }

  data = {
    access-key = "minio"
    secret-key = "minio123" #random_password.minio.result
  }

  type = "Opaque"
}
