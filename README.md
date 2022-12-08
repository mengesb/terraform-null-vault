<!--- BEGIN_TF_DOCS --->
<!-- markdownlint-disable MD024 MD033 -->
# terraform-null-vault

Terraform module to build a local vault TLS secured instance for developers

## Requirements

The following requirements are needed by this module:

- <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) (~> 1.2.0)

- <a name="requirement_external"></a> [external](#requirement\_external) (~> 2.2)

- <a name="requirement_local"></a> [local](#requirement\_local) (~> 2.1)

- <a name="requirement_null"></a> [null](#requirement\_null) (~> 3.1)

- <a name="requirement_tls"></a> [tls](#requirement\_tls) (~> 3.1)

## Required Inputs

No required inputs.

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_CA"></a> [CA](#input\_CA)

Description: CA TLS certificate settings

Type:

```hcl
object({
    country             = optional(string)
    province            = optional(string)
    locality            = optional(string)
    common_name         = string
    organization        = optional(string)
    organizational_unit = optional(string)
  })
```

Default:

```json
{
  "common_name": "Vault Demo CA",
  "country": "US",
  "locality": "San Francisco",
  "organization": "Demo Organization",
  "organizational_unit": "Demo Engineering Team",
  "province": "California"
}
```

### <a name="input_IntermediateCA"></a> [IntermediateCA](#input\_IntermediateCA)

Description: Intermediate CA TLS certificate settings

Type:

```hcl
object({
    country             = optional(string)
    province            = optional(string)
    locality            = optional(string)
    common_name         = string
    organization        = optional(string)
    organizational_unit = optional(string)
  })
```

Default:

```json
{
  "common_name": "Vault Demo CA",
  "country": "US",
  "locality": "San Francisco",
  "organization": "Demo Organization",
  "organizational_unit": "Demo Engineering Team",
  "province": "California"
}
```

### <a name="input_ca_allowed_uses"></a> [ca\_allowed\_uses](#input\_ca\_allowed\_uses)

Description: List of allowed uses parameters for CA certificate

Type: `list(string)`

Default:

```json
[
  "cert_signing",
  "client_auth",
  "crl_signing",
  "digital_signature",
  "key_encipherment",
  "ocsp_signing",
  "server_auth"
]
```

### <a name="input_cert_allowed_uses"></a> [cert\_allowed\_uses](#input\_cert\_allowed\_uses)

Description: List of allowed uses parameters for CA certificate

Type: `list(string)`

Default:

```json
[
  "digital_signature",
  "key_encipherment",
  "server_auth"
]
```

### <a name="input_intermediateca_allowed_uses"></a> [intermediateca\_allowed\_uses](#input\_intermediateca\_allowed\_uses)

Description: List of allowed uses parameters for CA certificate

Type: `list(string)`

Default:

```json
[
  "cert_signing",
  "client_auth",
  "crl_signing",
  "digital_signature",
  "key_encipherment",
  "ocsp_signing",
  "server_auth"
]
```

### <a name="input_ip_addresses"></a> [ip\_addresses](#input\_ip\_addresses)

Description: List of IP addresses for TLS certificates

Type: `list(string)`

Default:

```json
[
  "127.0.0.1"
]
```

### <a name="input_vault-tls"></a> [vault-tls](#input\_vault-tls)

Description: Vault TLS certificate settings

Type:

```hcl
object({
    country             = optional(string)
    province            = optional(string)
    locality            = optional(string)
    organization        = optional(string)
    organizational_unit = optional(string)
  })
```

Default:

```json
{
  "country": "US",
  "locality": "San Francisco",
  "organization": "Demo Organization",
  "organizational_unit": "Demo Engineering Team",
  "province": "California"
}
```

## Outputs

The following outputs are exported:

### <a name="output_CA"></a> [CA](#output\_CA)

Description: CA certificate

### <a name="output_IntermediateCA"></a> [IntermediateCA](#output\_IntermediateCA)

Description: Intermediate CA certificate

### <a name="output_VAULT_ADDR"></a> [VAULT\_ADDR](#output\_VAULT\_ADDR)

Description: Vault address

### <a name="output_VAULT_CACERT"></a> [VAULT\_CACERT](#output\_VAULT\_CACERT)

Description: Vault environment variable `VAULT_CACERT` (Intermediate CA + CA)

### <a name="output_VAULT_TOKEN"></a> [VAULT\_TOKEN](#output\_VAULT\_TOKEN)

Description: Vault environment variable `VAULT_TOKEN` (i.e. Vault root token)

### <a name="output_VAULT_UNSEAL"></a> [VAULT\_UNSEAL](#output\_VAULT\_UNSEAL)

Description: Vault unseal token

### <a name="output_chain"></a> [chain](#output\_chain)

Description: Certificate chain (Intermediate CA + CA)

### <a name="output_hostname"></a> [hostname](#output\_hostname)

Description: System hostname

## Contributing

Contributions are always welcome. Please consult our [CONTRIBUTING.md](CONTRIBUTING.md) file for more information on how to submit quality contributions.

## License & Authors

Author: Brian Menges (@mengesb)

```text
   Copyright 2022 Brian Menges

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
```

<!--- END_TF_DOCS --->