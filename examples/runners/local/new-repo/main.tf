locals {
  name_prefix    = var.name == "generate" ? "ex-${random_string.random.result}" : var.name
  example_branch = "${local.name_prefix}-branch"
  example_group  = "${local.name_prefix}-group"
  example_label  = "${local.name_prefix}-label"
  example_runner = "${local.name_prefix}-runner"
  example_repo   = "${local.name_prefix}-repo"
  output_file = (startswith(var.output_file, "/") ? var.output_file :
    abspath("${path.root}/${var.output_file}")
  )
}

resource "github_repository" "example_repo" {
  name        = local.example_repo
  description = "My local runner automation repo"

  visibility = "private"

  auto_init = true
}

resource "random_string" "random" {
  length  = 6
  special = false
  upper   = false
}

resource "github_branch" "example_branch" {
  repository = github_repository.example_repo.name
  branch     = local.example_branch
}

resource "local_file" "workflow" {
  content = templatefile(
    "${path.module}/test_workflow.yaml.tmpl",
    {
      "example_branch" = local.example_branch
      "example_label"  = local.example_label
      "example_name"   = local.name_prefix
      "output_file"    = local.output_file
      "output_message" = var.output_message
    }
  )
  filename = "${path.module}/test_workflow.yaml"
}

resource "time_sleep" "wait_10s_to_push_workflow" {

  triggers = {
    wait_for_install = module.runner.runner_installation_complete
  }

  create_duration = "10s"
}

resource "github_repository_file" "workflow" {
  repository          = github_repository.example_repo.name
  branch              = github_branch.example_branch.branch
  file                = ".github/workflows/test_workflow.yaml"
  content             = local_file.workflow.content
  commit_message      = "Managed by Terraform"
  commit_author       = "Terraform User"
  commit_email        = "terraform@example.com"
  overwrite_on_create = true

  depends_on = [time_sleep.wait_10s_to_push_workflow]
}

module "runner" {
  source = "../../../..//modules/runners/local"

  name = local.example_runner

  execution_time  = "60s"
  github_pat      = var.github_pat
  labels          = [local.example_label]
  local_cache_dir = path.root
  log_file        = "${path.root}/action-runner-log.txt"
  repo_full_name  = github_repository.example_repo.full_name
}
