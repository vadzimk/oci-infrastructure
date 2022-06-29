# gitlab stores the terraform state
# https://docs.gitlab.com/ee/user/infrastructure/iac/terraform_state.html



variable "gitlab_username" {}
variable "remote_state_address" {}

data "terraform_remote_state" "gitlab" {
  backend = "http"

  config = {
    username = var.gitlab_username
    password = "$CI_JOB_TOKEN"
    address = var.remote_state_address
    lock_address = "${var.remote_state_address}/lock"
    unlock_address = "${var.remote_state_address}/lock"
    lock_method = "POST"
    unlock_method = "DELETE"
  }
}
