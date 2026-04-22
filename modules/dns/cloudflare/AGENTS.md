# AGENTS.md — modules/dns

Manages a single proxied Cloudflare CNAME record pointing a subdomain at a Netlify site. Does not create or manage the Cloudflare zone itself — the zone must already exist.

## Provider

`cloudflare/cloudflare ~> 4.0`

## Prerequisites

- The domain's Cloudflare zone must already exist (added via the Cloudflare dashboard)
- The target Netlify site must exist and be known before applying

## Required secrets

| Keychain key | TF_VAR | Description |
|---|---|---|
| `cloudflare_api_token` | `TF_VAR_cloudflare_api_token` | Cloudflare API token with DNS edit permissions for the zone |

## Variables

| Name | Type | Required | Description |
|---|---|---|---|
| `cloudflare_api_token` | `string` | yes | Cloudflare API token — sourced from Keychain |
| `domain` | `string` | yes | Root domain of the Cloudflare zone (e.g. `andie-xd.com`) |
| `netlify_subdomain` | `string` | yes | Netlify site name without `.netlify.app` (e.g. `music-ratings`) — use `module.hosting.netlify_subdomain` |

## Outputs

| Name | Description |
|---|---|
| `zone_id` | Cloudflare zone ID |
| `nameservers` | Cloudflare nameservers for the zone |

## Usage example

```hcl
module "dns" {
  source = "github.com/DrydenDev/terraform-modules//modules/dns?ref=v1.0.0"

  cloudflare_api_token = var.cloudflare_api_token
  domain               = var.domain
  netlify_subdomain    = module.hosting.netlify_subdomain
}
```

## What it creates

- `cloudflare_record.music` — CNAME `music.<domain>` → `<netlify_subdomain>.netlify.app`, proxied through Cloudflare

## ⚠️ Known limitations

- The subdomain name `"music"` is hardcoded. If you need a different subdomain (e.g. `app`, `www`), extract it into a variable first.
- Records are created with `proxied = true`. If you need a DNS-only (grey cloud) record, this module needs updating.
- If a record for the subdomain already exists in Cloudflare, Terraform will fail with "record already exists". Import the existing record first:
  ```bash
  terraform import module.dns.cloudflare_record.music <zone_id>/<record_id>
  ```
  Get the record ID from the Cloudflare API:
  ```bash
  curl -s "https://api.cloudflare.com/client/v4/zones/<zone_id>/dns_records?name=music.<domain>" \
    -H "Authorization: Bearer <token>" | python3 -c "import json,sys; print(json.load(sys.stdin)['result'][0]['id'])"
  ```
