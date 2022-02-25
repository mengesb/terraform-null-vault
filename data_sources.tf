#
# Terraform:: terraform-null-vault
# Plan:: data_sources.tf
#

data "external" "hostname" {
  program = ["${path.module}/scripts/hostname.bash"]
}

data "local_file" "vault-init" {
  depends_on = [null_resource.vault-init]
  filename   = "${abspath(path.root)}/vault.init"
}
