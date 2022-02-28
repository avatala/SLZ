variable "projectName" {
  type = string
}

variable "org_id" {
  type = list(string)
}

variable "networkName" {
  type = string
}

variable "folder_id" {
  type = string
}


variable "networkSubnets" {
  type        = list(map(string))
  description = "The list of subnets being created"
}

variable "labels" {
  type = map
}

variable "billing_account" {
  type = string 
}

variable "apis" {
type = list(string)
  description = "List of apis to enable inside of the project during creation"
default = [
    "compute.googleapis.com",
    "dns.googleapis.com",
    "oslogin.googleapis.com",
    "privateca.googleapis.com",
    "servicenetworking.googleapis.com",
    "container.googleapis.com",
  ]
  }

variable "customRules" {
  description = "List of custom rule definitions (refer to variables file for syntax)."
  default     = {}
  type = map(object({
    description          = string
    direction            = string
    action               = string # (allow|deny)
    ranges               = list(string)
    sources              = list(string)
    targets              = list(string)
    use_service_accounts = bool
    rules = list(object({
      protocol = string
      ports    = list(string)
    }))
    extra_attributes = map(string)
  }))
}
