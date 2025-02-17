output "init_result" {
  value       = data.external.verify_successful_init.result
  description = "The initialization result for the deployed repository."
}
