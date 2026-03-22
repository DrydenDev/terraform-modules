# AGENTS.md — terraform-modules

Reusable Terraform modules for the DrydenDev stack. Each module is self-contained and manages one infrastructure concern.

## Stack

| Module | Provider | What it manages |
|---|---|---|
| `modules/dns` | `cloudflare/cloudflare ~> 4.0` | CNAME record pointing a subdomain at a Netlify site |
| `modules/hosting` | `netlify/netlify ~> 0.1` | Build settings and custom domain on an existing Netlify site |
| `modules/database` | `supabase/supabase ~> 1.0` | Supabase project + Google OAuth auth configuration |
| `modules/oauth` | _(none)_ | Placeholder that passes Google OAuth credentials through to other modules |

## How modules are consumed

Projects reference modules via GitHub source URLs pinned to a semver tag:

```hcl
module "dns" {
  source = "github.com/DrydenDev/terraform-modules//modules/dns?ref=v1.0.0"
  # ...variables
}
```

The `//` separates the repo from the subdirectory. `?ref=` should always be pinned to a tag — never `main` — so module updates don't silently affect live infrastructure.

After adding or changing a source reference, the consuming project must run `terraform init`.

## Secrets and environment variables

All sensitive values are passed in via variables. No secrets live in this repo.

In consuming projects, secrets are loaded from macOS Keychain into `TF_VAR_*` environment variables by `infrastructure/scripts/tf-env.sh` before any Terraform command runs. The Keychain service name is `music-ratings-infra`.

| Keychain key | TF_VAR | Used by |
|---|---|---|
| `cloudflare_api_token` | `TF_VAR_cloudflare_api_token` | dns |
| `netlify_token` | `TF_VAR_netlify_token` | hosting |
| `supabase_access_token` | `TF_VAR_supabase_access_token` | database |
| `supabase_db_password` | `TF_VAR_supabase_db_password` | database |
| `google_oauth_client_id` | `TF_VAR_google_oauth_client_id` | oauth → database |
| `google_oauth_client_secret` | `TF_VAR_google_oauth_client_secret` | oauth → database |

## Versioning and releases

Releases are Git tags on `main`. To cut a new version:

```bash
git tag v1.1.0
git push origin v1.1.0
```

In consuming projects, bump the `?ref=` value and run `terraform init -upgrade` to pull the new version.

## Adding a new module

1. Create `modules/<name>/main.tf`, `variables.tf`, `outputs.tf`
2. All sensitive inputs must declare `sensitive = true` in their variable block
3. No hardcoded project names, domain names, account IDs, or secrets — everything via variables
4. Update this file and `README.md` with the new module
5. Tag a new release

## Known hardcoded values to be aware of

- `modules/dns`: the CNAME record name is hardcoded as `"music"` — needs to become a variable if used for a different subdomain
- `modules/hosting`: the custom domain is hardcoded as `"music.${var.domain}"` — same issue
- `modules/database`: `http://localhost:4321` is hardcoded as a dev OAuth redirect URL (port 4321 is the Astro dev server default)

Each module's own `AGENTS.md` has full variable, output, and gotcha details.
