/*
   # A simple example on how to use this module
 */
locals {
  policy_dockerhub_mirror = {
    enabled              = true
    destination_registry = "registry.example.org"
  }
}

module "kyverno" {
  source                   = "github.com/sparkfabrik/terraform-helm-kyverno?ref=0.1.0"
  namespace                = var.namespace
  chart_version            = var.chart_version
  is_aws                   = true
  excluded_namespaces      = var.excluded_namespaces
  policy_docker_hub_mirror = local.policy_dockerhub_mirror
}
