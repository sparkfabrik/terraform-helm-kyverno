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

variable "is_aws" {
  description = "Whether the cluster is EKS or not"
  type        = bool
  default     = false
}

variable "is_gcp" {
  description = "Whether the cluster is EKS or not"
  type        = bool
  default     = false
}
