package test

import (
	"context"
	"fmt"
	"os"
	"testing"

	"github.com/google/go-github/v69/github"

	cp "github.com/otiai10/copy"

	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
	test_structure "github.com/gruntwork-io/terratest/modules/test-structure"
)

func TestSmartTemplate(t *testing.T) {
	t.Parallel()

	requiredEnvVars := []string{"TF_VAR_github_pat", "TF_VAR_github_org", "TF_VAR_source_owner"}

	for _, requiredEnvVar := range requiredEnvVars {
		if os.Getenv(requiredEnvVar) == "" {
			t.Fatalf("Please export %s to run this test.", requiredEnvVar)
		}
	}

	exampleParentFolder := test_structure.CopyTerraformFolderToTemp(t, "../../../", "examples/repos/smart-template")
	baselineFolder := exampleParentFolder + "/simple-baseline"
	// Help copy the dotfiles until we can finish https://github.com/gruntwork-io/terratest/issues/1021
	err := cp.Copy("../../../modules/repos/smart-template/baseline/repo_root/.github",
		exampleParentFolder+"/../../../modules/repos/smart-template/baseline/repo_root/.github")
	if err != nil {
		t.Errorf("Error while copying additional files: %s", err)
	}
	err = cp.Copy("../../../modules/repos/smart-template/baseline/repo_root/.smart-init",
		exampleParentFolder+"/../../../modules/repos/smart-template/baseline/repo_root/.smart-init")
	if err != nil {
		t.Errorf("Error while copying additional files: %s", err)
	}

	defer test_structure.RunTestStage(t, "teardown_baseline", func() {
		terraformBaselineOptions := test_structure.LoadTerraformOptions(t, baselineFolder)
		terraform.Destroy(t, terraformBaselineOptions)
	})

	// Deploy the example
	test_structure.RunTestStage(t, "setup_baseline", func() {
		terraformBaselineOptions := configureBaselineTerraformOptions(t, baselineFolder)

		test_structure.SaveTerraformOptions(t, baselineFolder, terraformBaselineOptions)

		// This will run `terraform init` and `terraform apply` and fail the test if there are any errors
		terraform.InitAndApply(t, terraformBaselineOptions)
	})

	var templateRepoName string

	test_structure.RunTestStage(t, "validate_baseline", func() {

		terraformOptions := test_structure.LoadTerraformOptions(t, baselineFolder)

		// Look for the randomly named repo created by the example
		templateRepoName = terraform.Output(t, terraformOptions, "repo_name")

		validateBaseline(t, templateRepoName)
	})

	deploymentFolder := exampleParentFolder + "/simple-deployment"
	expectedFilename := fmt.Sprintf("file-%s", random.UniqueId())

	defer test_structure.RunTestStage(t, "teardown_deployment", func() {
		terraformDeploymentOptions := test_structure.LoadTerraformOptions(t, deploymentFolder)
		terraform.Destroy(t, terraformDeploymentOptions)
	})

	// Deploy the example
	test_structure.RunTestStage(t, "setup_deployment", func() {
		terraformDeploymentOptions := configureDeploymentTerraformOptions(t, deploymentFolder, templateRepoName, expectedFilename)

		test_structure.SaveTerraformOptions(t, deploymentFolder, terraformDeploymentOptions)

		// This will run `terraform init` and `terraform apply` and fail the test if there are any errors
		terraform.InitAndApply(t, terraformDeploymentOptions)
	})

	test_structure.RunTestStage(t, "validate_deployment", func() {

		terraformOptions := test_structure.LoadTerraformOptions(t, deploymentFolder)

		// Look for the randomly named repo created by the example
		deployed_repo_name := terraform.Output(t, terraformOptions, "repo_name")

		validateDeployment(t, deployed_repo_name, expectedFilename)
	})
}

func configureBaselineTerraformOptions(t *testing.T, exampleFolder string) *terraform.Options {
	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{

		TerraformDir: exampleFolder,

		Vars: map[string]interface{}{},
	})

	return terraformOptions
}

func validateBaseline(t *testing.T, template_repo_name string) {
	client := github.NewClient(nil).WithAuthToken(os.Getenv("TF_VAR_github_pat"))

	// Get all of the repos belonging to the source owner authenticated user with the client
	repos, response, err := client.Repositories.ListByAuthenticatedUser(context.Background(), &github.RepositoryListByAuthenticatedUserOptions{
		Visibility:  "private",
		Affiliation: "owner",
	})

	if err != nil {
		t.Errorf("Error listing repos: %s", err)
	}

	t.Logf("Response %s", response.Status)

	// Check if the repo has been created
	found := false
	for _, repo := range repos {
		t.Logf("Repo %s found.", *repo.Name)
		if *repo.Name == template_repo_name {
			found = true
		}
	}

	if !found {
		t.Errorf("Repo '%s' was not created", template_repo_name)
	}
}

func configureDeploymentTerraformOptions(t *testing.T, exampleFolder string, templateRepoName string, expectedFilename string) *terraform.Options {
	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{

		TerraformDir: exampleFolder,

		Vars: map[string]interface{}{
			"template_repo_name":   templateRepoName,
			"init_payload_content": fmt.Sprintf("{\"filename\": \"%s\"}", expectedFilename),
			"timeout_in_seconds":   20,
		},
	})

	return terraformOptions
}

func validateDeployment(t *testing.T, deployed_repo_name string, expectedFilename string) {
	client := github.NewClient(nil).WithAuthToken(os.Getenv("TF_VAR_github_pat"))

	// Get all of the repos belonging to the source owner authenticated user with the client
	repos, response, err := client.Repositories.ListByOrg(context.Background(),
		os.Getenv("TF_VAR_github_org"),
		&github.RepositoryListByOrgOptions{})

	if err != nil {
		t.Errorf("Error listing repos: %s", err)
	}

	t.Logf("Response %s", response.Status)

	// Check if the repo has been created
	found := false
	for _, repo := range repos {
		t.Logf("Repo %s found.", *repo.Name)
		if *repo.Name == deployed_repo_name {
			found = true
		}
	}

	if !found {
		t.Errorf("Repo '%s' was not created", deployed_repo_name)
	}

	// Check if the file exists
	file, _, _, err := client.Repositories.GetContents(context.Background(),
		os.Getenv("TF_VAR_github_org"),
		deployed_repo_name,
		expectedFilename,
		&github.RepositoryContentGetOptions{})

	if err != nil {
		t.Errorf("Error getting file: %s", err)
	}

	t.Logf("File %s found.", *file.Name)
}
