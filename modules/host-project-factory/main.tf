/* -------------------------------------------------------------------------- */
/*                             Create the Projects                            */
/* -------------------------------------------------------------------------- */

module "host_project" {
  source                         = "terraform-google-modules/project-factory/google"
  version                        = "10.3.2"
  name                           = var.projectName
  org_id                         = var.org_id
  billing_account                = var.billing_account
  activate_apis                  = var.apis
  folder_id                      = var.folder_id
  random_project_id              = false
  enable_shared_vpc_host_project = true 
  labels = var.labels
}

module "host_network" {
    source  = "terraform-google-modules/network/google"
    version = "~> 3.0"

      project_id                                        = module.host_project.project_id
      network_name                                      = var.networkName
      routing_mode                                      = "GLOBAL"
      auto_create_subnetworks                           = false
      delete_default_internet_gateway_routes            = false 
      subnets                                           = var.networkSubnets

}

resource "google_compute_firewall" "custom" {
  for_each                = var.customRules
  name                    = each.key
  description             = each.value.description
  direction               = each.value.direction
  network                 = module.host_network.network_name
  project                 = module.host_project.project_id
  source_ranges           = each.value.direction == "INGRESS" ? each.value.ranges : null
  destination_ranges      = each.value.direction == "EGRESS" ? each.value.ranges : null
  source_tags             = each.value.use_service_accounts || each.value.direction == "EGRESS" ? null : each.value.sources
  source_service_accounts = each.value.use_service_accounts && each.value.direction == "INGRESS" ? each.value.sources : null
  target_tags             = each.value.use_service_accounts ? null : each.value.targets
  target_service_accounts = each.value.use_service_accounts ? each.value.targets : null
  disabled                = lookup(each.value.extra_attributes, "disabled", false)
  priority                = lookup(each.value.extra_attributes, "priority", 1000)

  dynamic "log_config" {
    for_each = lookup(each.value.extra_attributes, "flow_logs", true) ? [{
      metadata = lookup(each.value.extra_attributes, "flow_logs_metadata", "INCLUDE_ALL_METADATA")
    }] : []
    content {
      metadata = log_config.value.metadata
    }
  }

  dynamic "allow" {
    for_each = [for rule in each.value.rules : rule if each.value.action == "allow"]
    iterator = rule
    content {
      protocol = rule.value.protocol
      ports    = rule.value.ports
    }
  }

  dynamic "deny" {
    for_each = [for rule in each.value.rules : rule if each.value.action == "deny"]
    iterator = rule
    content {
      protocol = rule.value.protocol
      ports    = rule.value.ports
    }
  }
}
