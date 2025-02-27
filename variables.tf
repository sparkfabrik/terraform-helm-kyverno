variable "create_namespace" {
  description = "Create namespace for the ingress controller. If false, the namespace must be created before using this module."
  type        = bool
  default     = true
}

variable "namespace" {
  description = "Namespace of the ingress controller."
  type        = string
}

variable "namespace_additional_labels" {
  description = "Additional labels for the namespace of the ingress controller."
  type        = map(string)
  default     = {}
}

variable "chart_version" {
  type = string
}

variable "excluded_namespaces" {
  type        = list(string)
  description = "The list of namespaces to exclude from the Kyverno policies"
  default     = []

}

variable "is_aws" {
  description = "Whether the cluster is on AWS or not. If true, the well known AWS EKS namespaces will be added to the excluded namespaces."
  type        = bool
  default     = false
}

variable "is_gcp" {
  description = "Whether the cluster is on GCP or not. If true, the well known GCP GKE namespaces will be added to the excluded namespaces."
  type        = bool
  default     = false
}

variable "admission_controller_replicas" {
  description = "The number of replicas for the Kyverno admission controller"
  type        = number
  default     = 3
}

variable "backgroundcontroller_replicas" {
  description = "The number of replicas for the Kyverno background controller"
  type        = number
  default     = 3
}

variable "cleanupcontroller_replicas" {
  description = "The number of replicas for the Kyverno cleanup controller"
  type        = number
  default     = 2
}

variable "reportscontroller_replicas" {
  description = "The number of replicas for the Kyverno reports controller"
  type        = number
  default     = 2
}

variable "policy_docker_hub_mirror" {
  type = object({
    enabled              = optional(bool, false)
    destination_registry = optional(string)
  })
  default = {
    enabled              = false
    destination_registry = "noregistry"
  }
  description = "Values for the mutating Kyverno policy to redirect the DockerHub registry to a mirror/cache registry. Needs only the destination registry url."
}

variable "custom_registry_policies" {
  type = map(object({
    registry_title         = string
    registry_remote_mirror = string
    description            = string
  }))
  description = "Custom configuration for the mutating Kyverno policy. Use the registry URL as the key (e.g. 'index.docker.io'), registry_title as the name used to create the title in the policy, and registry_remote_mirror  the registry remote mirror URL."
  default     = {}

  validation {
    condition = alltrue([
      for key, value in var.custom_registry_policies : can(regex("^[a-zA-Z0-9-]+$", value.registry_title))
    ])
    error_message = "The registry_title must be alphanumeric, can contain hyphens only (use to create Kubernetes resource names, RFC 1123)"
  }
}
