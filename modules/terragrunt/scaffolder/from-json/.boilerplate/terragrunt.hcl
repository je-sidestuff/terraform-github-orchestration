terraform {
  source = "{{ .sourceUrl }}"
}

inputs = {

  input_json = <<EOF
{{ .InputJsonB64 }}
EOF

  json_in_b64 = true

}
