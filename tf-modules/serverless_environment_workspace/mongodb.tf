resource "mongodbatlas_project" "main" {
  name   = "gateway-${var.name}"
  org_id = var.mongodb_atlas_org_id
}

resource "mongodbatlas_project_api_key" "main" {
  project_id  = mongodbatlas_project.main.id
  description = "Used in Terraform Cloud workspace ${tfe_workspace.main.name}"

  project_assignment {
    project_id = mongodbatlas_project.main.id
    role_names = ["GROUP_OWNER"]
  }
}
