# Local Runner Module

The Local Runner Module enables the deployment and management of self-hosted runners on a local machine. Self-hosted runners provide more control over hardware, software, and the environment in which your workflows run, making them ideal for specific use cases that require custom configurations.

## Purpose

The purpose of this module is to streamline the setup, deployment, and management of self-hosted runners for GitHub Actions. By using this module, you can automate the installation and execution of runners, integrate them seamlessly with your repositories, and manage lifecycle events such as updates and uninstallation.

## Prerequisites

Before using the Local Runner Module, ensure you have the following prerequisites:

- **GitHub Account**: A GitHub account with the necessary permissions to create and manage repositories.
- **Personal Access Token (PAT)**: A PAT with `repo` and `admin:org` permissions for authentication.
- **Terraform**: Terraform installed on your local machine to manage infrastructure as code.
- **Local Machine**: A local machine with the necessary resources and network access to host the runner.

## Required Inputs

The module requires the following inputs to function correctly:

- **`name`**: The name assigned to the local self-hosted runner.
- **`github_pat`**: The personal access token used for authentication during runner creation.
- **`repo_full_name`**: The full name of the repository the runner will be scoped to.

## Optional Inputs

The module also supports several optional inputs:

- **`clean_up_runner_dir_on_destroy`**: Boolean value indicating whether to delete the runner directory upon module destruction. Defaults to `true`.
- **`delay_execution_on`**: Specifies when the runner will start executing tasks after installation.
- **`labels`**: A list of labels to associate with the runner for workflow filtering.
- **`local_cache_dir`**: Directory path for caching runner installation files locally.
- **`log_file`**: Path to the log file where runner logs will be stored.
- **`runner_group`**: The group to which the runner should belong.
- **`execution_time`**: The maximum time allowed for runner execution, specified as a string (e.g., "30m"). Note that a manual re-execution of the runner will be necessary for most real use-cases.

## Outputs

The module provides the following outputs:

- **`runner_installation_complete`**: Boolean indicating the completion of runner installation.
- **`runner_execution_complete`**: Boolean indicating the completion of runner execution.

## Usage

To use this module, include it in your Terraform configuration as follows:

```hcl
module "runner" {
  source = "path_to_module"

  name             = "my-runner"
  github_pat       = var.github_pat
  repo_full_name   = "my-org/my-repo"
  labels           = ["custom-label"]
  local_cache_dir  = "/path/to/cache"
  log_file         = "/path/to/log.txt"
  execution_time   = "30m"
}
```

## Running the Module

After configuring the module, run the following commands to deploy your local runner:

```bash
terraform init
terraform apply
```

## Destroying the Module

To clean up resources and remove the runner, execute:

```bash
terraform destroy
```

This will terminate the runner and delete associated resources. Ensure any important data is backed up prior to destruction.

## Conclusion

The Local Runner Module simplifies the deployment and management of self-hosted runners, providing flexibility and control over your CI/CD workflows. By leveraging this module, you can tailor runners to meet your specific needs and optimize the execution environment for your projects.
