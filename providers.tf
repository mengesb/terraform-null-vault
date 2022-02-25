#
# Terraform:: terraform-null-vault
# Plan:: providers.tf
#

terraform {
  experiments      = [module_variable_optional_attrs]
  required_version = "~> 1.0"
  required_providers {
    external = {
      source  = "hashicorp/external"
      version = "~> 2.2"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.1"
    }
    null = {
      source  = "hashicorp/null"
      version = "~> 3.1"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 3.1"
    }
  }
}
