variable "common_tags" {
  type        = map(string)
  description = "Common tags"
}

variable "project_name" {
  type        = string
  description = "The resource name sufix"
}

variable "aws_region" {
  type        = string
  description = "The AWS region"
}

variable "ecs_service_name" {
  type        = string
  description = "The name of the ECS service"
}

variable "ecs_service_port" {
  type        = number
  description = "The port of the ECS service"
}

# can be set as string? https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task_definition_parameters.html#task_size
# For example, you can specify a CPU value either as 1024 in CPU units or 1 vCPU in vCPUs.
# When the task definition is registered, a vCPU value is converted to an integer indicating the CPU units.
variable "ecs_service_cpu" {
  type        = number
  description = "The hard limit of CPU units to present for the task"
}

# can be set as string? default is in MiB
variable "ecs_service_memory_mb" {
  type        = number
  description = "The hard limit of memory, in MiB, to present to the task"
}

variable "ecs_name" {
  type        = string
  description = "The ECS cluster name"
}

variable "vpc_id" {
  type        = string
  description = "The VPC id"
}

variable "private_subnets" {
  type        = list(string)
  description = "The private subnet list"
}

variable "alb_listener_arn" {
  type        = string
  description = "The ALB listener arn"
}

variable "service_task_execution_role_arn" {
  type        = string
  description = "The IAM task execution role arn"
}

variable "environment_variables" {
  type = list(object({
    name : string
    value : string
  }))
  description = "Environment variables used by ECS service"
  default     = []
}

variable "capabilities" {
  type        = list(string)
  description = "Capacity list like EC2 or FARGATE"
  default     = []
}

variable "service_healthcheck" {
  type        = map(any)
  description = "ECS service healthcheck parameters"
}

variable "service_launch_type" {
  type        = string
  description = "Launch Types about capacity providers available in the cluster"
}

variable "service_hosts" {
  type        = list(string)
  description = "Hosts associated to the service ( dns name )"
}

variable "service_listener_arn" {
  type        = string
  description = "ALB listner arn used by the ECS service"
}

variable "common_scale" {
  type = object({
    scale_type   = string
    task_maximum = number
    task_minimum = number
    task_desired = number
    in_cooldown  = number
    out_cooldown = number
  })
  description = <<EOT
    Common scale parameters:
    scale_type: the type of autoscaling (cpu, cpu_tracking or requests_tracking)
    task_maximum: maximum number of tasks 
    task_minimum: minimum number of tasks 
    task_desired: desired number of tasks 
    (in|out)_cooldown: amount of time, in seconds, after a scaling activity completes and before the next scaling activity can start
  EOT
  validation {
    condition     = var.common_scale.scale_type == "cpu" || var.common_scale.scale_type == "cpu_tracking" || var.common_scale.scale_type == "requests_tracking"
    error_message = "Scale type can be cpu or cpu_tracking or requests_tracking"
  }
  validation {
    condition     = var.common_scale.task_maximum >= var.common_scale.task_minimum
    error_message = "The maximum number of tasks must be greater than or equal to the minimum number"
  }
  validation {
    condition     = var.common_scale.task_desired >= var.common_scale.task_minimum && var.common_scale.task_desired <= var.common_scale.task_maximum
    error_message = "The number of desired tasks must be between the minimum and maximum number"
  }
}

variable "cloudwatch_scale" {
  type = object({
    out_statistic           = string
    out_cpu_threshold       = number
    out_adjustment          = number
    out_comparison_operator = string
    out_period              = number
    out_evaluation_periods  = number
    in_statistic            = string
    in_cpu_threshold        = number
    in_adjustment           = number
    in_comparison_operator  = string
    in_period               = number
    in_evaluation_periods   = number
  })
  description = <<EOT
    Cloudwatch scale parameters:
    (in|out)_statistic: the statistic to apply to the alarm's associated metric
    (in|out)_cpu_threshold: the value against which the specified statistic is compared
    (in|out)_adjustment: number of members by which to scale, when the adjustment bounds are breached
    (in|out)_comparison_operator: the arithmetic operation to use when comparing the specified Statistic and Threshold
    (in|out)_period: the period in seconds over which the specified statistic is applied
    (in|out)_evaluation_periods: the number of periods over which data is compared to the specified threshold
  EOT
}

variable "tracking_scale_cpu" {
  type        = number
  description = "Tracking scale using CPU percentage for the metric"
}

variable "tracking_scale_requests" {
  type        = number
  description = "Tracking scale using number of requests for the metric"
}

variable "alb_arn" {
  type        = string
  description = "The ALB arn used by the ECS"
}