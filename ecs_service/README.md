<!-- BEGIN_TF_DOCS -->
# Linuxtips course: Container architecture on AWS terraform modules

Day 12: ECS with CodeDeploy

## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |
| <a name="provider_local"></a> [local](#provider\_local) | n/a |
| <a name="provider_null"></a> [null](#provider\_null) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_alb_listener_rule.codedeploy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/alb_listener_rule) | resource |
| [aws_alb_listener_rule.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/alb_listener_rule) | resource |
| [aws_alb_target_group.blue](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/alb_target_group) | resource |
| [aws_alb_target_group.green](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/alb_target_group) | resource |
| [aws_alb_target_group.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/alb_target_group) | resource |
| [aws_appautoscaling_policy.cpu_high](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appautoscaling_policy) | resource |
| [aws_appautoscaling_policy.cpu_low](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appautoscaling_policy) | resource |
| [aws_appautoscaling_policy.target_tracking_cpu](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appautoscaling_policy) | resource |
| [aws_appautoscaling_policy.target_tracking_requests](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appautoscaling_policy) | resource |
| [aws_appautoscaling_target.ecs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appautoscaling_target) | resource |
| [aws_cloudwatch_log_group.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_cloudwatch_metric_alarm.cpu_high](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.cpu_low](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.rollback_alarm](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_codedeploy_app.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codedeploy_app) | resource |
| [aws_codedeploy_deployment_group.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codedeploy_deployment_group) | resource |
| [aws_ecs_service.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_service) | resource |
| [aws_ecs_task_definition.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_task_definition) | resource |
| [aws_iam_role.codedeploy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.service_execution_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.service_execution_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy_attachment.codedeploy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_security_group.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_service_discovery_service.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/service_discovery_service) | resource |
| [local_file.appspec](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [null_resource.deploy_codedeploy](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [null_resource.deploy_ecs](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [aws_alb.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/alb) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_alb_arn"></a> [alb\_arn](#input\_alb\_arn) | The ALB arn used by the ECS | `string` | `null` | no |
| <a name="input_alb_listener_arn"></a> [alb\_listener\_arn](#input\_alb\_listener\_arn) | The ALB listener arn | `string` | `null` | no |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | The AWS region | `string` | n/a | yes |
| <a name="input_capabilities"></a> [capabilities](#input\_capabilities) | Capacity list like EC2 or FARGATE | `list(string)` | <pre>[<br>  "EC2"<br>]</pre> | no |
| <a name="input_cloudwatch_log_retention_in_days"></a> [cloudwatch\_log\_retention\_in\_days](#input\_cloudwatch\_log\_retention\_in\_days) | Specifies the number of days you want to retain log events in the specified log group | `number` | `1` | no |
| <a name="input_cloudwatch_scale"></a> [cloudwatch\_scale](#input\_cloudwatch\_scale) | Cloudwatch scale parameters:<br>    (in\|out)\_statistic: the statistic to apply to the alarm's associated metric<br>    (in\|out)\_cpu\_threshold: the value against which the specified statistic is compared<br>    (in\|out)\_adjustment: number of members by which to scale, when the adjustment bounds are breached<br>    (in\|out)\_comparison\_operator: the arithmetic operation to use when comparing the specified Statistic and Threshold<br>    (in\|out)\_period: the period in seconds over which the specified statistic is applied<br>    (in\|out)\_evaluation\_periods: the number of periods over which data is compared to the specified threshold | <pre>object({<br>    out_statistic           = string<br>    out_cpu_threshold       = number<br>    out_adjustment          = number<br>    out_comparison_operator = string<br>    out_period              = number<br>    out_evaluation_periods  = number<br>    in_statistic            = string<br>    in_cpu_threshold        = number<br>    in_adjustment           = number<br>    in_comparison_operator  = string<br>    in_period               = number<br>    in_evaluation_periods   = number<br>  })</pre> | <pre>{<br>  "in_adjustment": null,<br>  "in_comparison_operator": null,<br>  "in_cpu_threshold": null,<br>  "in_evaluation_periods": null,<br>  "in_period": null,<br>  "in_statistic": null,<br>  "out_adjustment": null,<br>  "out_comparison_operator": null,<br>  "out_cpu_threshold": null,<br>  "out_evaluation_periods": null,<br>  "out_period": null,<br>  "out_statistic": null<br>}</pre> | no |
| <a name="input_codedeploy_deployment_option"></a> [codedeploy\_deployment\_option](#input\_codedeploy\_deployment\_option) | Indicates whether to route deployment traffic behind a load balancer. | `string` | `"WITH_TRAFFIC_CONTROL"` | no |
| <a name="input_codedeploy_deployment_type"></a> [codedeploy\_deployment\_type](#input\_codedeploy\_deployment\_type) | Indicates whether to run an in-place deployment or a blue/green deployment. | `string` | `"BLUE_GREEN"` | no |
| <a name="input_codedeploy_rollback_alarm"></a> [codedeploy\_rollback\_alarm](#input\_codedeploy\_rollback\_alarm) | Indicates whether the alarm configuration is enabled. | `bool` | `true` | no |
| <a name="input_codedeploy_rollback_error_evaluation_period"></a> [codedeploy\_rollback\_error\_evaluation\_period](#input\_codedeploy\_rollback\_error\_evaluation\_period) | Sets the number of evaluation periods before triggering rollback. | `number` | `1` | no |
| <a name="input_codedeploy_rollback_error_period"></a> [codedeploy\_rollback\_error\_period](#input\_codedeploy\_rollback\_error\_period) | Defines the period of time, in seconds, to evaluate the error during rollback. | `number` | `60` | no |
| <a name="input_codedeploy_rollback_error_threshold"></a> [codedeploy\_rollback\_error\_threshold](#input\_codedeploy\_rollback\_error\_threshold) | Defines the percentage error threshold that triggers rollback. | `number` | `10` | no |
| <a name="input_codedeploy_strategy"></a> [codedeploy\_strategy](#input\_codedeploy\_strategy) | CodeDeploy deployment strategy | `string` | `"CodeDeployDefault.ECSAllAtOnce"` | no |
| <a name="input_codedeploy_termination_wait_time_in_minutes"></a> [codedeploy\_termination\_wait\_time\_in\_minutes](#input\_codedeploy\_termination\_wait\_time\_in\_minutes) | The number of minutes to wait after a successful blue/green deployment before terminating instances from the original environment. | `number` | `2` | no |
| <a name="input_common_scale"></a> [common\_scale](#input\_common\_scale) | Common scale parameters:<br>    scale\_type: the type of autoscaling (cpu, cpu\_tracking, requests\_tracking or null)<br>    task\_maximum: maximum number of tasks <br>    task\_minimum: minimum number of tasks <br>    task\_desired: desired number of tasks <br>    (in\|out)\_cooldown: amount of time, in seconds, after a scaling activity completes and before the next scaling activity can start | <pre>object({<br>    scale_type   = optional(string, null)<br>    task_maximum = number<br>    task_minimum = number<br>    task_desired = number<br>    in_cooldown  = optional(number, null)<br>    out_cooldown = optional(number, null)<br>  })</pre> | n/a | yes |
| <a name="input_common_tags"></a> [common\_tags](#input\_common\_tags) | Common tags | `map(string)` | n/a | yes |
| <a name="input_container_image"></a> [container\_image](#input\_container\_image) | The container image used by ECS application | `string` | n/a | yes |
| <a name="input_deployment_controller"></a> [deployment\_controller](#input\_deployment\_controller) | Type of deployment controller: ECS or CODE\_DEPLOY | `string` | `"ECS"` | no |
| <a name="input_ecs_name"></a> [ecs\_name](#input\_ecs\_name) | The ECS cluster name | `string` | n/a | yes |
| <a name="input_ecs_service_cpu"></a> [ecs\_service\_cpu](#input\_ecs\_service\_cpu) | The hard limit of CPU units to present for the task | `number` | n/a | yes |
| <a name="input_ecs_service_memory_mb"></a> [ecs\_service\_memory\_mb](#input\_ecs\_service\_memory\_mb) | The hard limit of memory, in MiB, to present to the task | `number` | n/a | yes |
| <a name="input_ecs_service_name"></a> [ecs\_service\_name](#input\_ecs\_service\_name) | The name of the ECS service | `string` | n/a | yes |
| <a name="input_ecs_service_port"></a> [ecs\_service\_port](#input\_ecs\_service\_port) | The port of the ECS service | `number` | n/a | yes |
| <a name="input_efs_volumes"></a> [efs\_volumes](#input\_efs\_volumes) | EFS volume used in the ECS tasks | <pre>list(object({<br>    volume_name : string<br>    file_system_id : string<br>    file_system_root : string<br>    mount_point : string<br>    read_only : bool<br>  }))</pre> | `[]` | no |
| <a name="input_environment_variables"></a> [environment\_variables](#input\_environment\_variables) | Environment variables used by ECS service | <pre>list(object({<br>    name : string<br>    value : string<br>  }))</pre> | `[]` | no |
| <a name="input_private_subnets"></a> [private\_subnets](#input\_private\_subnets) | The private subnet list | `list(string)` | n/a | yes |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | The resource name sufix | `string` | n/a | yes |
| <a name="input_protocol"></a> [protocol](#input\_protocol) | The protocol used for the port mapping | `string` | `"tcp"` | no |
| <a name="input_secrets"></a> [secrets](#input\_secrets) | Secrets list coming from Secret Manager or Parameter Store | <pre>list(object({<br>    name : string<br>    valueFrom : string # ARN<br>  }))</pre> | `[]` | no |
| <a name="input_service_connect_arn"></a> [service\_connect\_arn](#input\_service\_connect\_arn) | n/a | `string` | `null` | no |
| <a name="input_service_connect_name"></a> [service\_connect\_name](#input\_service\_connect\_name) | Namespace name of the aws\_service\_discovery\_http\_namespace for use with Service Connect | `string` | `null` | no |
| <a name="input_service_discovery_namespace"></a> [service\_discovery\_namespace](#input\_service\_discovery\_namespace) | Service Discovery namespace id | `string` | `null` | no |
| <a name="input_service_healthcheck"></a> [service\_healthcheck](#input\_service\_healthcheck) | ECS service healthcheck parameters | `map(any)` | n/a | yes |
| <a name="input_service_hosts"></a> [service\_hosts](#input\_service\_hosts) | Hosts associated to the service ( dns name ) | `list(string)` | n/a | yes |
| <a name="input_service_launch_type"></a> [service\_launch\_type](#input\_service\_launch\_type) | Launch Types about capacity providers available in the cluster | <pre>list(object({<br>    capacity_provider = string<br>    weight            = number<br>  }))</pre> | <pre>[<br>  {<br>    "capacity_provider": "SPOT",<br>    "weight": 100<br>  }<br>]</pre> | no |
| <a name="input_service_protocol"></a> [service\_protocol](#input\_service\_protocol) | Service Connect: the application protocol that's used for the port mapping | `string` | `null` | no |
| <a name="input_service_task_execution_role_arn"></a> [service\_task\_execution\_role\_arn](#input\_service\_task\_execution\_role\_arn) | The IAM task execution role arn | `string` | n/a | yes |
| <a name="input_tracking_scale_cpu"></a> [tracking\_scale\_cpu](#input\_tracking\_scale\_cpu) | Tracking scale using CPU percentage for the metric | `number` | `null` | no |
| <a name="input_tracking_scale_requests"></a> [tracking\_scale\_requests](#input\_tracking\_scale\_requests) | Tracking scale using number of requests for the metric | `number` | `null` | no |
| <a name="input_use_lb"></a> [use\_lb](#input\_use\_lb) | Expose the service using an ALB | `bool` | `true` | no |
| <a name="input_use_service_connect"></a> [use\_service\_connect](#input\_use\_service\_connect) | Whether to use Service Connect with this service | `bool` | `false` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | The VPC id | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->