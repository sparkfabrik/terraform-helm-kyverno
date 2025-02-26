locals {
  aws_system_namespaces    = ["amazon-cloudwatch", "aws-system"]
  gcp_system_namespaces    = ["gpm-system", "gpm-public"]
  excluded_namespaces_list = var.is_eks ? concat(var.excluded_namespaces, local.aws_system_namespaces) : concat(var.excluded_namespaces, local.gcp_system_namespaces)
}

resource "kubernetes_namespace_v1" "kyverno" {
  metadata {
    labels = {
      name = var.namespace
    }
    name = var.namespace
  }
}

resource "helm_release" "kyverno" {
  name       = "kyverno"
  repository = "https://kyverno.github.io/kyverno/"
  chart      = "kyverno"
  namespace  = kubernetes_namespace_v1.kyverno.metadata[0].name
  version    = var.chart_version

  values = [
    templatefile("${path.module}/files/values.yaml.tftpl", {
      excluded_namespaces = local.excluded_namespaces_list
    })
  ]
}

# Policies to redirect a particular image registry to the ECR pull-through cache.

resource "kubectl_manifest" "pull_through_caches" {
  for_each = var.pull_through_caches

  yaml_body = templatefile("${path.module}/files/use_pull_through_cache.yaml.tftpl", {
    registry           = each.key,
    registry_title     = each.value["registry_title"],
    pull_through_cache = each.value["pull_through_cache"],
  })

  depends_on = [helm_release.kyverno]
}

resource "kubectl_manifest" "artifact_registry_remote_mirrors" {
  for_each = var.artifact_registry_remote_mirrors

  yaml_body = templatefile("${path.module}/files/use_artifact_registry_remote_mirror.yaml.tftpl", {
    registry                        = each.key,
    registry_title                  = each.value["registry_title"],
    artifact_registry_remote_mirror = each.value["artifact_registry_remote_mirror"],
  })

  depends_on = [helm_release.kyverno]
}


# module "kyverno" {
#   source = "./modules/eks/modules/kyverno"

#   namespace                            = local.kyverno_namespace
#   chart_version                        = local.kyverno_chart_version
#   crossplane_provider_config_stage     = module.crossplane.sql_provider_config_name_stage
#   crossplane_provider_config_prod      = module.crossplane.sql_provider_config_name
#   crossplane_provider_config_corporate = module.crossplane.sql_provider_config_name_corporate
#   # @TODO: when all stages will be migrated to the new DB, remove the `wrong_db_failure_action` configuration.
#   # The `wrong_db_failure_action` default value is `Enforce`, which means that the policy will enforce the rules.
#   wrong_db_failure_action = "Audit"
#   pull_through_caches = {
#     "index.docker.io" : {
#       registry_title     = "index-docker-io"
#       pull_through_cache = "${local.ecr_base_url}/${aws_ecr_pull_through_cache_rule.ecr_pullthroughcache_docker_hub.id}"
#     }
#   }
# }
