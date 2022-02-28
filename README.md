# Google Cloud Platform Foundations Framework

## Description

This repository contains a Terraform code base responsible for creating and managing a secure landing zone (SLZ) tenant, with customization options. The code base is represented by the diagram below.

`tfvars`: This object defines a group of one or more deployable variables which will span accross one or more environments. This object's data defines the EnvironmentSet it should be associated with, as well as networking requirements for these applications.

## Diagram
![Diagram](./images/diagram.jpeg)

## How To

---

### Code Deployment
1. Check-out this repository onto your local workstation
1. Make sure your head is on the main branch of this repo
1. Create a new branch with a unique name or identifier
1. cd into the root directory
1. Add additional code changes you wish to add, modify, or remove
1. Commit your changes to your created branch, making sure the commit message includes a commit message
1. Create a pull request of your branch into the main branch
1. The pull request will start a speculative plan to see if the changes you made will run correctly in terraform. If the plan passes, the cloudeng team will merge the changes into the main branch, and the project creation process will start.

---

# Environment Set Definition

## Example (gcp-org-structure)
```
# --------------------------------------------------------------------------------------------------
# folder definitions
# --------------------------------------------------------------------------------------------------

rootFolders = ["IT", "Financial", "Marketing", "Common"]
subFolders =  {
  IT              =  ["App Development", "Infrastructure", "DevOps"]
  appDev          = ["Web Systems", "Example Team"]
  infra           = ["Networking"]
  network         = ["Dev Network", "Test Network", "Prod Network"]
  devOps          = ["Monitoring"]
        
}

# --------------------------------------------------------------------------------------------------
# project definitions
# --------------------------------------------------------------------------------------------------

projectName  = {
    dev           = "dev-host"
    test          = "test-host"
    prod          = "prod-host"
}
labels = {
    owner         = "core-services"
}

# --------------------------------------------------------------------------------------------------
# network definitions
# --------------------------------------------------------------------------------------------------
networkName  = {
    dev           = "dev-host-vpc"
    test          = "test-host-vpc"
    prod          = "prod-host-vpc"
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





```

## Attribute Reference (gcp-org-structure)

* `rootFolders` (Required) (map(string)): Folders at the root level. This definition allows for the creation of root-level folders within the project.

* `subFolders` (Required) (map(list(string))): Folders at the sub-folder level. This definition allows for the creation of sub-folders within any root folder or sub-folder, allowing for nested file systems. Further customization may be done within the "Subfolder Structure" section of gcp-org-structure/main.tf.

* `projectName` (map(string)): Specifies names for host projects, including networking hosts.

* 'labels' (map(string)): Allows optional labels to be applied to host projects.

* `networkName` (Required) (map(object)): Specifies names for created VPCs.

* `networkSubnets` (Required) (list(map)(string)): The type of object being defined. For all environment sets this should have a value of `networkSubnets`. This definition allows for the creation of network subnets within the project.

* `customRules` (Required) (map(object)): The type of object being defined for all environment sets this should have a value of `customRules` this definition allows for the creation of custom firewall rules within the project.

## Example (gcp-service-project-factory)
```
# --------------------------------------------------------------------------------------------------
# Deployment variables
# --------------------------------------------------------------------------------------------------
deployConfig = {
  appName                  = "sample-app1"
  subnetwork               = "app"
  network                  = "dev-host-vpc"
  host_project_dev         = "dev-host-ff24"
  host_project_test        = "test-host-671a"
  host_project_prod        = "prod-host-de28"
  region                   = "us-east4"
  zone                     = "us-east4-a"
}

labels = {
  service_label            = "sample-app1"
  application_service      = "web"
  environment              = "dev"
  owner                    = "dev-team1" 
}





```

## Attribute Reference (gcp-service-project-factory)

* `deployConfig` (Required) (map(string)): Required parameters which are passed to the service project factory during creation.

* `labels` (map(string)): Allows optional labels to be applied to service projects.


## Pipeline Specifics

* Do not check in any secrets

## To run:  
1. terraform init   
2. terraform plan
3. terraform apply

## Requirements

### Permissions

In order to execute these modules, you must use GCP Application Default Credentials. To authenticate, run:

- gcloud auth login
- gcloud auth application-default login

### Software

-   [gcloud sdk](https://cloud.google.com/sdk/install) >= 269.0.0
-   [Terraform](https://www.terraform.io/downloads.html) >= 0.13.0
-   [terraform-provider-google] plugin >= 3.1, < 4.0
-   [terraform-provider-google-beta] plugin >= 3.1, < 4.0

## Contribute

The cloud engineering team will gladly accept code features and fixes to this repo as well as the baseline modules the workspaces created by this module use.

