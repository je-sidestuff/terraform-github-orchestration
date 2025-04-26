locals {
  all_files_except_populate_templates = [
    for file in fileset("${path.module}/repo_root", "**") :
    file if file != ".smart-init/scripts/populate_templates.sh"
  ]
}

resource "github_repository" "template_repo" {
  name        = var.name
  description = var.description
  visibility  = var.visibility

  is_template = true

  auto_init = true
}

resource "github_repository_file" "included_files_other_than_populate_templates" {
  for_each = toset(local.all_files_except_populate_templates)

  repository          = github_repository.template_repo.name
  branch              = "main"
  file                = each.value
  content             = file("${path.module}/repo_root/${each.value}")
  commit_message      = "Managed by Terraform."
  commit_author       = "Terraform User"
  commit_email        = "terraform@example.com"
  overwrite_on_create = true
}

# This file will have content changes ignored so the implementer can create their own logic.
resource "github_repository_file" "populate_templates" {
  repository          = github_repository.template_repo.name
  branch              = "main"
  file                = ".github/workflows/init.yaml"
  content             = file("${path.module}/repo_root/.github/workflows/init.yaml")
  commit_message      = "Managed by Terraform."
  commit_author       = "Terraform User"
  commit_email        = "terraform@example.com"
  overwrite_on_create = true
  
  lifecycle {
    ignore_changes = [content]
  }
}
