<!-- BEGIN_TF_DOCS -->
# Linuxtips course: Container architecture on AWS terraform modules

Day 5: ECS application

## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_ecs_service"></a> [ecs\_service](#module\_ecs\_service) | ../ecs_service | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_iam_role.ecs_task_execution_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.ecs_task_execution_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_ssm_parameter.alb_arn](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssm_parameter) | data source |
| [aws_ssm_parameter.alb_listener_arn](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssm_parameter) | data source |
| [aws_ssm_parameter.private_subnet](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssm_parameter) | data source |
| [aws_ssm_parameter.vpc_id](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssm_parameter) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | The AWS region | `string` | `"us-east-1"` | no |
| <a name="input_cloudwatch_scale"></a> [cloudwatch\_scale](#input\_cloudwatch\_scale) | Cloudwatch scale parameters | <pre>object({<br>    out_statistic           = string<br>    out_cpu_threshold       = number<br>    out_adjustment          = number<br>    out_comparison_operator = string<br>    out_period              = number<br>    out_evaluation_periods  = number<br>    in_statistic            = string<br>    in_cpu_threshold        = number<br>    in_adjustment           = number<br>    in_comparison_operator  = string<br>    in_period               = number<br>    in_evaluation_periods   = number<br>  })</pre> | n/a | yes |
| <a name="input_common_scale"></a> [common\_scale](#input\_common\_scale) | Common scale parameters | <pre>object({<br>    scale_type   = string<br>    task_maximum = number<br>    task_minimum = number<br>    task_desired = number<br>    in_cooldown  = number<br>    out_cooldown = number<br>  })</pre> | n/a | yes |
| <a name="input_common_tags"></a> [common\_tags](#input\_common\_tags) | Common tags | `map(string)` | <pre>{<br>  "created_by": "terraform-linuxtips-aws-container-architecture",<br>  "day": "day5",<br>  "sandbox": "linuxtips"<br>}</pre> | no |
| <a name="input_container_image"></a> [container\_image](#input\_container\_image) | The container image used by ECS application | `string` | n/a | yes |
| <a name="input_ecs_service"></a> [ecs\_service](#input\_ecs\_service) | ECS service | <pre>object({<br>    name      = string<br>    port      = number<br>    cpu       = number<br>    memory_mb = number<br>    ecs_name  = string<br>    environment_variables = list(object({<br>      name : string<br>      value : string<br>    }))<br>    capabilities        = list(string)<br>    service_healthcheck = map(any)<br>    service_launch_type = list(object({<br>      capacity_provider = string<br>      weight            = number<br>    }))<br>    service_hosts       = list(string)<br>  })</pre> | n/a | yes |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | The resource name sufix | `string` | `"linuxtips"` | no |
| <a name="input_ssm_alb_arn"></a> [ssm\_alb\_arn](#input\_ssm\_alb\_arn) | The ALB arn from AWS Systems Manager Parameter Store | `string` | n/a | yes |
| <a name="input_ssm_alb_listener_arn"></a> [ssm\_alb\_listener\_arn](#input\_ssm\_alb\_listener\_arn) | The ALB listernet arn from AWS Systems Manager Parameter Store | `string` | n/a | yes |
| <a name="input_ssm_private_subnet_list"></a> [ssm\_private\_subnet\_list](#input\_ssm\_private\_subnet\_list) | A list of private subnet id in the AWS Systems Manager Parameter Store | `list(string)` | n/a | yes |
| <a name="input_ssm_vpc_id"></a> [ssm\_vpc\_id](#input\_ssm\_vpc\_id) | The VPC id in the AWS Systems Manager Parameter Store | `string` | n/a | yes |
| <a name="input_tracking_scale_cpu"></a> [tracking\_scale\_cpu](#input\_tracking\_scale\_cpu) | Tracking scale using CPU percentage for the metric | `number` | n/a | yes |
| <a name="input_tracking_scale_requests"></a> [tracking\_scale\_requests](#input\_tracking\_scale\_requests) | Tracking scale using number of requests for the metric | `number` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->