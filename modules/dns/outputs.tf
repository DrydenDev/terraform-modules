output "zone_id" {
  description = "Cloudflare zone ID"
  value       = data.cloudflare_zone.this.id
}

output "nameservers" {
  description = "Cloudflare nameservers for this zone"
  value       = data.cloudflare_zone.this.name_servers
}
