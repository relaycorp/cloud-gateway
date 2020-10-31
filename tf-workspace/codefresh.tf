resource "codefresh_project" "gateway" {
  name = "cloud-gateway"

  tags = ["cloud"]

  variables {
    foo = "bar"
  }
}
