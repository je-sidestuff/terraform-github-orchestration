terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = "6.5.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.6.3"
    }
  }
}

provider "github" {
  token = var.github_pat
}
