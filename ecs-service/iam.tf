#
# https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task_execution_IAM_role.html
# The task execution role grants the Amazon ECS container and Fargate agents permission to make AWS API calls on your behalf.
#

resource "aws_iam_role" "service_execution_role" {
  name = format("%s-%s-service-role", var.ecs_name, var.ecs_service_name)

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
        Effect = "Allow"
        Sid    = ""
      },
    ]
  })

  tags = merge(
    {
      Name = format("%s-%s-service-role", var.ecs_name, var.ecs_service_name)
    },
    var.common_tags
  )
}

resource "aws_iam_role_policy" "service_execution_role" {
  name = format("%s-%s-service-policy", var.ecs_name, var.ecs_service_name)
  role = aws_iam_role.service_execution_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "elasticloadbalancing:DeregisterInstancesFromLoadBalancer",
          "elasticloadbalancing:DeregisterTargets",
          "elasticloadbalancing:Describe*",
          "elasticloadbalancing:RegisterInstancesWithLoadBalancer",
          "elasticloadbalancing:RegisterTargets",
          "ec2:Describe*",
          "ec2:AuthorizeSecurityGroupIngress",
          "ecr:GetAuthorizationToken",
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "ssm:GetParameters",
          "secretsmanager:GetSecretValue"
        ],
        Resource = "*",
        Effect   = "Allow"
      },
    ]
  })
}

resource "aws_iam_role" "codedeploy" {
  count = var.deployment_controller == "CODE_DEPLOY" ? 1 : 0
  name  = format("%s-%s-codedeploy", var.ecs_name, var.ecs_service_name)

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Principal = {
          Service = "codedeploy.amazonaws.com"
        }
        Effect = "Allow"
        Sid    = ""
      },
    ]
  })

  tags = merge(
    {
      Name = format("%s-%s-codedeploy", var.ecs_name, var.ecs_service_name)
    },
    var.common_tags
  )
}

resource "aws_iam_role_policy_attachment" "codedeploy" {
  count      = var.deployment_controller == "CODE_DEPLOY" ? 1 : 0
  role       = aws_iam_role.codedeploy[count.index].name
  policy_arn = "arn:aws:iam::aws:policy/AWSCodeDeployRoleForECS"
}
