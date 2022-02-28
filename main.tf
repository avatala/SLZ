
/* -------------------------------------------------------------------------- */
/*                              Folder Structure                              */
/* -------------------------------------------------------------------------- */

module "org_folders" {
  source = "./modules/gcp-folder"
  parent = var.org_id
  names = var.org_folders
}

/* -------------------------------------------------------------------------- */
/*                             Subfolder Structure                            */
/* -------------------------------------------------------------------------- */

module "prod_folder" {
  source = "./modules/gcp-folder"
  parent = module.org_folders.folders_map["prod-folder"].id
  names = var.subFolders["org_folders_nested"]
}

module "nonprod_folder" {
  source = "./modules/gcp-folder"
  parent = module.org_folders.folders_map["nonprod-folder"].id
  names = var.subFolders["org_folders_nested"]
}

module "shared_service_folder" {
  source = "./modules/gcp-folder"
  parent = module.org_folders.folders_map["shared-service-folder"].id
  names = var.subFolders["org_folders_nested"]
}


/* -------------------------------------------------------------------------- */
/*                             AppFolder Structure                            */
/* -------------------------------------------------------------------------- */
    module "prod_app_folder" {
      source = "./modules/gcp-folder"
      parent = module.prod_folder.folders_map["applications"].id
      names = var.subFolders["apps"]
    }

    module "nonprod_app_folder" {
      source = "./modules/gcp-folder"
      parent = module.nonprod_folder.folders_map["applications"].id
      names = var.subFolders["apps"]
    }

    module "shared_service_app_folder" {
      source = "./modules/gcp-folder"
      parent = module.shared_service_folder.folders_map["applications"].id
      names = var.subFolders["apps"]
    }


/* -------------------------------------------------------------------------- */
/*                         Host Projects                            */
/* -------------------------------------------------------------------------- */

module "prod_host_project" {
  source             = "./modules/host-project-factory"
  projectName        = var.projectName["prod_host"]
  networkName        = var.networkName["prod_vpc"]
  labels             = var.labels
  networkSubnets     = var.networkSubnets
  customRules        = var.customRules
  folder_id          = module.prod_folder.folders_map["gcp-core-services"].id
  billing_account    = var.billing_account
}

module "nonprod_host_project" {
  source             = "./modules/host-project-factory"
  projectName        = var.projectName["nonprod_host"]
  networkName        = var.networkName["nonprod_vpc"]
  labels             = var.labels
  networkSubnets     = var.networkSubnets
  customRules        = var.customRules
  folder_id          = module.nonprod_folder.folders_map["gcp-core-services"].id
  billing_account    = var.billing_account
}

module "shared_service_host_project" {
  source             = "./modules/host-project-factory"
  projectName        = var.projectName["shared_services_host"]
  networkName        = var.networkName["share_services_vpc"]
  labels             = var.labels
  networkSubnets     = var.networkSubnets
  customRules        = var.customRules
  folder_id          = module.shared_service_folder.folders_map["gcp-core-services"].id
  billing_account    = var.billing_account
}


/* -------------------------------------------------------------------------- */
/*                              Prod Service Projects                                */
/* -------------------------------------------------------------------------- */

module "prod_operations_project" {
  source                  = "terraform-google-modules/project-factory/google"
  version                 = "10.3.2"
  name                    = var.projectName["prod_ops_svc"]
  random_project_id       = true
  org_id                  = local.orgID
  billing_account         = local.billingAccount
  activate_apis           = ["logging.googleapis.com", "bigquery.googleapis.com", "billingbudgets.googleapis.com"]
  folder_id               = module.prod_folder.folders_map["operations"].id
  labels = var.labels

  # Networking
  svpc_host_project_id = module.prod_host_project.project.id
}

module "prod_app_project" {
  source                  = "terraform-google-modules/project-factory/google"
  version                 = "10.3.2"
  name                    = var.projectName["prod_app_svc"]
  random_project_id       = true
  org_id                  = local.orgID
  billing_account         = local.billingAccount
  activate_apis           = ["logging.googleapis.com", "bigquery.googleapis.com", "billingbudgets.googleapis.com"]
  folder_id               = module.prod_folder.folders_map["applications"].id
  labels = var.labels

  # Networking
  svpc_host_project_id = module.prod_host_project.project.id
}




/* -------------------------------------------------------------------------- */
/*                              NonProd Service Projects                                */
/* -------------------------------------------------------------------------- */

module "nonprod_operations_project" {
  source                  = "terraform-google-modules/project-factory/google"
  version                 = "10.3.2"
  name                    = var.projectName["nonprod_ops_svc"]
  random_project_id       = true
  org_id                  = local.orgID
  billing_account         = local.billingAccount
  activate_apis           = ["logging.googleapis.com", "bigquery.googleapis.com", "billingbudgets.googleapis.com"]
  folder_id               = module.nonprod_folder.folders_map["operations"].id
  labels = var.labels

  # Networking
  svpc_host_project_id = module.prod_host_project.project.id
}

module "nonprod_app_project" {
  source                  = "terraform-google-modules/project-factory/google"
  version                 = "10.3.2"
  name                    = var.projectName["nonprod_app_svc"]
  random_project_id       = true
  org_id                  = local.orgID
  billing_account         = local.billingAccount
  activate_apis           = ["logging.googleapis.com", "bigquery.googleapis.com", "billingbudgets.googleapis.com"]
  folder_id               = module.nonprod_folder.folders_map["applications"].id
  labels = var.labels

  # Networking
  svpc_host_project_id = module.nonprod_host_project.project.id
}



/* -------------------------------------------------------------------------- */
/*                              SharedServices Service Projects                                */
/* -------------------------------------------------------------------------- */

module "shared_service_operations_project" {
  source                  = "terraform-google-modules/project-factory/google"
  version                 = "10.3.2"
  name                    = var.projectName["shared_service_ops_svc"]
  random_project_id       = true
  org_id                  = local.orgID
  billing_account         = local.billingAccount
  activate_apis           = ["logging.googleapis.com", "bigquery.googleapis.com", "billingbudgets.googleapis.com"]
  folder_id               = module.shared_service_folder.folders_map["operations"].id
  labels = var.labels

  # Networking
  svpc_host_project_id = module.shared_service_host_project.project.id
}

module "shared_service_app_project" {
  source                  = "terraform-google-modules/project-factory/google"
  version                 = "10.3.2"
  name                    = var.projectName["shared_service_app_svc"]
  random_project_id       = true
  org_id                  = local.orgID
  billing_account         = local.billingAccount
  activate_apis           = ["logging.googleapis.com", "bigquery.googleapis.com", "billingbudgets.googleapis.com"]
  folder_id               = module.shared_service_folder.folders_map["applications"].id
  labels = var.labels

  # Networking
  svpc_host_project_id = module.shared_service_host_project.project.id
}


