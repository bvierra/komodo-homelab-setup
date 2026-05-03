terraform {
  required_providers {
    ansible = {
      source  = "ansible/ansible"
      version = "1.4.0"
    }
    null = {
      source  = "hashicorp/null"
      version = "~> 3.2"
    }
    opnsense-dhcp = {
      source  = "gxben/opnsense"
      version = "0.3.1"
    }
    opnsense = {
      version = "0.18.0"
      source  = "browningluke/opnsense"
    }
    proxmox = {
      source  = "bpg/proxmox"
      version = "~> 0.98.0"
    }
    nginxproxymanager = {
      source  = "Sander0542/nginxproxymanager"
      version = "1.2.2"
    }
  }
}

provider "proxmox" {
  insecure = true
  ssh {
    agent       = false
    private_key = file("~/.ssh/id_ed25519")
    username    = "root"
  }
}


provider "opnsense" {
}

# provider "opnsense" {
#   uri      = "{{var.opnsense_url}}"
#   user     = "{{var.opnsense_user}}"
#   password = "{{var.opnsense_password}}"
# }
