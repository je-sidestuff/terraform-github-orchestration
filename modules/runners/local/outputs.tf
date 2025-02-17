output "runner_installation_complete" {
  description = "An output that will resolve to true once the runner installation is complete."
  value       = null_resource.manage_runner_install.id != "Resolve when complete!"
}

output "runner_execution_complete" {
  description = "An output that will resolve to true once the runner installation is complete."
  value       = null_resource.manage_runner_execution.id != "Resolve when complete!"
}
