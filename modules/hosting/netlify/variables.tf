variable "netlify_token" {
  description = "Netlify personal access token — sourced from Keychain via TF_VAR_netlify_token"
  type        = string
  sensitive   = true
}

variable "domain" {
  description = "Root domain to attach to the Netlify site (e.g. example.com)"
  type        = string
}

variable "subdomain" {
  description = "Subdomain prefix for the custom domain (e.g. 'music' → music.example.com)"
  type        = string
}

variable "build_command" {
  description = "Build command to run on Netlify (e.g. 'pnpm build')"
  type        = string
}

variable "publish_directory" {
  description = "Directory containing the built site to publish (e.g. 'dist')"
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
