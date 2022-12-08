#
# Terraform:: terraform-null-vault
# Plan:: main.tf
#

resource "null_resource" "vault-dir" {
  provisioner "local-exec" {
    command = "mkdir -p ${abspath(path.root)}/vault/data"
  }

  provisioner "local-exec" {
    when       = destroy
    on_failure = continue
    command    = "rm -rf ${abspath(path.root)}/vault"
  }
}

resource "null_resource" "vault-start" {
  depends_on = [
    local_sensitive_file.CA,
    local_sensitive_file.IntermediateCA,
    local_sensitive_file.chain,
    local_sensitive_file.vault-cert,
    local_sensitive_file.vault-hcl,
    null_resource.vault-dir
  ]

  provisioner "local-exec" {
    command = "vault server -config=${abspath(path.root)}/vault/vault.hcl </dev/null &>${abspath(path.root)}/vault.console.log &"
  }

  provisioner "local-exec" {
    command = "sleep 2 && pgrep vault > ${abspath(path.root)}/vault.pid"
  }

  provisioner "local-exec" {
    when       = destroy
    on_failure = continue
    command    = "pkill -F ${abspath(path.root)}/vault.pid"
  }

  provisioner "local-exec" {
    when       = destroy
    on_failure = continue
    command    = "rm -f ${abspath(path.root)}/vault.{audit.log,console.log,env,init,pid}"
  }
}

resource "null_resource" "vault-init" {
  depends_on = [
    null_resource.vault-start
  ]

  provisioner "local-exec" {
    command = "echo Sleeping for 5 seconds to let HashiCorp Vault start && sleep 5"
  }

  provisioner "local-exec" {
    environment = {
      VAULT_ADDR            = "https://${data.external.hostname.result.hostname}:8200"
      VAULT_CACERT          = abspath(local_sensitive_file.chain.filename)
      VAULT_TLS_SERVER_NAME = data.external.hostname.result.hostname
    }
    command = "vault operator init -key-shares=1 -key-threshold=1 >${abspath(path.root)}/vault.init"
  }
}

resource "null_resource" "vault-unseal" {
  depends_on = [
    null_resource.vault-start,
    null_resource.vault-init
  ]

  provisioner "local-exec" {
    command = "echo Sleeping for 5 seconds to let HashiCorp Vault Initialize && sleep 5"
  }

  provisioner "local-exec" {
    environment = {
      VAULT_ADDR       = "https://${data.external.hostname.result.hostname}:8200"
      VAULT_CACERT     = abspath(local_sensitive_file.chain.filename)
      VAULT_UNSEAL_KEY = regex(".{44}$", split("\n", data.local_file.vault-init.content)[0])
    }
    command = "vault operator unseal $VAULT_UNSEAL_KEY"
  }

  provisioner "local-exec" {
    command = "echo Sleeping for 10 seconds to let HashiCorp Vault complete unseal operation && sleep 10"
  }
}

resource "null_resource" "vault-audit" {
  depends_on = [
    local_sensitive_file.chain,
    null_resource.vault-start,
    null_resource.vault-init,
    null_resource.vault-unseal
  ]

  provisioner "local-exec" {
    environment = {
      VAULT_ADDR   = "https://${data.external.hostname.result.hostname}:8200"
      VAULT_CACERT = abspath(local_sensitive_file.vault-cert.filename)
      VAULT_TOKEN  = regex("h?v?s\\..{24}$", split("\n", data.local_file.vault-init.content)[2])
    }
    command = "vault audit enable -path=audit -local=true -description=\"Local audit log\" file file_path=vault.audit.log"
  }
}

resource "null_resource" "vault-secret-engines" {
  depends_on = [
    local_sensitive_file.chain,
    null_resource.vault-start,
    null_resource.vault-init,
    null_resource.vault-unseal,
    null_resource.vault-audit
  ]

  provisioner "local-exec" {
    environment = {
      VAULT_ADDR   = "https://${data.external.hostname.result.hostname}:8200"
      VAULT_CACERT = abspath(local_sensitive_file.vault-cert.filename)
      VAULT_TOKEN  = regex("h?v?s\\..{24}$", split("\n", data.local_file.vault-init.content)[2])
    }
    command = "vault secrets enable database"
  }

  provisioner "local-exec" {
    environment = {
      VAULT_ADDR   = "https://${data.external.hostname.result.hostname}:8200"
      VAULT_CACERT = abspath(local_sensitive_file.vault-cert.filename)
      VAULT_TOKEN  = regex("h?v?s\\..{24}$", split("\n", data.local_file.vault-init.content)[2])
    }
    command = "vault secrets enable -version=2 -path=secret kv"
  }

  provisioner "local-exec" {
    environment = {
      VAULT_ADDR   = "https://${data.external.hostname.result.hostname}:8200"
      VAULT_CACERT = abspath(local_sensitive_file.vault-cert.filename)
      VAULT_TOKEN  = regex("h?v?s\\..{24}$", split("\n", data.local_file.vault-init.content)[2])
    }
    command = "vault secrets enable transit"
  }
}
