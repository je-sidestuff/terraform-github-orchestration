terraform {
  source = "{{ .sourceUrl }}"
}

inputs = {

  input_json = <<EOF
{{ .InputJsonB64 | base64.Decode }}
EOF

}
