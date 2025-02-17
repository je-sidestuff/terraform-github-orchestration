# Smart Template Baseline

The Smart Template Baseline is a foundational repository template that enables users to create a new repository with the minimal set of files and configurations necessary to be considered a smart template. This template is designed to be a starting point for building more complex templates that can be used for various use-cases. In most cases the caller of this module will want to deploy the template and then update it with custom template-population routines, either manually or through additional terraform steps. The terreform handle may be retained to automatically update the smarthub template interface to later versions, or may be discarded.

## Purpose

The purpose of the Smart Template Baseline is to provide a standardized starting point for creating new repositories with consistent configurations and files and flexible self-construction routines. By using this template, you can create new repositories that have content driven by custom input rather than simple copy-paste and are set up in a way that facilitates easy automation and management.

## Prerequisites

Before you can create a repository using the Smart Template Baseline, you must have the following prerequisites:

- A GitHub account with the necessary permissions to create repositories.
- A personal access token (PAT) with `repo` and `admin:org` permissions.
- Terraform installed on your local machine.

## Required Inputs

To successfully deploy a new repository using the Smart Template Baseline, you need to provide the following inputs:

- `github_pat`: A personal access token used for authentication when creating the repository.
- `name`: The desired name of the repository (ending with 'template').
- `visibility`: The visibility setting for the new repository, which can be either `public` or `private`.

## Optional Inputs

There are additional optional inputs that can be configured:

- `description`: A brief description of the repository's purpose.

## Running the Example

You can run the example with the following commands:

```bash
terraform init
terraform apply
```

These commands will initialize and apply the Terraform configuration, creating a new template repository based on the Smart Template Baseline.

## Destroying the Example

To remove the repository created by this example, run:

```bash
terraform destroy
```

This command will delete the repository and all associated resources. Ensure you have backed up any important data before running this command.
