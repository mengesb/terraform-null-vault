#
# Terraform:: terraform-null-vault
# Plan:: locals.tf
#

locals {
  vault-hcl = {
    hostname      = data.external.hostname.result.hostname
    tls_cert_file = abspath(local_file.vault-cert.filename)
    tls_key_file  = abspath(local_file.vault-key.filename)
    raft_path     = "${abspath(path.root)}/vault/data"
    raft_node_id  = uuidv5("dns", data.external.hostname.result.hostname)
  }
}

resource "local_file" "CA" {
  sensitive_content    = tls_self_signed_cert.CA.cert_pem
  filename             = "${path.root}/vault/tls/CA.pem"
  file_permission      = "0600"
  directory_permission = "0700"
}

resource "local_file" "IntermediateCA" {
  sensitive_content    = tls_locally_signed_cert.IntermediateCA.cert_pem
  filename             = "${path.root}/vault/tls/IntermediateCA.pem"
  file_permission      = "0600"
  directory_permission = "0700"
}

resource "local_file" "chain" {
  sensitive_content    = "${tls_locally_signed_cert.IntermediateCA.cert_pem}${tls_self_signed_cert.CA.cert_pem}"
  filename             = "${path.root}/vault/tls/chain.pem"
  file_permission      = "0600"
  directory_permission = "0700"
}

resource "local_file" "vault-key" {
  sensitive_content    = tls_private_key.vault.private_key_pem
  filename             = "${path.root}/vault/tls/${data.external.hostname.result.hostname}.key"
  file_permission      = "0600"
  directory_permission = "0700"
}

resource "local_file" "vault-cert" {
  sensitive_content    = "${tls_locally_signed_cert.vault.cert_pem}${tls_locally_signed_cert.IntermediateCA.cert_pem}${tls_self_signed_cert.CA.cert_pem}"
  filename             = "${path.root}/vault/tls/${data.external.hostname.result.hostname}.pem"
  file_permission      = "0600"
  directory_permission = "0700"
}

resource "local_file" "vault-hcl" {
  sensitive_content = templatefile("${path.module}/files/vault.hcl.tftpl", local.vault-hcl)
  filename          = "${path.root}/vault/vault.hcl"
  file_permission   = "0600"
}
