locals {
  k8s_common_labels = merge(
    var.k8s_default_labels,
    var.k8s_additional_labels,
  )
}

resource "kubernetes_namespace_v1" "this" {
  count = var.create_namespace ? 1 : 0

  metadata {
    labels = merge(
      {
        name = var.namespace
      },
      local.k8s_common_labels
    )
    name = var.namespace
  }
}

data "kubernetes_namespace_v1" "this" {
  count = var.create_namespace ? 0 : 1

  metadata {
    name = var.namespace
  }
}

resource "helm_release" "kyverno" {
  name       = var.helm_release_name
  repository = "https://kyverno.github.io/kyverno/"
  chart      = "kyverno"
  namespace  = var.create_namespace ? kubernetes_namespace_v1.this[0].metadata[0].name : data.kubernetes_namespace_v1.this[0].metadata[0].name
  version    = var.helm_chart_version

  values = concat(
    [
      templatefile("${path.module}/files/values.yaml.tftpl", {
        is_aws                             = var.is_aws
        is_gcp                             = var.is_gcp
        excluded_namespaces                = var.excluded_namespaces
        admissioncontroller_replicas       = var.admission_controller_replicas
        backgroundcontroller_replicas      = var.backgroundcontroller_replicas
        cleanupcontroller_replicas         = var.cleanupcontroller_replicas
        reportscontroller_replicas         = var.reportscontroller_replicas
        admissioncontroller_sa             = var.admissioncontroller_sa
        backgroundcontroller_sa            = var.backgroundcontroller_sa
        cleanupcontroller_sa               = var.cleanupcontroller_sa
        reportscontroller_sa               = var.reportscontroller_sa
        node_affinity                      = var.node_affinity
        admissioncontroller_node_affinity  = var.admissioncontroller_node_affinity
        backgroundcontroller_node_affinity = var.backgroundcontroller_node_affinity
        cleanupcontroller_node_affinity    = var.cleanupcontroller_node_affinity
        reportscontroller_node_affinity    = var.reportscontroller_node_affinity
        tolerations                        = var.tolerations
      })
    ],
    var.helm_additional_values
  )
}

# Policy to redirect the DockerHub registry to a mirror/cache registry.
resource "kubectl_manifest" "use_dockerhub_mirror" {
  count = var.policy_docker_hub_mirror == {} ? 0 : (var.policy_docker_hub_mirror.enabled ? 1 : 0)

  yaml_body = templatefile("${path.module}/files/replace_registry_url.yaml.tftpl", {
    registry           = "index.docker.io",
    registry_title     = "index-docker-io",
    registry_mirror    = var.policy_docker_hub_mirror.destination_registry,
    policy_description = "To avoid rate limiting and improve performance, replace index-docker-io image registry with a mirror registry.",
    labels             = local.k8s_common_labels
  })

  depends_on = [helm_release.kyverno]
}

# Policies to redirect a particular image registry to another registry.
resource "kubectl_manifest" "custom_registry_policies" {
  for_each = var.custom_registry_policies

  yaml_body = templatefile("${path.module}/files/replace_registry_url.yaml.tftpl", {
    registry           = each.key,
    registry_title     = each.value["registry_title"],
    registry_mirror    = each.value["registry_remote_mirror"],
    policy_description = each.value["description"],
    labels             = local.k8s_common_labels
  })

  depends_on = [helm_release.kyverno]
}

