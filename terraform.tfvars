# --------------------------------------------------------------------------------------------------
# folder definitions
# --------------------------------------------------------------------------------------------------

org_folders           = ["prod-folder", "nonprod-folder", "shared-service-folder"]
subFolders =  {
  org_folders_nested  = ["gcp-core-services", "operations", "applications"]
  apps                = ["app1"]

}
# --------------------------------------------------------------------------------------------------
# project definitions
# --------------------------------------------------------------------------------------------------
projectName  = {
    prod_host              = "sample-prod-host"
    nonprod_host           = "sample-np-host"
    shared_services_host   = "sample-shared-service-host"


    prod_ops_svc           = "prod-ops"
    nonprod_ops_svc        = "non-prod-ops"
    shared_service_ops_svc = "sample-operations-non-prod"


    prod_app_svc           = "prod-app"
    nonprod_app_svc        = "nonprod-app"
    shared_service_app_svc = "shared-service-app"


}
labels = {
    owner         = "core-services"
}

billing_account = "01A26E-F5A54C-83E700"
org_id          = "organizations/305658411957" 

# --------------------------------------------------------------------------------------------------
# network definitions
# --------------------------------------------------------------------------------------------------
networkName  = {
    prod_vpc              = "prod-vpc"
    nonprod_vpc           = "np-vpc"
    share_services_vpc    = "shared-service-vpc"
}

networkSubnets = [
        {
            subnet_name           = "app"
            subnet_ip             = "100.65.0.0/20"
            subnet_region         = "us-east4"
            subnet_private_access = "true"
            subnet_flow_logs      = "true"
            description           = "Management subnet"
            subnet_flow_logs_interval = "INTERVAL_10_MIN"
            subnet_flow_logs_sampling = 0.7
            subnet_flow_logs_metadata = "INCLUDE_ALL_METADATA"
        }
    ]


# --------------------------------------------------------------------------------------------------
# firewall rule definitions
# --------------------------------------------------------------------------------------------------

customRules = {
   app1 = {
        description                                               = "firewall sample rule for migration"
        direction                                                 = "INGRESS"
        action                                                    = "allow"
        ranges                                                    = ["10.0.0.0/8"]
        sources                                                   = []
        targets                                                   = []
        use_service_accounts                                      = false
        rules = [
        {
            protocol = "all"
            ports    = []
        },
        ]
        extra_attributes = {}
    },
    }