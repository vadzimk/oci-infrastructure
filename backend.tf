# Gitlab managed terraform state
# https://docs.gitlab.com/ee/user/infrastructure/iac/terraform_state.html

terraform {
  backend "http" {
    #    the backend configuration is applied manually using the backend-init-set.sh
  }
}
