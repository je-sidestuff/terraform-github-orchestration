# Local Self-Hosted Runner in Current Repository Example

This example creates a self-hosted runner in the current repository using the local runner module. A local runner is a self-hosted runner that is created on the same host as the terraform that is creating it. Local runners are useful for testing, development, and orchestration of on-prem and/or manually hosted compute.

The example assumes that the current user PAT has permissions to create runners in this repository, and to read data from this repository. The example will create a local runner in the current repository, and then trigger a workflow that uses the local runner. The workflow will print a message to the console, and then complete.

The example is intended to be used as a starting point for creating more complex workflows that use local runners. For example, you could add additional steps to the workflow that use the local runner to run tests or build your application.
