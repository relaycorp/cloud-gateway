terraform {
  backend "remote" {
    organization = "Relaycorp"

    workspaces {
      name = "gateway-belgium"
    }
  }
}
