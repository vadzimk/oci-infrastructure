# gitlab stores the terraform state
# https://docs.gitlab.com/ee/user/infrastructure/iac/terraform_state.html



variable "gitlab_username" {}
variable "remote_state_address" {}

data "terraform_remote_state" "gitlab" {
  backend = "http"

  config = {
    address = var.remote_state_address
    lock_address = "${var.remote_state_address}/lock"
    username = var.gitlab_username
    password = "$CI_JOB_TOKEN"

  }
}
