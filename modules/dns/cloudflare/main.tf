terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 4.0"
    }
  }
}

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}

# Look up the existing zone — we manage records, not the zone itself,
# since the zone was created when you added the domain to Cloudflare.
data "cloudflare_zone" "this" {
  name = var.domain
}

resource "cloudflare_record" "this" {
  zone_id = data.cloudflare_zone.this.id
  name    = var.subdomain
  type    = "CNAME"
  content = "${var.netlify_subdomain}.netlify.app"
  ttl     = 1    # 1 = "Auto" in Cloudflare
  proxied = true # traffic routes through Cloudflare (DDoS protection, analytics)
}
