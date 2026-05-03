variable "environment" {
  type = string
  default = "homelab"
}

variable "project" {
  type = string
  default = "docker"
}

variable "host_node" {
  description = "The node that the VM will be created on"
  type        = string
  default     = "pve"
}

variable "name" {
  description = "The name of the VM"
  type        = string
  default     = "garagehq"
}

variable "description" {
  description = "The description to use for the VM"
  type        = string
  default     = "GarageHQ VM"
}

variable "cluster" {
  description = "Cluster configuration"
  type = object({
    dns_servers                   = optional(list(string), ["10.10.10.1"])
    gateway                       = string
    ansible_ssh_username          = optional(string, "ubuntu")
    ansible_private_ssh_key_file  = optional(string, "~/.ssh/id_ed25519.pub")
    ha_group                      = optional(string, "docker-ha")
    template_bridge               = optional(string, "vmbr0")
    template_vm_id                = optional(number, 9150)
    template_node                 = optional(string, "pve")
    storage_pool                  = optional(string, "proxmox-nfs")
    ha_pool                       = optional(string, "docker-ha")
  })
}

variable "nodes" {
  description = "Configuration for cluster nodes"
  type = map(object({
    host_node       = string
    vm_type         = string
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

variable "reverse_proxy" {
  type = object({
    ip              = string
    hostname        = string
    domain          = optional(string, "localhost")
    description     = optional(string, "Managed by terraform")
    certificate_id  = number
  })
}

variable "reverse_proxy_host_override_uuid" {
  type = string
  default = null
}

# variable "reverse_proxy_ip" {
#   description = "The reverse proxy IP used for DNS"
#   type = string
#   default = null
# }

# variable "reverse_proxy_url" {
#   description = "The reverse proxy URL used for setting up reverse proxy configurations"
#   type = string
#   default = null
# }

variable "reverse_proxy_host" {
  description = "The reverse proxy configuration used for setting up reverse proxy configurations"
  type = map(object({
    domain          = string
    port            = number
    ip              = string
    forward_scheme  = string
  }))
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
