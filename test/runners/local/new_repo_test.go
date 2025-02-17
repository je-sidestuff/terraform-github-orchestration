package test

import (
	"fmt"
	"os"
	"strings"
	"testing"

	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
	test_structure "github.com/gruntwork-io/terratest/modules/test-structure"
)

func TestNewRepoRunner(t *testing.T) {
	t.Parallel()

	requiredEnvVar := "TF_VAR_github_pat"

	if os.Getenv(requiredEnvVar) == "" {
		t.Fatalf("Please export %s to run this test.", requiredEnvVar)
	}

	exampleFolder := test_structure.CopyTerraformFolderToTemp(t, "../../../", "examples/runners/local/new-repo")

	defer test_structure.RunTestStage(t, "teardown", func() {
		terraformOptions := test_structure.LoadTerraformOptions(t, exampleFolder)
		terraform.Destroy(t, terraformOptions)
	})

	// Deploy the example
	test_structure.RunTestStage(t, "setup", func() {
		terraformOptions := configureTerraformOptions(t, exampleFolder)

		test_structure.SaveTerraformOptions(t, exampleFolder, terraformOptions)

		// This will run `terraform init` and `terraform apply` and fail the test if there are any errors
		terraform.InitAndApply(t, terraformOptions)
	})

	test_structure.RunTestStage(t, "validate", func() {
		terraformOptions := test_structure.LoadTerraformOptions(t, exampleFolder)

		// Read the file that has been written by the runner
		output_file_absolute_path := terraform.Output(t, terraformOptions, "output_file_absolute_path")

		b, err := os.ReadFile(output_file_absolute_path) // just pass the file name
		if err != nil {
			fmt.Print(err)
			t.Error("Runner file not found.")
		}

		messageWritten := string(b)

		messageInstructed := terraformOptions.Vars["output_message"]

		if strings.TrimSpace(messageWritten) != messageInstructed {
			t.Errorf("Expected SSH command to return '%s' but got '%s'", messageInstructed, messageWritten)
		}
	})
}

func configureTerraformOptions(t *testing.T, exampleFolder string) *terraform.Options {

	uniqueID := random.UniqueId()
	message := fmt.Sprintf("terratest-output-%s", uniqueID)

	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{

		TerraformDir: exampleFolder,

		Vars: map[string]interface{}{
			"name":           uniqueID,
			"output_message": message,
		},
	})

	return terraformOptions
}
