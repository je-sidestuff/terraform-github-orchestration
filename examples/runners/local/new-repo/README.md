# Local Self-Hosted Runner in a New Repository Example

This example creates a local self-hosted runner for a new repository using the local runner module. A local runner is a self-hosted runner that is created on the same host as the terraform that is creating it. Local runners are useful for testing, development, and orchestration of on-prem and/or manually hosted compute.

The example creates a new repository with a chosen name and initializes it with a smart template baseline. If the `name` variable is left as `generate` then the repository will be named `ex-<random>-repo`. The repository is initialized with a single `main` branch.

The example is intended to be used as a starting point for creating more complex workflows that use local runners. For example, you could add additional steps to the workflow that use the local runner to run tests or build your application.

## Prerequisites

* A GitHub organization where a new repo may be created.
* A valid GitHub personal access token with `repo` and `admin:org` permissions.

## Required Inputs

The following inputs are required:

* `github_pat`: A personal access token with `repo` and `admin:org` permissions.
* `github_org`: The organization which you are logging in on behalf of.

(TODO - double check if this example has the same bug with user versus org and add to the same ticket if so)

## Optional Inputs

The following inputs are optional:

* `name`: The name for the local self-hosted runner. If not specified, a random name will be generated.
* `output_file`: The name of the file the workflow will write to. If relative it will be prefixed with the root dir. Defaults to `action-runner-output.txt`.
* `output_message`: The text to write to the output file. Defaults to "Hello from github!".

## Running the Example

You can run this example with the following commands:

`terraform init`
`terraform apply`

## Destroying the Example

You can destroy this example by running the following command:

`terraform destroy`

WARNING: This will destroy the repository and the local runner. Make sure you have saved any changes you want to keep before running this command.

## Output

The workflow will write a file called `action-runner-output.txt` with the text "Hello from github!" to the root of the repository.

## Purpose

This example shows how to create a local self-hosted runner for a new repository using the local runner module. It is intended to be used as a starting point for creating more complex workflows that use local runners.
