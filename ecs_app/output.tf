output "ecr_repo_url" {
  value       = module.ecs_service.ecr_repo_url
  description = "The URL of the ECR repository"
}
