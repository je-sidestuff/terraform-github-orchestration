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

resource "time_sleep" "wait_for_repo" {
  depends_on = [github_repository.narrative_repo]

  create_duration = "5s"
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

  depends_on = [time_sleep.wait_for_repo]
}

resource "random_string" "random" {
  length  = 8
  special = false
}
