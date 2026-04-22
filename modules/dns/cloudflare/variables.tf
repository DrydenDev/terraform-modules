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

variable "netlify_subdomain" {
  description = "The *.netlify.app subdomain assigned to your Netlify site (without .netlify.app)"
  type        = string
}

