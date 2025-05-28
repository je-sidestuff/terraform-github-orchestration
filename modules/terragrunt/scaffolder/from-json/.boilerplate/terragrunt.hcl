terraform {
  source = "{{ .sourceUrl }}"
}

inputs = {

  input_json = "{{ .InputJsonB64 }}"

  json_in_base64 = true

}

# We exclude destruction because we want to be able to destroy all resources
# without destroying the terragrunt tree.
exclude {
    if = true
    actions = ["destroy"]
}

prevent_destroy = true
