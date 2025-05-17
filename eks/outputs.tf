output "eks_api_endpoint" {
  value       = aws_eks_cluster.main.endpoint
  description = "API server endpoint"
}

output "k8s_token" {
  value       = data.aws_eks_cluster_auth.default.token
  description = "The EKS authentication token"
}

output "cluster_ca_certificate" {
  value       = base64decode(aws_eks_cluster.main.certificate_authority.0.data)
  description = "The EKS API certificate"
}

output "cluster_name" {
  value       = aws_eks_cluster.main.name
  description = "The EKS cluster name"
}