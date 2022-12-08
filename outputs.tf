#
# Terraform:: terraform-null-vault
# Plan:: outputs.tf
#

output "hostname" {
  sensitive   = false
  value       = data.external.hostname.result.hostname
  description = "System hostname"
}

output "CA" {
  sensitive   = false
  value       = abspath(local_sensitive_file.CA.filename)
  description = "CA certificate"
}

output "IntermediateCA" {
  sensitive   = false
  value       = abspath(local_sensitive_file.IntermediateCA.filename)
  description = "Intermediate CA certificate"
}

output "chain" {
  sensitive   = false
  value       = abspath(local_sensitive_file.chain.filename)
  description = "Certificate chain (Intermediate CA + CA)"
}

output "VAULT_ADDR" {
  sensitive   = false
  value       = "https://${data.external.hostname.result.hostname}:8200"
  description = "Vault address"
}

output "VAULT_CACERT" {
  sensitive   = false
  value       = abspath(local_sensitive_file.chain.filename)
  description = "Vault environment variable `VAULT_CACERT` (Intermediate CA + CA)"
}

output "VAULT_TOKEN" {
  sensitive   = true
  value       = regex("h?v?s\\..{24}$", split("\n", data.local_file.vault-init.content)[2])
  description = "Vault environment variable `VAULT_TOKEN` (i.e. Vault root token)"
}

output "VAULT_UNSEAL" {
  sensitive   = true
  value       = regex(".{44}$", split("\n", data.local_file.vault-init.content)[0])
  description = "Vault unseal token"
}
