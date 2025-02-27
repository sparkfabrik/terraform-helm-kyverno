variable "namespace" {
  type        = string
  description = "The namespace where to install Kyverno"
  default     = "kyverno"
}

variable "chart_version" {
  type = string
}

variable "excluded_namespaces" {
  type        = list(string)
  description = "The list of namespaces to exclude from the Kyverno policies"
  default     = []

}

variable "is_eks" {
  description = "Whether the cluster is EKS or not"
  type        = bool
  default     = false
}


variable "pull_through_caches" {
  type = map(object({
    registry_title     = string
    pull_through_cache = string
  }))
  description = "The ECR pull-through configuration for the mutating Kyverno policy. Use the registry URL as the key (e.g. 'index.docker.io'), registry_title as the name used to create the title in the policy, and pull_through_cache as the ECR pull-through cache URL."
  default     = {}
  validation {
    condition = alltrue([
      for key, value in var.pull_through_caches : can(regex("^[a-zA-Z0-9-]+$", value.registry_title))
    ])
    error_message = "The registry_title must be alphanumeric, can contain hyphens only (use to create Kubernetes resource names, RFC 1123)"
  }
}

variable "artifact_registry_remote_mirrors" {
  type = map(object({
    registry_title                  = string
    artifact_registry_remote_mirror = string
  }))
  description = "The Artifact registry remote mirror configuration for the mutating Kyverno policy. Use the registry URL as the key (e.g. 'index.docker.io'), registry_title as the name used to create the title in the policy, and artifact_registry_remote_mirror  the Artifact registry remote mirror URL."
  default     = {}

  validation {
    condition = alltrue([
      for key, value in var.artifact_registry_remote_mirrors : can(regex("^[a-zA-Z0-9-]+$", value.registry_title))
    ])
    error_message = "The registry_title must be alphanumeric, can contain hyphens only (use to create Kubernetes resource names, RFC 1123)"
  }
}
