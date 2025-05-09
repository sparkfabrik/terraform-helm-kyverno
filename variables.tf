variable "create_namespace" {
  description = "Create namespace for Kyverno. If false, the namespace must be created before using this module."
  type        = bool
  default     = true
}

variable "namespace" {
  description = "Namespace of Kyverno."
  type        = string
}

variable "k8s_default_labels" {
  description = "Labels to apply to the kubernetes resources. These are opinionated labels, you can add more labels using the variable `k8s_additional_labels`. If you want to remove a label, you can override it with an empty map(string)."
  type        = map(string)
  default = {
    managed-by = "terraform"
    scope      = "kyverno"
  }
}

variable "k8s_additional_labels" {
  description = "Additional labels to apply to the kubernetes resources."
  type        = map(string)
  default     = {}
}

variable "helm_release_name" {
  description = "The name of the Helm release."
  type        = string
  default     = "kyverno"
}

variable "helm_chart_version" {
  description = "The version of kyverno Helm chart."
  type        = string
  default     = "3.3.7"
}

variable "helm_additional_values" {
  description = "Additional values to be passed to the Helm chart."
  type        = list(string)
  default     = []
}

variable "node_affinity" {
  description = "Node affinity settings for Kyverno deployments. Use weight as map key; operator is `In` and policy is `preferredDuringSchedulingIgnoredDuringExecution`. This variable configures the node affinity for the `admissioncontroller`, `backgroundcontroller`, `cleanupcontroller` and `reportscontroller`. If defined, the value of this variable will be completely overwritten by the `*_node_affinity` configuration specific for each component."
  type = map(object({
    key    = string
    values = list(string)
  }))
  default = null
}

variable "admissioncontroller_node_affinity" {
  description = "Node affinity settings for `admissioncontroller` deployment. Use weight as map key; operator is `In` and policy is `preferredDuringSchedulingIgnoredDuringExecution`. If not null, the `node_affinity` value will be completely overwritten for the `admissioncontroller` deployment."
  type = map(object({
    key    = string
    values = list(string)
  }))
  default = null
}

variable "backgroundcontroller_node_affinity" {
  description = "Node affinity settings for backgroundcontroller deployment. Use weight as map key; operator is `In` and policy is `preferredDuringSchedulingIgnoredDuringExecution`. If not null, the `node_affinity` value will be completely overwritten for the `backgroundcontroller` deployment."
  type = map(object({
    key    = string
    values = list(string)
  }))
  default = null
}

variable "cleanupcontroller_node_affinity" {
  description = "Node affinity settings for cleanupcontroller deployment. Use weight as map key; operator is `In` and policy is `preferredDuringSchedulingIgnoredDuringExecution`. If not null, the `node_affinity` value will be completely overwritten for the `cleanupcontroller` deployment."
  type = map(object({
    key    = string
    values = list(string)
  }))
  default = null
}

variable "reportscontroller_node_affinity" {
  description = "Node affinity settings for reportscontroller deployment. Use weight as map key; operator is `In` and policy is `preferredDuringSchedulingIgnoredDuringExecution`. If not null, the `node_affinity` value will be completely overwritten for the `reportscontroller` deployment."
  type = map(object({
    key    = string
    values = list(string)
  }))
  default = null
}

variable "tolerations" {
  description = "Tolerations for Kyverno deployments. If not null it will populate the values file global tolerations."
  type = list(object({
    key      = string
    operator = string
    value    = string
    effect   = string
  }))
  default = []
}

variable "admissioncontroller_tolerations" {
  description = "Tolerations for admissioncontroller deployment. If not null will populate the values file admissioncontroller tolerations."
  type = list(object({
    key      = string
    operator = string
    value    = string
    effect   = string
  }))
  default = []
}

variable "backgroundcontroller_tolerations" {
  description = "Tolerations for backgroundcontroller deployment. If not null will populate the values file backgroundcontroller tolerations."
  type = list(object({
    key      = string
    operator = string
    value    = string
    effect   = string
  }))
  default = []
}

variable "cleanupcontroller_tolerations" {
  description = "Tolerations for cleanupcontroller deployment. If not null will populate the values file cleanupcontroller tolerations."
  type = list(object({
    key      = string
    operator = string
    value    = string
    effect   = string
  }))
  default = []
}

variable "reportscontroller_tolerations" {
  description = "Tolerations for reportscontroller deployment. If not null will populate the values file reportscontroller tolerations."
  type = list(object({
    key      = string
    operator = string
    value    = string
    effect   = string
  }))
  default = []
}

variable "excluded_namespaces" {
  type        = list(string)
  description = "The list of namespaces to exclude from the Kyverno policies."
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

# Configuration for HA deployment of Kyverno
# https://kyverno.io/docs/installation/methods/#high-availability-installation
variable "admission_controller_replicas" {
  description = "The number of replicas for the Kyverno admission controller."
  type        = number
  default     = 3
}

variable "backgroundcontroller_replicas" {
  description = "The number of replicas for the Kyverno background controller."
  type        = number
  default     = 3
}

variable "cleanupcontroller_replicas" {
  description = "The number of replicas for the Kyverno cleanup controller."
  type        = number
  default     = 2
}

variable "reportscontroller_replicas" {
  description = "The number of replicas for the Kyverno reports controller."
  type        = number
  default     = 2
}

variable "admissioncontroller_sa" {
  description = "The service account for the Kyverno admission controller."
  type        = string
  default     = "kyverno-admission-controller"
}

variable "backgroundcontroller_sa" {
  description = "The service account for the Kyverno background controller."
  type        = string
  default     = "kyverno-background-controller"
}

variable "cleanupcontroller_sa" {
  description = "The service account for the Kyverno cleanup controller."
  type        = string
  default     = "kyverno-cleanup-controller"
}

variable "reportscontroller_sa" {
  description = "The service account for the Kyverno reports controller."
  type        = string
  default     = "kyverno-reports-controller"
}

variable "policy_docker_hub_mirror" {
  type = object({
    enabled              = optional(bool, false)
    destination_registry = optional(string, "")
  })
  default = {
    enabled              = false
    destination_registry = ""
  }
  description = "Values for the mutating Kyverno policy to redirect the DockerHub registry to a mirror/cache registry. Needs only the destination registry url (e.g.: `my.awesome-cache-registry.com`)."
}

variable "custom_registry_policies" {
  type = map(object({
    registry_title         = string
    registry_remote_mirror = string
    description            = string
  }))
  description = "Custom configuration for the mutating Kyverno policy. Use the registry URL as the key (e.g.: 'index.docker.io'), `registry_title` as the name used to create the title in the policy, and `registry_remote_mirror` as the registry remote mirror URL (e.g.: `my.awesome-private-registry.com/my-awesome-namespace`)."
  default     = {}

  validation {
    condition = alltrue([
      for key, value in var.custom_registry_policies : can(regex("^[a-zA-Z0-9-]+$", value.registry_title))
    ])
    error_message = "The registry_title must be alphanumeric, can contain hyphens only (use to create Kubernetes resource names, RFC 1123)"
  }
}
