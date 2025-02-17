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
  owner = var.github_org
  token = var.github_pat
}
