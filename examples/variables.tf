variable "namespace" {
  description = "Namespace of Kyverno."
  type        = string
}

variable "chart_version" {
  type        = string
  default     = "3.3.7"
  description = "The version of the Kyverno chart to install."
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
