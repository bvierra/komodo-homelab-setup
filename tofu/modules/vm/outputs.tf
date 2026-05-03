output "vm_id" {
  description = "Proxmox VM ID of the node"
  value       = { for k, v in proxmox_virtual_environment_vm.vm : k => v.vm_id }
}

output "name" {
  description = "Name of the nodes"
  value       = { for k, v in var.nodes : v.vm_id => k }
}

output "vm_node_mapping" {
  description = "Map of talos VMs to Proxmox nodes"
  value       = { for k, v in proxmox_virtual_environment_vm.vm : k => v.node_name }
}

output "ip_addresses" {
  description = "IP addresses assigned to the node"
  value       = { for k, v in proxmox_virtual_environment_vm.vm : k => [for ip_list in v.ipv4_addresses : ip_list[0] if length(ip_list) > 0 && ip_list[0] != "127.0.0.1" && ip_list[0] != ""] }
}

output "ip_address" {
  description = "Primary IP address of the node"
  value       = { for k, v in proxmox_virtual_environment_vm.vm : k => try(
      v.ipv4_addresses[0][0],
      var.nodes[k].network_config["net0"].ip != null ? var.nodes[k].network_config["net0"].ip : "DHCP-assigned"
    ) }
}

