output "ssm_target_group_01" {
  value       = aws_ssm_parameter.cluster_01.id
  description = "The target id about EKS cluster 01"
}

output "ssm_target_group_02" {
  value       = aws_ssm_parameter.cluster_02.id
  description = "The target id about EKS cluster 02"
}
