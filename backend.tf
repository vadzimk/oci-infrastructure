# gitlab stores the terraform state
# https://docs.gitlab.com/ee/user/infrastructure/iac/terraform_state.html

terraform {
  backend "http" {
  }
}

variable "gitlab_username" {}
variable "remote_state_address" {}

data "terraform_remote_state" "gitlab" {
  backend = "http"

  config = {
    username = "gitlab-ci-token"
    password = "$CI_JOB_TOKEN"
    address = "$TF_ADDRESS"
    lock_address = "$TF_ADDRESS/lock"
    unlock_address = "$TF_ADDRESS/lock"
    lock_method = "POST"
    unlock_method = "DELETE"
    retry_wait_min = "5"
  }
}
