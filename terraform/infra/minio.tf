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
    namespace = helm_release.argo_workflows.namespace
  }

  data = {
    access-key = "minio"
    secret-key = "minio123" #random_password.minio.result
  }

  type = "Opaque"
}

data "kubernetes_config_map" "argo_workflows_workflow_controller_configmap" {
  metadata {
    name = "argo-workflows-workflow-controller-configmap"
    namespace = helm_release.argo_workflows.namespace
  }
}

resource "kubernetes_config_map_v1_data" "argo_workflows_workflow_controller_configmap" {
  force = true

  metadata {
    name      = "argo-workflows-workflow-controller-configmap"
    namespace = helm_release.argo_workflows.namespace
  }

  data = {
    artifactRepository = <<EOF
archiveLogs: true
s3:
  bucket: workflow-artifacts
  endpoint: myminio-hl.block-storage.svc.cluster.local:9000
  insecure: true
  accessKeySecret:
    name: minio-creds
    key: access-key
  secretKeySecret:
    name: minio-creds
    key: secret-key
EOF
  }
}