variable "netlify_token" {
  description = "Netlify personal access token — sourced from Keychain via TF_VAR_netlify_token"
  type        = string
  sensitive   = true
}

variable "domain" {
  description = "Custom domain to attach to the Netlify site"
  type        = string
}

variable "github_repo" {
  description = "GitHub repo in owner/name format"
  type        = string
}

variable "site_name" {
  description = "Netlify site name (e.g. music-ratings → music-ratings.netlify.app)"
  type        = string
}

variable "team_slug" {
  description = "Netlify team/account slug — visible in the Netlify dashboard URL (app.netlify.com/teams/<slug>)"
  type        = string
}

variable "env_vars" {
  description = "Environment variables to set on the Netlify site"
  type        = map(string)
  sensitive   = true
  default     = {}
}
