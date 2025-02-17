# Smart Template Deployment

The Smart Template Deployment module is a Terraform module that deploys a new repository from a smart template. A smart template is a repository that contains scripts with hooks that allow a client to configure an arbitrary template-initialization routine. This module is designed to be used as a starting point for deploying smart templates that have been previously configured. The module will wait on the successful deployment of the module and succeed or fail based on the result (TODO).

## Purpose

The purpose of the Smart Template Deployment module is to provide a standardized starting point for creating new repositories with consistent configurations and files and flexible self-construction routines. By using this module, you can create new repositories that have content driven by custom input and routines rather than the native simple copy-pasted content.

## Prerequisites

Before you can use the Smart Template Deployment module, you must have the following prerequisites:

* A GitHub organization where a new repo may be created.
* A valid GitHub personal access token with `repo` and `admin:org` permissions.
* A smart template source repo.

## Inputs

The Smart Template Deployment module requires the following inputs:

* `github_pat`: A personal access token with `repo` and `admin:org` permissions.
* `github_org`: The organization which you are logging in on behalf of.
* `source_owner`: The owner of the smart template source repo.
* `template_repo_name`: The name of the smart template source repo.
* `name`: The name of the repository to create. If not specified, a random name will be generated.

The following inputs are optional:

* `init_payload_content`: A json string used to drive the initialization of the repository. The default is `{"filename": "INITIALIZED"}`.

## Outputs

The Smart Template Deployment module outputs the following:

* `init_result`: The initialization result for the deployed repository.
* `default_branch`: The default branch of the deployed repository. The default is `main`.
* `description`: The description of the repository created from the smart template. The default is `This repo was created from a smart template.`.
* `visibility`: The visibility setting for the new repository, which can be either `public` or `private`.