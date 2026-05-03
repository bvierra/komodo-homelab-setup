variable "cluster" {
  description = "Cluster configuration"
  type = object({
    dns_servers                   = optional(list(string), ["10.10.10.1"])
    gateway                       = string
    ansible_ssh_username          = optional(string, "ansible")
    ansible_private_ssh_key_file  = optional(string, "~/.ssh/id_ed25519.pub")
    ha_group                      = optional(string, "docker-ha")
    template_bridge               = optional(string, "vmbr0")
    template_vm_id                = optional(number, 9150)
    template_node                 = optional(string, "pve")
    storage_pool                  = optional(string, "proxmox-nfs")
  })
}

variable "nodes" {
  description = "Configuration for cluster nodes"
  type = map(object({
    host_node       = string
    vm_type         = string
    description     = optional(string, null)
    datastore_id    = optional(string, "local-zfs")
    network_config  = map(object({
      mac_address   = string
      ip            = string
      bridge        = optional(string, "vmbr0")
      vlan          = optional(number, null)
    }))
    vm_id           = number
    cpu             = number
    ram_max         = number
    ram_min         = number
    disk_size       = number
  }))
}

variable "common_tags" {
  type    = list(string)
  default = ["docker", "komodo"]
}

variable "komodo_core_api_key" {
  type = string
}
variable "komodo_core_api_secret" {
  type = string
}

variable "komodo_core_url" {
  type = string
}
