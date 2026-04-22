terraform {
  required_providers {
    supabase = {
      source  = "supabase/supabase"
      version = "~> 1.0"
    }
  }
}

provider "supabase" {
  access_token = var.supabase_access_token
}

resource "supabase_project" "this" {
  name              = var.project_name
  database_password = var.db_password
  region            = var.region
  organization_id   = var.organization_id

  lifecycle {
    # Prevent accidental destruction of the database.
    prevent_destroy = true
  }
}

resource "supabase_settings" "auth" {
  project_ref = supabase_project.this.id

  auth = jsonencode({
    site_url                = var.site_url
    additional_redirect_urls = concat(
      ["${var.site_url}/auth/callback"],
      var.local_redirect_urls,
    )
    external_google_enabled       = true
    external_google_client_id     = var.google_oauth_client_id
    external_google_secret        = var.google_oauth_client_secret
  })
}
