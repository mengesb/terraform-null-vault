#
# Terraform:: terraform-null-vault
# Plan:: variables.tf
#

variable "CA" {
  sensitive = false
  type = object({
    country             = optional(string)
    province            = optional(string)
    locality            = optional(string)
    common_name         = string
    organization        = optional(string)
    organizational_unit = optional(string)
  })
  description = "CA TLS certificate settings"
  default = {
    country             = "US"
    province            = "California"
    locality            = "San Francisco"
    common_name         = "Vault Demo CA"
    organization        = "Demo Organization"
    organizational_unit = "Demo Engineering Team"
  }

  validation {
    condition     = var.CA.country == null ? true : can(regex("^[A-Z]{2}$", var.CA.country))
    error_message = "Country subject of CA certificate must be a 2 letter abreviation."
  }

  validation {
    condition     = var.CA.province == null ? true : length(regexall("\\b([A-Z])+", var.CA.province)) == length(split(" ", var.CA.province))
    error_message = "Province subject of CA certificate must contain a capital letter at the beginning of each word."
  }

  validation {
    condition     = var.CA.locality == null ? true : length(regexall("\\b([A-Z])+", var.CA.locality)) == length(split(" ", var.CA.locality))
    error_message = "Locality subject of CA certificate must contain a capital letter at the beginning of each word."
  }

  validation {
    condition     = var.CA.locality == null ? true : length(var.CA.locality) < 65
    error_message = "Locality subject must be 64 characters or less."
  }

  validation {
    condition     = length(var.CA.common_name) < 65
    error_message = "Common name subject must be 64 characters or less."
  }

  validation {
    condition     = var.CA.organization == null ? true : length(var.CA.organization) < 65
    error_message = "Organization name subject must be 64 characters or less."
  }

  validation {
    condition     = var.CA.organizational_unit == null ? true : length(var.CA.organizational_unit) < 65
    error_message = "Organizational unit name subject must be 64 characters or less."
  }
}

variable "IntermediateCA" {
  sensitive = false
  type = object({
    country             = optional(string)
    province            = optional(string)
    locality            = optional(string)
    common_name         = string
    organization        = optional(string)
    organizational_unit = optional(string)
  })
  description = "Intermediate CA TLS certificate settings"
  default = {
    country             = "US"
    province            = "California"
    locality            = "San Francisco"
    common_name         = "Vault Demo CA"
    organization        = "Demo Organization"
    organizational_unit = "Demo Engineering Team"
  }

  validation {
    condition     = var.IntermediateCA.country == null ? true : can(regex("^[A-Z]{2}$", var.IntermediateCA.country))
    error_message = "Country subject of CA certificate must be 2 letter abreviation."
  }

  validation {
    condition     = var.IntermediateCA.province == null ? true : length(regexall("\\b([A-Z])+", var.IntermediateCA.province)) == length(split(" ", var.IntermediateCA.province))
    error_message = "Province subject of CA certificate must contain a capital letter at the beginning of each word."
  }

  validation {
    condition     = var.IntermediateCA.locality == null ? true : length(regexall("\\b([A-Z])+", var.IntermediateCA.locality)) == length(split(" ", var.IntermediateCA.locality))
    error_message = "Locality subject of CA certificate must contain a capital letter at the beginning of each word."
  }

  validation {
    condition     = var.IntermediateCA.locality == null ? true : length(var.IntermediateCA.locality) < 65
    error_message = "Locality subject must be 64 characters or less."
  }

  validation {
    condition     = length(var.IntermediateCA.common_name) < 65
    error_message = "Common name subject must be 64 characters or less."
  }

  validation {
    condition     = var.IntermediateCA.organization == null ? true : length(var.IntermediateCA.organization) < 65
    error_message = "Organization name subject must be 64 characters or less."
  }

  validation {
    condition     = var.IntermediateCA.organizational_unit == null ? true : length(var.IntermediateCA.organizational_unit) < 65
    error_message = "Organizational unit name subject must be 64 characters or less."
  }
}

variable "vault-tls" {
  sensitive = false
  type = object({
    country             = optional(string)
    province            = optional(string)
    locality            = optional(string)
    organization        = optional(string)
    organizational_unit = optional(string)
  })
  description = "Vault TLS certificate settings"
  default = {
    country             = "US"
    province            = "California"
    locality            = "San Francisco"
    organization        = "Demo Organization"
    organizational_unit = "Demo Engineering Team"
  }

  validation {
    condition     = var.vault-tls.country == null ? true : can(regex("^[A-Z]{2}$", var.vault-tls.country))
    error_message = "Country subject of CA certificate must be 2 letter abreviation."
  }

  validation {
    condition     = var.vault-tls.province == null ? true : length(regexall("\\b([A-Z])+", var.vault-tls.province)) == length(split(" ", var.vault-tls.province))
    error_message = "Province subject of CA certificate must contain a capital letter at the beginning of each word."
  }

  validation {
    condition     = var.vault-tls.locality == null ? true : length(regexall("\\b([A-Z])+", var.vault-tls.locality)) == length(split(" ", var.vault-tls.locality))
    error_message = "Locality subject of CA certificate must contain a capital letter at the beginning of each word."
  }

  validation {
    condition     = var.vault-tls.locality == null ? true : length(var.vault-tls.locality) < 65
    error_message = "Locality subject must be 64 characters or less."
  }

  validation {
    condition     = var.vault-tls.organization == null ? true : length(var.vault-tls.organization) < 65
    error_message = "Organization name subject must be 64 characters or less."
  }

  validation {
    condition     = var.vault-tls.organizational_unit == null ? true : length(var.vault-tls.organizational_unit) < 65
    error_message = "Organizational unit name subject must be 64 characters or less."
  }
}

