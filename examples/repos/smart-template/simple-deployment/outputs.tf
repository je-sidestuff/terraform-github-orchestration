output "repo_name" {
  value       = local.example_repo
  description = "The name of the created repo."
}

output "init_result" {
  value       = module.example_smart_template_deployment.init_result
  description = "The initialization result for the deployed repository."
}
