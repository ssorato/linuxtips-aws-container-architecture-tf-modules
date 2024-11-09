
resource "aws_iam_role" "api_gateway_logging" {

  name = format("%s-api-gateway-logging", var.project_name)

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "apigateway.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = merge(
    {
      Name = format("%s-api-gateway-logging", var.project_name)
    },
    var.common_tags
  )
}

resource "aws_iam_role_policy_attachment" "api_gateway_logging" {
  role       = aws_iam_role.api_gateway_logging.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonAPIGatewayPushToCloudWatchLogs"
}

resource "aws_api_gateway_account" "main" {
  cloudwatch_role_arn = aws_iam_role.api_gateway_logging.arn
}
