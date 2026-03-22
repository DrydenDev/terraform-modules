# AGENTS.md — modules/database

Creates a Supabase project and configures Google OAuth authentication settings. Has `prevent_destroy = true` on the project resource — Terraform will refuse to destroy it unless that lifecycle rule is explicitly removed.

## Provider

`supabase/supabase ~> 1.0`

## Prerequisites

- A Supabase organization must exist. Find the organization ID in the Supabase dashboard under **Org Settings → General → Organization ID**.
- Google OAuth client credentials must already exist (created manually in Google Cloud Console — see the `oauth` module). Pass them in via the `google_oauth_client_id` and `google_oauth_client_secret` variables.
- The free tier allows a maximum of **2 active projects per organization**. If you're at the limit, pause or delete an existing project before applying.

## Required secrets

| Keychain key | TF_VAR | Description |
|---|---|---|
| `supabase_access_token` | `TF_VAR_supabase_access_token` | Supabase personal access token |
| `supabase_db_password` | `TF_VAR_supabase_db_password` | Database password for the new project |
| `google_oauth_client_id` | `TF_VAR_google_oauth_client_id` | Google OAuth client ID (passed through from `oauth` module) |
| `google_oauth_client_secret` | `TF_VAR_google_oauth_client_secret` | Google OAuth client secret (passed through from `oauth` module) |

## Variables

| Name | Type | Required | Description |
|---|---|---|---|
| `supabase_access_token` | `string` | yes | Supabase personal access token — sourced from Keychain |
| `project_name` | `string` | yes | Display name for the Supabase project (e.g. `"Music Ratings"`) |
| `organization_id` | `string` | yes | Supabase organization ID — from the dashboard, not sensitive |
| `db_password` | `string` | yes | Database password — sourced from Keychain |
| `region` | `string` | yes | Supabase project region (e.g. `us-west-2`). **Immutable after creation** — if the project already exists, this must match the actual region or Terraform will error |
| `google_oauth_client_id` | `string` | yes | Google OAuth client ID — typically `module.oauth.client_id` |
| `google_oauth_client_secret` | `string` | yes | Google OAuth client secret — typically `module.oauth.client_secret` |
| `site_url` | `string` | yes | Production URL (e.g. `https://music.andie-xd.com`) — used by Supabase Auth as the allowed site URL and OAuth redirect base |

## Outputs

| Name | Sensitive | Description |
|---|---|---|
| `project_id` | no | Supabase project ref ID (e.g. `ilhxkayvkrwmhdvzqalb`) |
| `project_url` | no | Supabase API URL — use as `SUPABASE_URL` / `PUBLIC_SUPABASE_URL` env var |
| `db_url` | yes | PostgreSQL connection string via Supabase pooler — use as `DATABASE_URL` env var |

## Usage example

```hcl
module "oauth" {
  source        = "github.com/DrydenDev/terraform-modules//modules/oauth?ref=v1.0.0"
  client_id     = var.google_oauth_client_id
  client_secret = var.google_oauth_client_secret
}

module "database" {
  source = "github.com/DrydenDev/terraform-modules//modules/database?ref=v1.0.0"

  supabase_access_token      = var.supabase_access_token
  project_name               = "My Project"
  db_password                = var.supabase_db_password
  region                     = var.supabase_region
  organization_id            = var.supabase_organization_id
  google_oauth_client_id     = module.oauth.client_id
  google_oauth_client_secret = module.oauth.client_secret
  site_url                   = "https://${var.domain}"
}
```

## What it creates/manages

- `supabase_project.this` — the Supabase project (with `prevent_destroy = true`)
- `supabase_settings.auth` — configures Supabase Auth with:
  - `site_url` set to the production URL
  - OAuth redirects allowed to `<site_url>/auth/callback` and `http://localhost:4321/auth/callback`
  - Google OAuth enabled with the provided client credentials

## Importing an existing project

If the project already exists, import it before applying:

```bash
terraform import module.database.supabase_project.this <project_id>
```

Find the project ID via the Supabase API:
```bash
curl -s https://api.supabase.com/v1/projects \
  -H "Authorization: Bearer <access_token>" | python3 -c "
import json, sys
for p in json.load(sys.stdin): print(p['id'], p['name'])
"
```

## ⚠️ Known limitations

- `region` is immutable after creation. If the imported project's region doesn't match the variable, Terraform will error. Always set `region` to match the actual project region.
- `http://localhost:4321` is hardcoded as a dev OAuth redirect URL. Port 4321 is the Astro dev server default — update this if using a different framework or port.
- `prevent_destroy = true` means `terraform destroy` will fail for this resource. This is intentional. To destroy the project, remove the lifecycle block first.
