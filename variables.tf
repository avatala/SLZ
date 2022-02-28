
variable "org_folders" {
  type = list(string)
}

variable "org_id" {
  type = list(string)
}

variable "subFolders" {
  type = map(list(string))
}

variable "projectName" {
  type = map
}

variable "networkName" {
  type = map
}

variable "labels" {
  type = map
}

variable "billing_account" {
  type = string
}

variable "networkSubnets" {
  type        = list(map(string))
  description = "The list of subnets being created"
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