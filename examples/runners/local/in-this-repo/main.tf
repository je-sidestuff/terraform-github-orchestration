locals {
  repo_owner_name_dotgit = split(
    ":",
    data.external.read_git_repository.result.full_origin_path
  )[1]
  repo_full_name = split(
    ".",
    local.repo_owner_name_dotgit
  )[0]

  name_prefix    = var.name == "generate" ? "ex-${random_string.random.result}" : var.name
  example_branch = "${local.name_prefix}-branch"
  example_label  = "${local.name_prefix}-label"
  example_runner = "${local.name_prefix}-runner"
}

data "external" "read_git_repository" {
  program = ["bash", "${path.module}/read_git_repository.sh"]
}

data "github_repository" "this" {
  full_name = local.repo_full_name
}

resource "random_string" "random" {
  length  = 6
  special = false
  upper   = false
}

resource "github_branch" "example_branch" {
  repository = data.github_repository.this.name
  branch     = local.example_branch
}

resource "local_file" "workflow" {
  content = templatefile(
    "${path.module}/test_workflow.yaml.tmpl",
    {
      "example_branch" = local.example_branch
      "example_label"  = local.example_label
      "example_name"   = local.name_prefix
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
  repository          = data.github_repository.this.name
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

  execution_time  = "30s"
  github_pat      = var.github_pat
  labels          = [local.example_label]
  local_cache_dir = "${path.root}/runner-cache"
  repo_full_name  = local.repo_full_name
}
