module "vm" {
  source = "./modules/vm"

  common_tags     = var.common_tags
  cluster         = var.cluster
  nodes           = var.nodes
  komodo_core_api_key = var.komodo_core_api_key
  komodo_core_api_secret = var.komodo_core_api_secret
  komodo_core_url = var.komodo_core_url
}

