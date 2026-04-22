terraform {
  required_providers {
    netlify = {
      source  = "netlify/netlify"
      version = "~> 0.1"
    }
  }
}

provider "netlify" {
  token = var.netlify_token
}

# The site is created manually via the Netlify dashboard or CLI.
# Terraform manages build settings and domain config, but not site creation.
data "netlify_site" "this" {
  name      = var.site_name
  team_slug = var.team_slug
}

resource "netlify_site_build_settings" "this" {
  site_id           = data.netlify_site.this.id
  build_command     = var.build_command
  production_branch = "main"
  publish_directory = var.publish_directory
}

resource "netlify_site_domain_settings" "this" {
  site_id       = data.netlify_site.this.id
  custom_domain = "${var.subdomain}.${var.domain}"
}

# Deploy key for GitHub integration — add the public key to the repo's
# deploy keys in GitHub settings (read-only is sufficient for Netlify).
resource "netlify_deploy_key" "this" {}
