# terraform-modules

Reusable Terraform modules for the DrydenDev stack:
- **Cloudflare** — DNS record management
- **Netlify** — Site build settings, domain settings, deploy keys
- **Supabase** — Project + Google OAuth auth configuration
- **Google OAuth** — Placeholder (no Terraform resource exists yet)

## Usage

Reference a module in any project's `main.tf`:

```hcl
module "dns" {
  source = "github.com/DrydenDev/terraform-modules//modules/dns?ref=v1.0.0"

  cloudflare_api_token = var.cloudflare_api_token
  domain               = var.domain
  netlify_subdomain    = module.hosting.netlify_subdomain
}

module "hosting" {
  source = "github.com/DrydenDev/terraform-modules//modules/hosting?ref=v1.0.0"

  netlify_token = var.netlify_token
  domain        = var.domain
  github_repo   = var.github_repo
  site_name     = var.netlify_site_name
  team_slug     = var.netlify_team_slug
}

module "database" {
  source = "github.com/DrydenDev/terraform-modules//modules/database?ref=v1.0.0"

  supabase_access_token      = var.supabase_access_token
  project_name               = "my-project"
  db_password                = var.supabase_db_password
  region                     = var.supabase_region
  organization_id            = var.supabase_organization_id
  google_oauth_client_id     = var.google_oauth_client_id
  google_oauth_client_secret = var.google_oauth_client_secret
  site_url                   = "https://${var.domain}"
}
```

After adding or changing a `source` reference, run `terraform init` in the consuming project.

## Versioning

Releases are tagged with semver. To use a specific version, set `?ref=vX.Y.Z`.

To cut a new release:
```bash
git tag v1.0.0
git push origin v1.0.0
```

Consuming projects pin to a tag and bump it deliberately:
```hcl
source = "github.com/DrydenDev/terraform-modules//modules/dns?ref=v1.1.0"
```

## Modules

### `modules/dns`
Manages a Cloudflare DNS CNAME record pointing a subdomain at a Netlify site.

| Variable | Description |
|---|---|
| `cloudflare_api_token` | Cloudflare API token |
| `domain` | Root domain (e.g. `andie-xd.com`) |
| `netlify_subdomain` | Netlify site name (e.g. `music-ratings`) |

### `modules/hosting`
Manages Netlify build settings and custom domain for an existing site.

| Variable | Description |
|---|---|
| `netlify_token` | Netlify personal access token |
| `domain` | Root domain |
| `github_repo` | GitHub repo in `owner/name` format |
| `site_name` | Netlify site name (e.g. `music-ratings`) |
| `team_slug` | Netlify team slug |

### `modules/database`
Creates a Supabase project and configures Google OAuth auth settings.

| Variable | Description |
|---|---|
| `supabase_access_token` | Supabase personal access token |
| `project_name` | Supabase project display name |
| `db_password` | Database password |
| `region` | Supabase region (e.g. `us-west-2`) |
| `organization_id` | Supabase organization ID |
| `google_oauth_client_id` | Google OAuth client ID |
| `google_oauth_client_secret` | Google OAuth client secret |
| `site_url` | Production URL for auth redirect configuration |
