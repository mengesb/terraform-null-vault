#
# Terraform:: terraform-null-vault
# Plan:: tls.tf
#

resource "tls_private_key" "CA" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "tls_private_key" "IntermediateCA" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "tls_private_key" "vault" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "tls_self_signed_cert" "CA" {
  private_key_pem       = tls_private_key.CA.private_key_pem
  validity_period_hours = 168
  is_ca_certificate     = true
  set_subject_key_id    = true
  allowed_uses          = var.ca_allowed_uses

  subject {
    country             = var.CA.country
    province            = var.CA.province
    locality            = var.CA.locality
    common_name         = var.CA.common_name
    organization        = var.CA.organization
    organizational_unit = var.CA.organizational_unit
  }
}

resource "tls_cert_request" "IntermediateCA" {
  private_key_pem = tls_private_key.IntermediateCA.private_key_pem

  subject {
    country             = var.IntermediateCA.country
    province            = var.IntermediateCA.province
    locality            = var.IntermediateCA.locality
    common_name         = var.IntermediateCA.common_name
    organization        = var.IntermediateCA.organization
    organizational_unit = var.IntermediateCA.organizational_unit
  }
}

resource "tls_locally_signed_cert" "IntermediateCA" {
  cert_request_pem      = tls_cert_request.IntermediateCA.cert_request_pem
  ca_private_key_pem    = tls_private_key.CA.private_key_pem
  ca_cert_pem           = tls_self_signed_cert.CA.cert_pem
  validity_period_hours = 72
  is_ca_certificate     = true
  set_subject_key_id    = true
  allowed_uses          = var.intermediateca_allowed_uses
}

resource "tls_cert_request" "vault" {
  dns_names       = [data.external.hostname.result.hostname, "host.minikube.internal", "host.docker.internal", "localhost", "localhost.localdomain"]
  private_key_pem = tls_private_key.vault.private_key_pem

  subject {
    country             = var.vault-tls.country
    province            = var.vault-tls.province
    locality            = var.vault-tls.locality
    common_name         = data.external.hostname.result.hostname
    organization        = var.vault-tls.organization
    organizational_unit = var.vault-tls.organizational_unit
  }
}

resource "tls_locally_signed_cert" "vault" {
  cert_request_pem      = tls_cert_request.vault.cert_request_pem
  ca_private_key_pem    = tls_private_key.IntermediateCA.private_key_pem
  ca_cert_pem           = tls_locally_signed_cert.IntermediateCA.cert_pem
  validity_period_hours = 48
  set_subject_key_id    = true
  allowed_uses          = var.cert_allowed_uses
}
