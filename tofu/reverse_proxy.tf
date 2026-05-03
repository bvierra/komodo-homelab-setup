# import {
#   to = opnsense_unbound_host_override.reverse_proxy
#   id = "{{var.reverse_proxy_host_override_uuid}}"
# }


# resource "opnsense_unbound_host_override" "reverse_proxy" {
#   enabled     = true
#   hostname    = var.reverse_proxy.hostname
#   description = var.reverse_proxy.description
#   domain      = var.reverse_proxy.domain
#   server      = var.reverse_proxy.ip
#   lifecycle { prevent_destroy = true }
# }

# resource "opnsense_unbound_host_alias" "alias" {
#   for_each    = var.reverse_proxy_host

#   override    = opnsense_unbound_host_override.reverse_proxy.id
#   domain      = each.value.domain
#   hostname    = each.key
#   enabled     = true
#   description = "Managed by terraform"
# }

# resource "opnsense_unbound_host_alias" "wildcard" {
#   override    = opnsense_unbound_host_override.reverse_proxy.id
#   domain      = "lab.vierra.host"
#   hostname    = "*"
#   enabled     = true
#   description = "Managed by terraform"
#   lifecycle { prevent_destroy = true }
# }


# resource "nginxproxymanager_proxy_host" "host" {
#   for_each        = var.reverse_proxy_host
#   domain_names    = ["{{each.key}}.{{each.value.domain}}"]
#   forward_host    = each.value.ip
#   forward_port    = each.value.port
#   forward_scheme  = each.value.forward_scheme

#   caching_enabled         = true
#   allow_websocket_upgrade = true

#   certificate_id  = var.reverse_proxy.certificate_id
#   ssl_forced      = true
#   http2_support   = true
# }
