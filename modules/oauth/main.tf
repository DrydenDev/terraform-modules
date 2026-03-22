# Google OAuth module
#
# HONEST NOTE: The hashicorp/google Terraform provider does not expose a
# resource for creating OAuth 2.0 client credentials under
# "APIs & Services → Credentials" in the Google Cloud Console.
# (google_iap_oauth_client exists but is scoped to Identity-Aware Proxy,
# not generic OAuth clients.)
#
# The OAuth client was created manually in the Google Cloud Console.
# Its credentials are stored in macOS Keychain and passed through to the
# Supabase module via variables.
#
# This module exists as a placeholder so the credentials are documented
# in one place and can be wired into outputs that other modules consume.
# If Google ever adds a Terraform resource for this, this is where it lives.

variable "client_id" {
  description = "Google OAuth client ID"
  type        = string
  sensitive   = true
}

variable "client_secret" {
  description = "Google OAuth client secret"
  type        = string
  sensitive   = true
}

output "client_id" {
  description = "Google OAuth client ID — passed to Supabase auth config"
  value       = var.client_id
  sensitive   = true
}

output "client_secret" {
  description = "Google OAuth client secret — passed to Supabase auth config"
  value       = var.client_secret
  sensitive   = true
}
