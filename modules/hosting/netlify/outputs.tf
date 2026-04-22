output "site_id" {
  description = "Netlify site ID"
  value       = data.netlify_site.this.id
}

output "netlify_subdomain" {
  description = "The *.netlify.app subdomain — needed by the DNS module"
  value       = data.netlify_site.this.name
}

output "deploy_url" {
  description = "Default Netlify deploy URL"
  value       = "https://${data.netlify_site.this.name}.netlify.app"
}

output "deploy_key" {
  description = "Public deploy key to add to GitHub repo settings"
  value       = netlify_deploy_key.this.public_key
}
