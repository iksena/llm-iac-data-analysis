output "ducklake_postgres_ip" {
  value       = hcloud_server.ducklake-postgres.ipv4_address
  description = "DuckLake PostgreSQL server IP"
}
