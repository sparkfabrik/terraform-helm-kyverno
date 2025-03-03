# Terraform Module Template

This Terraform module deploys and manages Kyverno, a Kubernetes native policy management tool, using Helm. It provides customizable options for configuring Kyverno components, such as the admission controller, background controller, and cleanup controller. Additionally, it allows for namespace creation and labeling, ensuring seamless integration with existing Kubernetes clusters.  

The module supports a set of basic policies:  

- redirecting from Docker Hub to a mirror/cache for image pulls.
- Custom redirects from one registry to another. 

**If your registry is private you have to give reader permissions to admissioncontroller-sa externally.**

As decriberd [here](https://kyverno.io/blog/2023/08/18/verifying-images-in-a-private-amazon-ecr-with-kyverno-and-iam-roles-for-service-accounts-irsa/) you can grant needed permissions using credentials or IAM Roles for Service Accounts (IRSA).

Additional policies will be implemented in future releases.

<!-- BEGIN_TF_DOCS -->
## Providers

| Name | Version |
|------|---------|
| <a name="provider_helm"></a> [helm](#provider\_helm) | >= 2.0 |
| <a name="provider_kubectl"></a> [kubectl](#provider\_kubectl) | >= 1.0 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | >= 2.3 |

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | >= 2.0 |
| <a name="requirement_kubectl"></a> [kubectl](#requirement\_kubectl) | >= 1.0 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | >= 2.3 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_admission_controller_replicas"></a> [admission\_controller\_replicas](#input\_admission\_controller\_replicas) | The number of replicas for the Kyverno admission controller. | `number` | `3` | no |
| <a name="input_admissioncontroller_node_affinity"></a> [admissioncontroller\_node\_affinity](#input\_admissioncontroller\_node\_affinity) | Node affinity settings for admissioncontroller pods. Use weight as map key; operator is `In` and policy is `preferredDuringSchedulingIgnoredDuringExecution`. | <pre>map(object({<br/>    key    = string<br/>    values = list(string)<br/>  }))</pre> | `null` | no |
| <a name="input_admissioncontroller_sa"></a> [admissioncontroller\_sa](#input\_admissioncontroller\_sa) | The service account for the Kyverno admission controller. | `string` | `"kyverno-admission-controller"` | no |
| <a name="input_backgroundcontroller_node_affinity"></a> [backgroundcontroller\_node\_affinity](#input\_backgroundcontroller\_node\_affinity) | Node affinity settings for backgroundcontroller pods. Use weight as map key; operator is `In` and policy is `preferredDuringSchedulingIgnoredDuringExecution`. | <pre>map(object({<br/>    key    = string<br/>    values = list(string)<br/>  }))</pre> | `null` | no |
| <a name="input_backgroundcontroller_replicas"></a> [backgroundcontroller\_replicas](#input\_backgroundcontroller\_replicas) | The number of replicas for the Kyverno background controller. | `number` | `3` | no |
| <a name="input_backgroundcontroller_sa"></a> [backgroundcontroller\_sa](#input\_backgroundcontroller\_sa) | The service account for the Kyverno background controller. | `string` | `"kyverno-background-controller"` | no |
| <a name="input_cleanupcontroller_node_affinity"></a> [cleanupcontroller\_node\_affinity](#input\_cleanupcontroller\_node\_affinity) | Node affinity settings for cleanupcontroller pods. Use weight as map key; operator is `In` and policy is `preferredDuringSchedulingIgnoredDuringExecution`. | <pre>map(object({<br/>    key    = string<br/>    values = list(string)<br/>  }))</pre> | `null` | no |
| <a name="input_cleanupcontroller_replicas"></a> [cleanupcontroller\_replicas](#input\_cleanupcontroller\_replicas) | The number of replicas for the Kyverno cleanup controller. | `number` | `2` | no |
| <a name="input_cleanupcontroller_sa"></a> [cleanupcontroller\_sa](#input\_cleanupcontroller\_sa) | The service account for the Kyverno cleanup controller. | `string` | `"kyverno-cleanup-controller"` | no |
| <a name="input_create_namespace"></a> [create\_namespace](#input\_create\_namespace) | Create namespace for Kyverno. If false, the namespace must be created before using this module. | `bool` | `true` | no |
| <a name="input_custom_registry_policies"></a> [custom\_registry\_policies](#input\_custom\_registry\_policies) | Custom configuration for the mutating Kyverno policy. Use the registry URL as the key (e.g.: 'index.docker.io'), `registry_title` as the name used to create the title in the policy, and `registry_remote_mirror` as the registry remote mirror URL (e.g.: `my.awesome-private-registry.com/my-awesome-namespace`). | <pre>map(object({<br/>    registry_title         = string<br/>    registry_remote_mirror = string<br/>    description            = string<br/>  }))</pre> | `{}` | no |
| <a name="input_excluded_namespaces"></a> [excluded\_namespaces](#input\_excluded\_namespaces) | The list of namespaces to exclude from the Kyverno policies. | `list(string)` | `[]` | no |
| <a name="input_helm_additional_values"></a> [helm\_additional\_values](#input\_helm\_additional\_values) | Additional values to be passed to the Helm chart. | `list(string)` | `[]` | no |
| <a name="input_helm_chart_version"></a> [helm\_chart\_version](#input\_helm\_chart\_version) | The version of kyverno Helm chart. | `string` | `"3.3.7"` | no |
| <a name="input_helm_release_name"></a> [helm\_release\_name](#input\_helm\_release\_name) | The name of the Helm release. | `string` | `"kyverno"` | no |
| <a name="input_is_aws"></a> [is\_aws](#input\_is\_aws) | Whether the cluster is on AWS or not. If true, the well known AWS EKS namespaces will be added to the excluded namespaces. | `bool` | `false` | no |
| <a name="input_is_gcp"></a> [is\_gcp](#input\_is\_gcp) | Whether the cluster is on GCP or not. If true, the well known GCP GKE namespaces will be added to the excluded namespaces. | `bool` | `false` | no |
| <a name="input_k8s_additional_labels"></a> [k8s\_additional\_labels](#input\_k8s\_additional\_labels) | Additional labels to apply to the kubernetes resources. | `map(string)` | `{}` | no |
| <a name="input_k8s_default_labels"></a> [k8s\_default\_labels](#input\_k8s\_default\_labels) | Labels to apply to the kubernetes resources. These are opinionated labels, you can add more labels using the variable `k8s_additional_labels`. If you want to remove a label, you can override it with an empty map(string). | `map(string)` | <pre>{<br/>  "managed-by": "terraform",<br/>  "scope": "kyverno"<br/>}</pre> | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Namespace of Kyverno. | `string` | n/a | yes |
| <a name="input_node_affinity"></a> [node\_affinity](#input\_node\_affinity) | Node affinity settings for Kyverno pods. Use weight as map key; operator is `In` and policy is `preferredDuringSchedulingIgnoredDuringExecution`. | <pre>map(object({<br/>    key    = string<br/>    values = list(string)<br/>  }))</pre> | `null` | no |
| <a name="input_policy_docker_hub_mirror"></a> [policy\_docker\_hub\_mirror](#input\_policy\_docker\_hub\_mirror) | Values for the mutating Kyverno policy to redirect the DockerHub registry to a mirror/cache registry. Needs only the destination registry url (e.g.: `my.awesome-cache-registry.com`). | <pre>object({<br/>    enabled              = optional(bool, false)<br/>    destination_registry = optional(string, "")<br/>  })</pre> | <pre>{<br/>  "destination_registry": "",<br/>  "enabled": false<br/>}</pre> | no |
| <a name="input_reportscontroller_node_affinity"></a> [reportscontroller\_node\_affinity](#input\_reportscontroller\_node\_affinity) | Node affinity settings for reportscontroller pods. Use weight as map key; operator is `In` and policy is `preferredDuringSchedulingIgnoredDuringExecution`. | <pre>map(object({<br/>    key    = string<br/>    values = list(string)<br/>  }))</pre> | `null` | no |
| <a name="input_reportscontroller_replicas"></a> [reportscontroller\_replicas](#input\_reportscontroller\_replicas) | The number of replicas for the Kyverno reports controller. | `number` | `2` | no |
| <a name="input_reportscontroller_sa"></a> [reportscontroller\_sa](#input\_reportscontroller\_sa) | The service account for the Kyverno reports controller. | `string` | `"kyverno-reports-controller"` | no |
| <a name="input_tolerations"></a> [tolerations](#input\_tolerations) | Tolerations for Kyverno pods. | <pre>list(object({<br/>    key      = string<br/>    operator = string<br/>    value    = string<br/>    effect   = string<br/>  }))</pre> | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_admissioncontroller_sa"></a> [admissioncontroller\_sa](#output\_admissioncontroller\_sa) | n/a |
| <a name="output_backgroundcontroller_sa"></a> [backgroundcontroller\_sa](#output\_backgroundcontroller\_sa) | n/a |
| <a name="output_cleanupcontroller_sa"></a> [cleanupcontroller\_sa](#output\_cleanupcontroller\_sa) | n/a |
| <a name="output_dockerhub_mirror_registry"></a> [dockerhub\_mirror\_registry](#output\_dockerhub\_mirror\_registry) | n/a |
| <a name="output_reportscontroller_sa"></a> [reportscontroller\_sa](#output\_reportscontroller\_sa) | n/a |

## Resources

| Name | Type |
|------|------|
| [helm_release.kyverno](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [kubectl_manifest.custom_registry_policies](https://registry.terraform.io/providers/gavinbunney/kubectl/latest/docs/resources/manifest) | resource |
| [kubectl_manifest.use_dockerhub_mirror](https://registry.terraform.io/providers/gavinbunney/kubectl/latest/docs/resources/manifest) | resource |
| [kubernetes_namespace_v1.this](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace_v1) | resource |
| [kubernetes_namespace_v1.this](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/data-sources/namespace_v1) | data source |

## Modules

No modules.

<!-- END_TF_DOCS -->
