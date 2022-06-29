# gitlab stores the terraform state
# https://docs.gitlab.com/ee/user/infrastructure/iac/terraform_state.html

terraform {
  backend "http" {
#    username = "gitlab-ci-token"
#    password = var.gitlab_token
#    address = var.remote_state_address
#    lock_address = "${var.remote_state_address}/lock"
#    unlock_address = "${var.remote_state_address}/lock"
#    lock_method = "POST"
#    unlock_method = "DELETE"
#    retry_wait_min = "5"
  }
}


#variable "gitlab_token" {}
#variable "remote_state_address" {}

#data "terraform_remote_state" "gitlab" {
#  backend = "http"
## terraform block does not allow variable values, only constants
#  config = {
#    username = "gitlab-ci-token"
#    password = var.gitlab_token
#    address = var.remote_state_address
#    lock_address = "${var.remote_state_address}/lock"
#    unlock_address = "${var.remote_state_address}/lock"
#    lock_method = "POST"
#    unlock_method = "DELETE"
#    retry_wait_min = "5"
#  }
#}
