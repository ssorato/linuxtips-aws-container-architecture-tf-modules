output "ecr_repo_url" {
  value = module.ecs_service.repository_url
  description = "The URL of the ECR repository"
}
