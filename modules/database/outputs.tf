output "project_id" {
  description = "Supabase project ID"
  value       = supabase_project.this.id
}

output "project_url" {
  description = "Supabase project API URL (SUPABASE_URL env var)"
  value       = "https://${supabase_project.this.id}.supabase.co"
}

output "db_url" {
  description = "PostgreSQL connection string via Supabase pooler (DATABASE_URL env var)"
  value       = "postgresql://postgres.${supabase_project.this.id}:${var.db_password}@aws-0-${var.region}.pooler.supabase.com:6543/postgres"
  sensitive   = true
}
