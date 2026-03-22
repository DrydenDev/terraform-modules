variable "supabase_access_token" {
  description = "Supabase personal access token — sourced from Keychain via TF_VAR_supabase_access_token"
  type        = string
  sensitive   = true
}

variable "project_name" {
  description = "Supabase project name"
  type        = string
}

variable "organization_id" {
  description = "Supabase organization ID — found in the Supabase dashboard under org settings"
  type        = string
}

variable "db_password" {
  description = "Supabase database password — sourced from Keychain via TF_VAR_supabase_db_password"
  type        = string
  sensitive   = true
}

variable "region" {
  description = "Supabase project region (e.g. us-east-1)"
  type        = string
  default     = "us-east-1"
}

variable "google_oauth_client_id" {
  description = "Google OAuth client ID for Supabase Auth"
  type        = string
  sensitive   = true
}

variable "google_oauth_client_secret" {
  description = "Google OAuth client secret for Supabase Auth"
  type        = string
  sensitive   = true
}

variable "site_url" {
  description = "The production app URL — used by Supabase Auth for redirects"
  type        = string
}
