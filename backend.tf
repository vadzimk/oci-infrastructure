# gitlab stores the terraform state
# https://docs.gitlab.com/ee/user/infrastructure/iac/terraform_state.html


data "terraform_remote_state" "gitlab" {
  backend = "http"

  config = {
    address = var.remote_state_address
    username = var.gitlab_username
    password = "$CI_JOB_TOKEN"
  }
}

variable "gitlab_username" {}
variable "remote_state_address" {}

provider "gitlab" {
  token = "$CI_JOB_TOKEN"
}