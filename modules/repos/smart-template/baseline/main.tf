locals {
  all_files_except_init_workflow = [ # TODO - now that we are tag driven we can remove this
    for file in fileset("${path.module}/repo_root", "**") :
    file if file != ".github/workflows/init.yaml"
  ]
}

resource "github_repository" "template_repo" {
  name        = var.name
  description = var.description
  visibility  = var.visibility

  is_template = true

  auto_init = true
}

resource "github_repository_file" "files_other_than_init_workflow" {
  for_each = toset(local.all_files_except_init_workflow)

  repository          = github_repository.template_repo.name
  branch              = "main"
  file                = each.value
  content             = file("${path.module}/repo_root/${each.value}")
  commit_message      = "Managed by Terraform."
  commit_author       = "Terraform User"
  commit_email        = "terraform@example.com"
  overwrite_on_create = true
}

# This workflow will be prevented from running to completion for a template repo,
# But by pushing this file last we can still avoid starting many action runs.
resource "github_repository_file" "init_workflow" {
  repository          = github_repository.template_repo.name
  branch              = "main"
  file                = ".github/workflows/init.yaml"
  content             = file("${path.module}/repo_root/.github/workflows/init.yaml")
  commit_message      = "Managed by Terraform."
  commit_author       = "Terraform User"
  commit_email        = "terraform@example.com"
  overwrite_on_create = true

  depends_on = [github_repository_file.files_other_than_init_workflow]
}
