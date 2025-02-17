# Simple Smart Template Deployment Example

This example creates a new repository from a smart template and initializes it
with a single file: `init_payload.json`. The `init_payload.json` file is used to
drive the initialization of the repository.

The example is intended to be used as a starting point for creating more complex
smart template deployments.

## Required Inputs

The following inputs are required:

* `github_pat`: A personal access token with `repo` and `admin:org` permissions.
* `github_org`: The organization which you are logging in on behalf of. Note that because of a limitation in the github provider it is necessary to use the context of an organization even if the source template owner is a user. 
* `source_owner`: The owner of the smart template source repo.
* `template_repo_name`: The name of the smart template source repo.

TODO: [Raise ticket](https://github.com/integrations/terraform-provider-github/issues/new?template=bug.yml) for github terraform provider failure.

## Optional Inputs

The following inputs are optional:

* `name`: The name of the repository to create. If not specified, a random name
  will be generated.
* `init_payload_content`: The json content used to drive the initialization of the
  repository. The default is `{"filename": "INITIALIZED"}`.

## Running the Example

You can run this example with the following commands:

`terraform init`
`terraform apply`
