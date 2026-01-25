locals {
  random_result = random_string.random.result
}

resource "github_repository" "narrative_repo" {
  name        = var.name
  description = var.description
  visibility  = var.visibility

  is_template = false

  auto_init = true
}

# This file will have content changes ignored so the implementer can create their own logic.
resource "github_repository_file" "readme" {
  repository          = github_repository.narrative_repo.name
  branch              = "main"
  file                = "README.md"
  content             = file("${path.module}/repo_root/README.md")
  commit_message      = "Managed by Terraform."
  commit_author       = "Terraform User"
  commit_email        = "terraform@example.com"
  overwrite_on_create = true
}

resource "random_string" "random" {
  length  = 8
  special = false
}
