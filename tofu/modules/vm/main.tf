terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "~> 0.98.0"
    }
    null = {
      source  = "hashicorp/null"
      version = "~> 3.2"
    }
    ansible = {
      source  = "ansible/ansible"
      version = "1.4.0"
    }
    opnsense-dhcp = {
      source  = "dalet-oss/opnsense"
      version = "0.3.1"
    }
  }
}


# provider "opnsense" {
#   uri      = "{{var.opnsense_url}}"
#   user     = "{{var.opnsense_user}}"
#   password = "{{var.opnsense_password}}"
# }


resource "proxmox_virtual_environment_vm" "vm" {
  for_each = var.nodes

  node_name       = each.value.host_node
  name            = each.key
  stop_on_destroy = true

  description = each.value.description != null ? each.value.description : "Managed by terraform: {{var.environment}}/{{var.project}}"
  tags        = var.common_tags != null ? concat(var.common_tags, ["managed"]) : ["managed"]

  vm_id = each.value.vm_id

  machine       = "q35"
  scsi_hardware = "virtio-scsi-pci"
  migrate       = true

  bios = "seabios"
  clone {
    vm_id     = var.cluster.template_vm_id
    node_name = var.cluster.template_node
    full      = true
    retries   = 3
  }

  disk {
    interface    = "virtio0"
    size         = each.value.disk_size
    ssd          = false
    datastore_id = var.cluster.storage_pool
    file_format  = "qcow2"
  }

  initialization {
    datastore_id = var.cluster.storage_pool
    file_format  = "qcow2"
    dns {
      servers = var.cluster.dns_servers
    }
    ip_config {
      ipv4 {
        address = "${each.value.network_config["net0"].ip}/24"
        gateway = var.cluster.gateway
      }
    }
  }

  network_device {
    mac_address = each.value.network_config["net0"].mac_address
    model       = "virtio"
    bridge      = each.value.network_config["net0"].bridge
    vlan_id     = each.value.network_config["net0"].vlan
  }

  network_device {
    mac_address = each.value.network_config["net1"].mac_address
    model       = "virtio"
    bridge      = each.value.network_config["net1"].bridge
    vlan_id     = each.value.network_config["net1"].vlan
  }

  operating_system {
    type = "l26"
  }

  cpu {
    cores = each.value.cpu
    type  = "host"
  }

  memory {
    dedicated = each.value.ram_max * 1024
    floating  = each.value.ram_min * 1024
  }

  agent {
    enabled = true
  }

  lifecycle {
    ignore_changes = [node_name]
  }

}

# resource "proxmox_virtual_environment_haresource" "ha_managed" {
#   for_each     = var.nodes
#   resource_id = "vm:${each.value.vm_id}"
#   group       = "${var.cluster.ha_group}"
#   state       = "started"
# }

resource "ansible_host" "host" {
  for_each = var.nodes
  name     = each.key
  groups   = each.value.vm_type == "parent" ? ["komodo", "core", "periphery"] : ["periphery", "komodo"]
  variables = {
    ansible_user                 = var.cluster.ansible_ssh_username
    ansible_ssh_private_key_file = var.cluster.ansible_private_ssh_key_file
    ansible_ssh_common_args      = "-o StrictHostKeyChecking=no"
    ansible_become               = true
    ansible_become_user          = "root"
    ansible_host                 = each.value.network_config["net0"].ip
    node_site                    = "home"
  }
}

resource "ansible_group" "komodo" {
  name      = "komodo"
  children  = ["core", "periphery"]
  variables = {}
}

resource "ansible_group" "core" {
  name      = "core"
  variables = {}
}

resource "ansible_group" "docker" {
  name      = "docker"
  variables = {}
}

resource "ansible_group" "periphery" {
  name      = "periphery"
  variables = {}
}

resource "opnsense_dhcp_static_map" "dhcp1" {
  provider  = opnsense-dhcp
  for_each  = var.nodes
  interface = "opt33"
  mac       = each.value.network_config["net0"].mac_address
  ipaddr    = each.value.network_config["net0"].ip
  hostname  = each.key
}
