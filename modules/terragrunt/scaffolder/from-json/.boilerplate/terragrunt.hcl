terraform {
  source = "{{ .sourceUrl }}"
}

inputs = {

  input_json = "{{ .InputJsonB64 }}"

  json_in_base64 = true

}
