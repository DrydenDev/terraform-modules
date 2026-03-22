# AGENTS.md — modules/hosting

Manages build settings and custom domain configuration for an **existing** Netlify site. Does not create the site — site creation must be done via the Netlify dashboard or CLI before this module can manage it.

## Provider

`netlify/netlify ~> 0.1`

## Prerequisites

- The Netlify site must already exist. Look up its name in the Netlify dashboard — it's the part before `.netlify.app` in the default deploy URL.
- The site's GitHub repo connection must be set up manually in the Netlify dashboard. This module does not manage GitHub integration.

## Required secrets

| Keychain key | TF_VAR | Description |
|---|---|---|
| `netlify_token` | `TF_VAR_netlify_token` | Netlify personal access token |

## Variables

| Name | Type | Required | Description |
|---|---|---|---|
| `netlify_token` | `string` | yes | Netlify personal access token — sourced from Keychain |
| `domain` | `string` | yes | Root domain (e.g. `andie-xd.com`) — the custom domain will be set to `music.<domain>` |
| `github_repo` | `string` | yes | GitHub repo in `owner/name` format (e.g. `DrydenDev/music-ratings`) |
| `site_name` | `string` | yes | Netlify site name (e.g. `music-ratings`) — visible in the Netlify dashboard |
| `team_slug` | `string` | yes | Netlify team slug — visible in the URL at `app.netlify.com/teams/<slug>` |
| `env_vars` | `map(string)` | no | Environment variables (default: `{}`). The `netlify/netlify` provider supports env vars as of v0.4 via `netlify_environment_variable`, but this module doesn't wire them up yet — set them in the dashboard |

## Outputs

| Name | Description |
|---|---|
| `site_id` | Netlify site UUID — useful for referencing the site in other resources |
| `netlify_subdomain` | The site name (without `.netlify.app`) — pass this to the `dns` module as `netlify_subdomain` |
| `deploy_url` | Full default deploy URL, e.g. `https://music-ratings.netlify.app` |
| `deploy_key` | SSH public key for GitHub deploy key integration — add this to the repo's deploy keys in GitHub settings (read-only is sufficient) |

## Usage example

```hcl
module "hosting" {
  source = "github.com/DrydenDev/terraform-modules//modules/hosting?ref=v1.0.0"

  netlify_token = var.netlify_token
  domain        = var.domain
  github_repo   = var.github_repo
  site_name     = var.netlify_site_name
  team_slug     = var.netlify_team_slug
}

# Pass the subdomain output to the dns module
module "dns" {
  source            = "github.com/DrydenDev/terraform-modules//modules/dns?ref=v1.0.0"
  netlify_subdomain = module.hosting.netlify_subdomain
  # ...
}
```

## What it creates/manages

- `netlify_site_build_settings.this` — sets build command (`pnpm build`), production branch (`main`), publish directory (`dist`)
- `netlify_site_domain_settings.this` — sets `music.<domain>` as the custom domain on the site
- `netlify_deploy_key.this` — generates a deploy key; its `public_key` output should be added to the GitHub repo's deploy keys

## ⚠️ Known limitations

- The custom domain is hardcoded as `"music.${var.domain}"`. If you need a different subdomain prefix, update the module.
- Build settings are hardcoded for an Astro/pnpm project (`pnpm build`, `dist`). Extract these as variables if reusing for a different stack.
- GitHub repo connection is not managed by Terraform — configure it in the Netlify dashboard.
- If a `netlify_site_domain_settings` or `netlify_site_build_settings` resource already exists in Netlify state, Terraform may show a diff on first apply. This is normal — it will converge on the declared values.
