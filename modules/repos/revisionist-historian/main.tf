locals {
  files_to_copy = fileset("${path.module}/base", "**")

  frame_manifests = fileset("${path.root}/frames", "*/frame.yaml")

  number_of_frames = length(local.frame_manifests)
}

resource "local_file" "direct" {
  for_each = toset([
    for file in local.files_to_copy :
      file if !endswith(file, ".tmpl")
    ])

  content  = file("${path.module}/base/${each.value}")
  filename = "${path.root}/realized-terraform/${each.value}"
}

resource "local_file" "templated" {
  for_each = toset([
    for file in local.files_to_copy :
      file if endswith(file, ".tmpl")
    ])

  content  = templatefile(
    "${path.module}/base/${each.value}",
      {
        number_of_frames = local.number_of_frames
      }
    )
  filename = "${path.root}/realized-terraform/${substr(each.value, 0, length(each.value) - 5)}"
}
