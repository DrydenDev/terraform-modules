variable "cloudflare_api_token" {
  description = "Cloudflare API token — sourced from Keychain via TF_VAR_cloudflare_api_token"
  type        = string
  sensitive   = true
}

variable "domain" {
  description = "Root domain managed in Cloudflare (e.g. example.com)"
  type        = string
}

variable "subdomain" {
  description = "Subdomain to create the CNAME record for (e.g. 'music' → music.example.com)"
  type        = string
}

variable "cname_target" {
  description = "Full CNAME target value (e.g. 'music-ratings.netlify.app' or 'username.github.io')"
  type        = string
}

variable "proxied" {
  description = "Route traffic through Cloudflare proxy (DDoS protection, analytics). Set to false for GitHub Pages, which manages its own SSL."
  type        = bool
  default     = true
}

