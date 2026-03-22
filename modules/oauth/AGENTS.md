# AGENTS.md — modules/oauth

Placeholder module that passes Google OAuth credentials through to other modules (currently `database`). Does not create or manage any infrastructure — no provider is required.

## Why this exists

The `hashicorp/google` Terraform provider does not support creating OAuth 2.0 client credentials under **Google Cloud Console → APIs & Services → Credentials**. The OAuth client must be created manually. This module exists so that credentials have a single documented entry point in the module graph rather than being passed directly between modules.

If Google ever adds a Terraform resource for OAuth client creation, this is where the implementation would live.

## Prerequisites

A Google OAuth client must be created manually in the Google Cloud Console:

1. Go to **APIs & Services → Credentials → Create Credentials → OAuth client ID**
2. Application type: **Web application**
3. Add authorised redirect URIs:
   - `https://<your-supabase-project-id>.supabase.co/auth/v1/callback`
4. Copy the client ID and secret into macOS Keychain (see below)

## Required secrets

| Keychain key | TF_VAR | Description |
|---|---|---|
| `google_oauth_client_id` | `TF_VAR_google_oauth_client_id` | Google OAuth client ID |
| `google_oauth_client_secret` | `TF_VAR_google_oauth_client_secret` | Google OAuth client secret |

## Variables

| Name | Type | Required | Description |
|---|---|---|---|
| `client_id` | `string` | yes | Google OAuth client ID — sourced from Keychain |
| `client_secret` | `string` | yes | Google OAuth client secret — sourced from Keychain |

## Outputs

| Name | Sensitive | Description |
|---|---|---|
| `client_id` | yes | Passes `client_id` through — consumed by the `database` module |
| `client_secret` | yes | Passes `client_secret` through — consumed by the `database` module |

## Usage example

```hcl
module "oauth" {
  source        = "github.com/DrydenDev/terraform-modules//modules/oauth?ref=v1.0.0"
  client_id     = var.google_oauth_client_id
  client_secret = var.google_oauth_client_secret
}

module "database" {
  source = "github.com/DrydenDev/terraform-modules//modules/database?ref=v1.0.0"

  google_oauth_client_id     = module.oauth.client_id
  google_oauth_client_secret = module.oauth.client_secret
  # ...
}
```
