locals {

  install_dir = (var.install_dir != "" ?
    var.install_dir :
    "${path.root}/actions-runner"
  )

  labels_csv = join(",", var.labels)
}

resource "null_resource" "manage_runner_install" {
  provisioner "local-exec" {
    command = <<EOT
export ACTION_RUNNER_INSTALL_DIR="${local.install_dir}"
export ACTION_RUNNER_LOCAL_CACHE_DIR="${var.local_cache_dir}"
export ACTION_RUNNER_LOG_FILE="${var.log_file}"
 export GITHUB_PAT="${sensitive(var.github_pat)}"
export LABELS_CSV="${local.labels_csv}"
export REPO_FULL_NAME="${var.repo_full_name}"
export RUNNER_NAME="${var.name}"
export RUNNER_GROUP="${var.runner_group}"
export WORK_DIR="${var.work_dir}"
${path.module}/install_runner.sh
EOT
  }
}

resource "null_resource" "manage_runner_execution" {

  triggers = {
    delay_execution_on = var.delay_execution_on
  }

  provisioner "local-exec" {
    command = <<EOT
echo "Delayed execution on ${var.delay_execution_on}"
export ACTION_RUNNER_INSTALL_DIR="${local.install_dir}"
export ACTION_RUNNER_EXECUTION_TIME="${var.execution_time}"
${path.module}/execute_runner.sh
EOT
  }

  depends_on = [null_resource.manage_runner_install]
}

data "external" "get_runner_remove_token" {
  program = ["bash", "${path.module}/get_runner_remove_token.sh"]

  query = {
    github_pat     = sensitive(var.github_pat)
    repo_full_name = var.repo_full_name
  }
}

resource "null_resource" "manage_runner_uninstall" {

  triggers = {
    install_dir                    = local.install_dir
    runner_remove_token            = sensitive(data.external.get_runner_remove_token.result.runner_remove_token)
    clean_up_runner_dir_on_destroy = var.clean_up_runner_dir_on_destroy
  }

  provisioner "local-exec" {
    when    = destroy
    command = <<-EOD
export ACTION_RUNNER_INSTALL_DIR="${self.triggers.install_dir}"
 export RUNNER_REMOVE_TOKEN="${self.triggers.runner_remove_token}"
export CLEAN_UP_RUNNER_DIR="${self.triggers.clean_up_runner_dir_on_destroy}"
${path.module}/uninstall_runner.sh
EOD
  }
}
