module "org_policy" {
  source  = "terraform-google-modules/org-policy/google"
  version = "5.0.0"

  constraint      = var.constraint
  policy_type     = var.policy_type
  organization_id = var.organization_id
  enforce         = var.enforce
  policy_for      = "organization"
}