variable "ip_addresses" {
  sensitive   = false
  type        = list(string)
  description = "List of IP addresses for TLS certificates"
  default     = ["127.0.0.1"]
}

variable "ca_allowed_uses" {
  sensitive   = false
  type        = list(string)
  description = "List of allowed uses parameters for CA certificate"
  default     = ["cert_signing", "client_auth", "crl_signing", "digital_signature", "key_encipherment", "ocsp_signing", "server_auth"]

  validation {
    condition     = length([for i in var.ca_allowed_uses : true if contains(["digital_signature", "content_commitment", "key_encipherment", "data_encipherment", "key_agreement", "cert_signing", "crl_signing", "encipher_only", "decipher_only", "any_extended", "server_auth", "client_auth", "code_signing", "email_protection", "ipsec_end_system", "ipsec_tunnel", "ipsec_user", "timestamping", "ocsp_signing", "microsoft_server_gated_crypto", "netscape_server_gated_crypto"], i)]) == length(var.ca_allowed_uses)
    error_message = "TLS Certificate allowed uses must be a list containing only items from the following list: digital_signature, content_commitment, key_encipherment, data_encipherment, key_agreement, cert_signing, crl_signing, encipher_only, decipher_only, any_extended, server_auth, client_auth, code_signing, email_protection, ipsec_end_system, ipsec_tunnel, ipsec_user, timestamping, ocsp_signing, microsoft_server_gated_crypto, netscape_server_gated_crypto."
  }
}

variable "intermediateca_allowed_uses" {
  sensitive   = false
  type        = list(string)
  description = "List of allowed uses parameters for CA certificate"
  default     = ["cert_signing", "client_auth", "crl_signing", "digital_signature", "key_encipherment", "ocsp_signing", "server_auth"]

  validation {
    condition     = length([for i in var.intermediateca_allowed_uses : true if contains(["digital_signature", "content_commitment", "key_encipherment", "data_encipherment", "key_agreement", "cert_signing", "crl_signing", "encipher_only", "decipher_only", "any_extended", "server_auth", "client_auth", "code_signing", "email_protection", "ipsec_end_system", "ipsec_tunnel", "ipsec_user", "timestamping", "ocsp_signing", "microsoft_server_gated_crypto", "netscape_server_gated_crypto"], i)]) == length(var.intermediateca_allowed_uses)
    error_message = "TLS Certificate allowed uses must be a list containing only items from the following list: digital_signature, content_commitment, key_encipherment, data_encipherment, key_agreement, cert_signing, crl_signing, encipher_only, decipher_only, any_extended, server_auth, client_auth, code_signing, email_protection, ipsec_end_system, ipsec_tunnel, ipsec_user, timestamping, ocsp_signing, microsoft_server_gated_crypto, netscape_server_gated_crypto."
  }
}

variable "cert_allowed_uses" {
  sensitive   = false
  type        = list(string)
  description = "List of allowed uses parameters for CA certificate"
  default     = ["digital_signature", "key_encipherment", "server_auth"]

  validation {
    condition     = length([for i in var.cert_allowed_uses : true if contains(["digital_signature", "content_commitment", "key_encipherment", "data_encipherment", "key_agreement", "cert_signing", "crl_signing", "encipher_only", "decipher_only", "any_extended", "server_auth", "client_auth", "code_signing", "email_protection", "ipsec_end_system", "ipsec_tunnel", "ipsec_user", "timestamping", "ocsp_signing", "microsoft_server_gated_crypto", "netscape_server_gated_crypto"], i)]) == length(var.cert_allowed_uses)
    error_message = "TLS Certificate allowed uses must be a list containing only items from the following list: digital_signature, content_commitment, key_encipherment, data_encipherment, key_agreement, cert_signing, crl_signing, encipher_only, decipher_only, any_extended, server_auth, client_auth, code_signing, email_protection, ipsec_end_system, ipsec_tunnel, ipsec_user, timestamping, ocsp_signing, microsoft_server_gated_crypto, netscape_server_gated_crypto."
  }
}

