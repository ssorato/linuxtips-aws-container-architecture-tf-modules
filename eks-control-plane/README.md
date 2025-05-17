<!-- BEGIN_TF_DOCS -->
# Linuxtips course: Container architecture on AWS terraform modules

Day 35-38: ArgoCD multiclusters management - EKS Control Plane

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_kubectl"></a> [kubectl](#requirement\_kubectl) | >= 1.19.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |
| <a name="provider_helm"></a> [helm](#provider\_helm) | n/a |
| <a name="provider_kubectl"></a> [kubectl](#provider\_kubectl) | >= 1.19.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_eks-control-plane"></a> [eks-control-plane](#module\_eks-control-plane) | ../eks | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_eks_access_entry.argocd](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_access_entry) | resource |
| [aws_eks_access_policy_association.argocd](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_access_policy_association) | resource |
| [aws_eks_pod_identity_association.argo_application_controller](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_pod_identity_association) | resource |
| [aws_eks_pod_identity_association.argo_applicationset_controller](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_pod_identity_association) | resource |
| [aws_eks_pod_identity_association.argo_server](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_pod_identity_association) | resource |
| [aws_eks_pod_identity_association.chartmuseum](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_pod_identity_association) | resource |
| [aws_iam_policy.argocd_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.chartmuseum_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy_attachment.argocd_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy_attachment) | resource |
| [aws_iam_policy_attachment.chartmuseum](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy_attachment) | resource |
| [aws_iam_role.argo_deployer](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.argocd](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.chartmuseum_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_lb.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb) | resource |
| [aws_lb_listener.http](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener) | resource |
| [aws_lb_listener.https](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener) | resource |
| [aws_lb_target_group.argo](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group) | resource |
| [aws_route53_record.argocd](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_s3_bucket.chartmuseum](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_acl.chartmuseum](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_acl) | resource |
| [aws_s3_bucket_ownership_controls.chartmuseum](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_ownership_controls) | resource |
| [aws_security_group.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [helm_release.argocd](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.chartmuseum](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [kubectl_manifest.argo_clusters](https://registry.terraform.io/providers/gavinbunney/kubectl/latest/docs/resources/manifest) | resource |
| [kubectl_manifest.argo_rollouts](https://registry.terraform.io/providers/gavinbunney/kubectl/latest/docs/resources/manifest) | resource |
| [kubectl_manifest.argo_system](https://registry.terraform.io/providers/gavinbunney/kubectl/latest/docs/resources/manifest) | resource |
| [kubectl_manifest.argocd_target_group](https://registry.terraform.io/providers/gavinbunney/kubectl/latest/docs/resources/manifest) | resource |
| [kubectl_manifest.keda](https://registry.terraform.io/providers/gavinbunney/kubectl/latest/docs/resources/manifest) | resource |
| [kubectl_manifest.metrics_server](https://registry.terraform.io/providers/gavinbunney/kubectl/latest/docs/resources/manifest) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_eks_cluster.members](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster) | data source |
| [aws_iam_policy_document.argocd_assume_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.argocd_deployer_assume_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.argocd_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.chartmuseum_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.chartmuseum_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_ssm_parameter.acm_arn](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssm_parameter) | data source |
| [aws_ssm_parameter.lb_subnets](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssm_parameter) | data source |
| [aws_ssm_parameter.vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssm_parameter) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_alb_public_access_cidrs"></a> [alb\_public\_access\_cidrs](#input\_alb\_public\_access\_cidrs) | List of CIDR blocks that can access the shared load balancer | `list(string)` | <pre>[<br/>  "0.0.0.0/0"<br/>]</pre> | no |
| <a name="input_clusters_configs"></a> [clusters\_configs](#input\_clusters\_configs) | The list of EKS clusters to be configured in the ArgoCD | <pre>list(object({<br/>    cluster_name = string<br/>  }))</pre> | n/a | yes |
| <a name="input_common_tags"></a> [common\_tags](#input\_common\_tags) | Common tags | `map(string)` | n/a | yes |
| <a name="input_eks_api_public_access_cidrs"></a> [eks\_api\_public\_access\_cidrs](#input\_eks\_api\_public\_access\_cidrs) | List of CIDR blocks that can access the Amazon EKS public API server endpoint when enabled | `list(string)` | <pre>[<br/>  "0.0.0.0/0"<br/>]</pre> | no |
| <a name="input_karpenter_capacity"></a> [karpenter\_capacity](#input\_karpenter\_capacity) | n/a | <pre>list(object({<br/>    name               = string<br/>    workload           = string<br/>    ami_family         = string<br/>    ami_ssm            = string<br/>    instance_family    = list(string)<br/>    instance_sizes     = list(string)<br/>    capacity_type      = list(string)<br/>    availability_zones = list(string)<br/>  }))</pre> | n/a | yes |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | The resource name sufix | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | The AWS region | `string` | n/a | yes |
| <a name="input_route53"></a> [route53](#input\_route53) | Route53 dns name and hosted zone | <pre>object({<br/>    dns_name    = string<br/>    hosted_zone = string<br/>  })</pre> | n/a | yes |
| <a name="input_ssm_acm_arn"></a> [ssm\_acm\_arn](#input\_ssm\_acm\_arn) | The ACM arnfrom AWS SSM parameters | `string` | n/a | yes |
| <a name="input_ssm_natgw_eips"></a> [ssm\_natgw\_eips](#input\_ssm\_natgw\_eips) | NAT gw EIP from AWS SSM parameters | `list(string)` | n/a | yes |
| <a name="input_ssm_pod_subnets"></a> [ssm\_pod\_subnets](#input\_ssm\_pod\_subnets) | PODs subnets from AWS SSM parameters | `list(string)` | n/a | yes |
| <a name="input_ssm_private_subnets"></a> [ssm\_private\_subnets](#input\_ssm\_private\_subnets) | Private subnets from AWS SSM parameters | `list(string)` | n/a | yes |
| <a name="input_ssm_public_subnets"></a> [ssm\_public\_subnets](#input\_ssm\_public\_subnets) | Public subnets from AWS SSM parameters | `list(string)` | n/a | yes |
| <a name="input_ssm_vpc"></a> [ssm\_vpc](#input\_ssm\_vpc) | The main VPC from AWS SSM parameters | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_s3_chartmuseum_id"></a> [s3\_chartmuseum\_id](#output\_s3\_chartmuseum\_id) | The Chart Museum s3 bucket id |
<!-- END_TF_DOCS -->