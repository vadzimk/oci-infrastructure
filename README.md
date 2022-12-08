# Terraform configuration for cloud infrastructure

## Overview

This configuration code automatically provisions (recreates) the necessary infrastructure in my cloud using Terraform. It can run on
a local machine or inside the Gitlab CI/CD pipeline.

![Diagram of the current cloud infrastructure](./Diagram.drawio.svg "Diagram of the current limited free tier cloud infrastructure")

## Usage

**Create`terraform.tfvars` file in the root module with the following secrets:**
<details>
  <summary>
    Infrastructure secret variables
  </summary>


The authentication block can be generated from:  
Dashboard --> User --> API keys --> Add API key
--> [Configuration file](https://docs.oracle.com/en-us/iaas/Content/API/Concepts/sdkconfig.htm)

/* --------- authentication --------- */

`user`         
`fingerprint`  
`tenancy`  
`region`  
`key_file`  is the `KEY_FILE` secret variable

/* ----------- compartment ---------- */

`compartment_id` # Dashboard --> Identity --> Compartments --> Compartment details

/* ----------- environment ---------- */

`env_prefix` # prod / dev / test

/* --------------- vcn -------------- */

`vcn_cidr_block`  
`subnet_cidr_block`  
`internet_gateway_enabled` # true / false

/* ------- webserver instance ------- */

`instance_shape` # [instance shapes](https://docs.oracle.com/en-us/iaas/Content/Compute/References/computeshapes.htm)  
`image_operating_system` # [images](https://docs.oracle.com/en-us/iaas/images/)  
`image_operating_system_version`  
`public_key_path` # ssh-keygen -t rsa -m PEM  
`web_server_private_ip` # from the `subnet_cidr_block`  
`myip` # ip address allowed to ssh  
`allow_ssh_from_anywhere` # true / false

</details>

### Running locally

#### Installation

*brew install terraform*

#### The first run must be done locally to initialize Terraform state.

- Locally run the script `backend-init-set.sh` It will initialize backend state in the Gitlab's terraform storage.
- Locally run `terraform plan` to create state files in the backend.
- If the Terraform state was destroyed you can recreate it using this import script `import-existing.sh`  
  The resource ids can be found in the OCI GUI. There is a caveat with network security group ids - they are not found
  in OCI GUI, you can view them using oci-cli command `oci network nsg rules list --nsg-id <nsg-id>`
- You can locally run *terraform apply* to create new cloud resources as it uses the same backend as the Gitlab
  pipeline.

#### Usage

- terraform validate
- terraform init
- terraform plan, terraform plan | grep -E '#'
- terraform apply
- terraform output -json  
  _displays the defined outputs of created resources in machine-readable format_
- after resources are created using terraform place the gitlab-runner configuration file in the gitlab-runner `configuration path` or manually run `gitlab-runner register`

<details>
  <summary>
    gitlab-runner configuration path
  </summary>
  <pre><code>scp -o StrictHostKeyChecking=no -i ${WS_KEY} ./gitlab-runner/config.toml ubuntu@gitlab-runner-ip:~
ssh -o StrictHostKeyChecking=no -i ${WS_KEY} ubuntu@gitlab-runner-ip "sudo mv ~/config.toml /etc/gitlab-runner/; 
sudo gitlab-runner restart;"</code></pre>
</details>

<details>
  <summary>
    releasing terraform state lock in GitLab
  </summary>
  <pre><code>curl -X DELETE --header "PRIVATE-TOKEN: ${my-token}" https://gitlab.com/api/v4/projects/${project-id}/terraform/state/oci-infrastructure/lock
</code></pre>
</details>

<details>
  <summary>
    deleting pre-authenticated requests of object storage bucket when bucket needs to be destroyed
  </summary>
  syntax in OCI CLI
  <pre><code>oci os preauth-request delete --namespace {object_storage_namespace} --bucket-name {bucket_name} --par-id {preauthenticated_request_id}</code></pre>
  example
  <pre><code>oci os preauth-request delete --namespace MyNamespace --bucket-name MyParBucket --par-id YOExDlFsNYBNEwF8Uo4aK8WHiz59enVQm1aID+4cxFobgcaofVbZkg371rxK+6Vb
Are you sure you want to delete this resource? [y/N]: y</code></pre>
  <a href="https://docs.oracle.com/en-us/iaas/Content/Object/Tasks/usingpreauthenticatedrequests.htm">reference docs</a>
</details>


### Running in Gitlab CI pipeline

Changes pushed to this repository's `*.tf` or `*.sh` files trigger the Gitlab CI pipeline with a manual deploy step that
applies the Terraform configuration changes to the cloud.  
***Project—>Settings—>CI/CD—>Variables*** must have a secret `TF_VARS` with the contents of `terraform.tfvars`


To generate Private key:  
`openssl genrsa -out ~/.oci/oci_api_key.pem 2048`  
`chmod go-rwx ~/.oci/oci_api_key.pem`  

To generate Public key:  
`openssl rsa -pubout -in ~/.oci/oci_api_key.pem -out ~/.oci/oci_api_key_public.pem`