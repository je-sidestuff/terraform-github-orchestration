terraform {
  source = "{{ .sourceUrl }}"
}

inputs = {

  input_json = {{ .InputJsonB64 }}

  json_in_b64 = true

}
