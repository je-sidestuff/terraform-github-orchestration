resource "github_repository" "to_deploy" {
  name        = var.name
  description = var.description

  visibility = var.visibility

  auto_init = true

  template {
    owner      = var.source_owner
    repository = var.template_repo_name
  }
}

resource "github_branch_default" "default" {
  repository = github_repository.to_deploy.name
  branch     = var.default_branch
}

resource "github_actions_secret" "actions_secrets" {
  repository      = github_repository.to_deploy.name
  secret_name     = "GH_PAT"
  plaintext_value = var.github_pat
}

# We will make an update later to use the GitHub CLI and inject secrets from environment variables
# (Keeping them out of state)
# resource "terraform_data" "inject_secrets_from_environment" {
#   provisioner "local-exec" {
#     command = <<EOT
# echo hi
# EOT
#   }
# }

resource "github_repository_file" "init_payload" {
  repository          = github_repository.to_deploy.name
  branch              = var.default_branch # TODO - test different default branches
  file                = "init_payload.json"
  content             = var.init_payload_content
  commit_message      = "Managed by Terraform."
  commit_author       = "Terraform User"
  commit_email        = "terraform@example.com"
  overwrite_on_create = true

  lifecycle {
    ignore_changes = [content]
  }
}

resource "github_release" "init" {
  name       = "Initialize Repository"
  repository = github_repository.to_deploy.name
  tag_name   = "init"
  draft      = false
  prerelease = false

  depends_on = [github_repository_file.init_payload]
}

data "external" "verify_successful_init" {
  program = ["bash", "${path.module}/verify_successful_init.sh"]

  query = {
    repo_https_clone_url = replace(
      github_repository.to_deploy.http_clone_url, "https://", "https://${var.github_pat}@"
    )
  }
} # TODO - determine success based on output of this data source
