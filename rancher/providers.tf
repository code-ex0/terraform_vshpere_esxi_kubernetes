terraform {
  required_providers {
    rancher2 = {
      source = "rancher/rancher2"
      version = "1.25.0"
    }
  }
}

provider "rancher2" {
  api_url = var.rancher_server
  access_key = var.rancher_access_key
  secret_key = var.rancher_secret_key
  insecure = true
}