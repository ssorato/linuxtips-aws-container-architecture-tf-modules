<!-- BEGIN_TF_DOCS -->
# Linuxtips course: Container architecture on AWS terraform modules

Day 5: ECS service with task

## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |
| <a name="provider_random"></a> [random](#provider\_random) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_alb_listener_rule.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/alb_listener_rule) | resource |
| [aws_alb_target_group.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/alb_target_group) | resource |
| [aws_appautoscaling_policy.cpu_high](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appautoscaling_policy) | resource |
| [aws_appautoscaling_policy.cpu_low](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appautoscaling_policy) | resource |
| [aws_appautoscaling_policy.target_tracking_cpu](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appautoscaling_policy) | resource |
| [aws_appautoscaling_policy.target_tracking_requests](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appautoscaling_policy) | resource |
| [aws_appautoscaling_target.ecs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appautoscaling_target) | resource |
| [aws_cloudwatch_log_group.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_cloudwatch_metric_alarm.cpu_high](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.cpu_low](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_ecs_service.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_service) | resource |
| [aws_ecs_task_definition.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_task_definition) | resource |
| [aws_iam_role.service_execution_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.service_execution_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_security_group.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [random_string.random](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |
| [aws_alb.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/alb) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_alb_arn"></a> [alb\_arn](#input\_alb\_arn) | The ALB arn used by the ECS | `string` | n/a | yes |
| <a name="input_alb_listener_arn"></a> [alb\_listener\_arn](#input\_alb\_listener\_arn) | The ALB listener arn | `string` | n/a | yes |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | The AWS region | `string` | n/a | yes |
| <a name="input_capabilities"></a> [capabilities](#input\_capabilities) | Capacity list like EC2 or FARGATE | `list(string)` | <pre>[<br>  "EC2"<br>]</pre> | no |
| <a name="input_cloudwatch_scale"></a> [cloudwatch\_scale](#input\_cloudwatch\_scale) | Cloudwatch scale parameters:<br>    (in\|out)\_statistic: the statistic to apply to the alarm's associated metric<br>    (in\|out)\_cpu\_threshold: the value against which the specified statistic is compared<br>    (in\|out)\_adjustment: number of members by which to scale, when the adjustment bounds are breached<br>    (in\|out)\_comparison\_operator: the arithmetic operation to use when comparing the specified Statistic and Threshold<br>    (in\|out)\_period: the period in seconds over which the specified statistic is applied<br>    (in\|out)\_evaluation\_periods: the number of periods over which data is compared to the specified threshold | <pre>object({<br>    out_statistic           = string<br>    out_cpu_threshold       = number<br>    out_adjustment          = number<br>    out_comparison_operator = string<br>    out_period              = number<br>    out_evaluation_periods  = number<br>    in_statistic            = string<br>    in_cpu_threshold        = number<br>    in_adjustment           = number<br>    in_comparison_operator  = string<br>    in_period               = number<br>    in_evaluation_periods   = number<br>  })</pre> | n/a | yes |
| <a name="input_common_scale"></a> [common\_scale](#input\_common\_scale) | Common scale parameters:<br>    scale\_type: the type of autoscaling (cpu, cpu\_tracking or requests\_tracking)<br>    task\_maximum: maximum number of tasks <br>    task\_minimum: minimum number of tasks <br>    task\_desired: desired number of tasks <br>    (in\|out)\_cooldown: amount of time, in seconds, after a scaling activity completes and before the next scaling activity can start | <pre>object({<br>    scale_type   = string<br>    task_maximum = number<br>    task_minimum = number<br>    task_desired = number<br>    in_cooldown  = number<br>    out_cooldown = number<br>  })</pre> | n/a | yes |
| <a name="input_common_tags"></a> [common\_tags](#input\_common\_tags) | Common tags | `map(string)` | n/a | yes |
| <a name="input_container_image"></a> [container\_image](#input\_container\_image) | The container image used by ECS application | `string` | n/a | yes |
| <a name="input_ecs_name"></a> [ecs\_name](#input\_ecs\_name) | The ECS cluster name | `string` | n/a | yes |
| <a name="input_ecs_service_cpu"></a> [ecs\_service\_cpu](#input\_ecs\_service\_cpu) | The hard limit of CPU units to present for the task | `number` | n/a | yes |
| <a name="input_ecs_service_memory_mb"></a> [ecs\_service\_memory\_mb](#input\_ecs\_service\_memory\_mb) | The hard limit of memory, in MiB, to present to the task | `number` | n/a | yes |
| <a name="input_ecs_service_name"></a> [ecs\_service\_name](#input\_ecs\_service\_name) | The name of the ECS service | `string` | n/a | yes |
| <a name="input_ecs_service_port"></a> [ecs\_service\_port](#input\_ecs\_service\_port) | The port of the ECS service | `number` | n/a | yes |
| <a name="input_environment_variables"></a> [environment\_variables](#input\_environment\_variables) | Environment variables used by ECS service | <pre>list(object({<br>    name : string<br>    value : string<br>  }))</pre> | `[]` | no |
| <a name="input_private_subnets"></a> [private\_subnets](#input\_private\_subnets) | The private subnet list | `list(string)` | n/a | yes |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | The resource name sufix | `string` | n/a | yes |
| <a name="input_service_healthcheck"></a> [service\_healthcheck](#input\_service\_healthcheck) | ECS service healthcheck parameters | `map(any)` | n/a | yes |
| <a name="input_service_hosts"></a> [service\_hosts](#input\_service\_hosts) | Hosts associated to the service ( dns name ) | `list(string)` | n/a | yes |
| <a name="input_service_launch_type"></a> [service\_launch\_type](#input\_service\_launch\_type) | Launch Types about capacity providers available in the cluster | <pre>list(object({<br>    capacity_provider = string<br>    weight            = number<br>  }))</pre> | <pre>[<br>  {<br>    "capacity_provider": "SPOT",<br>    "weight": 100<br>  }<br>]</pre> | no |
| <a name="input_service_listener_arn"></a> [service\_listener\_arn](#input\_service\_listener\_arn) | ALB listner arn used by the ECS service | `string` | n/a | yes |
| <a name="input_service_task_execution_role_arn"></a> [service\_task\_execution\_role\_arn](#input\_service\_task\_execution\_role\_arn) | The IAM task execution role arn | `string` | n/a | yes |
| <a name="input_tracking_scale_cpu"></a> [tracking\_scale\_cpu](#input\_tracking\_scale\_cpu) | Tracking scale using CPU percentage for the metric | `number` | n/a | yes |
| <a name="input_tracking_scale_requests"></a> [tracking\_scale\_requests](#input\_tracking\_scale\_requests) | Tracking scale using number of requests for the metric | `number` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | The VPC id | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->