# Terratest Automation Tests

This repository contains a collection of Terratest automation tests designed to validate the infrastructure as code (IaC) deployments and configurations. Terratest is a Go library that makes it easier to write automated tests for your infrastructure code, ensuring that your systems behave as expected.

## Purpose

The purpose of these tests is to provide automated verification of the infrastructure codebase. By executing these tests, developers can ensure the correctness of their Terraform configurations, validate the behavior of infrastructure changes, and detect issues early in the development process. This helps in maintaining a robust and reliable infrastructure setup.

## Prerequisites

Before running these tests, ensure you have the following prerequisites:

- **Go Programming Language**: Install Go on your machine. Use the provided devcontainer or follow the official [Go installation guide](https://golang.org/doc/install) for instructions.
- **Terraform**: Ensure Terraform is installed on your local machine. Use the provided devcontainer or download it from the [official website](https://www.terraform.io/downloads.html).
- **GitHub Account**: A GitHub account with necessary permissions to access the repositories being tested.
- **Personal Access Token (PAT)**: A GitHub PAT with `repo` and `admin:org` permissions for authentication.
- **Git**: Ensure Git is installed to clone the repository and manage version control.

## Running the Tests

1. **Go to the Test Directory**: Enter the directory for the desired test.
   ```bash
   cd test/repos/smart-template/
   ```

1. **Run Tests**: Execute the tests using the `go test` command.
   ```bash
   go test -v ./...
   ```

## Test Structure

The tests are organized into different packages, each targeting specific components of the infrastructure. Each package contains a set of test cases that validate different aspects of the infrastructure.

- **`baseline_and_deploy_test.go`**: Tests for template repository creation and deployment processes.
- **`runner_test.go`**: Tests for the configuration and execution of self-hosted runners.

## Output

Upon completion, the tests will output results to the console, indicating which tests passed and which failed. Logs and error messages will help in diagnosing any issues encountered during the test execution.

## License

This repository is licensed under the MIT License. See the [LICENSE](LICENSE) file for more information.

By using these Terratest automation tests, you can maintain a high level of confidence in the correctness and reliability of your infrastructure code. This helps ensure that your deployments are consistent and free from errors, ultimately leading to more stable and predictable infrastructure. Happy testing!

