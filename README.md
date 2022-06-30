# Terraform configuration for cloud infrastructure (OCI)

## Overview
This configuration code automatically provisiones the necessary infrastructure in my cloud using Terraform.
It can run on a local machine or inside the Gitlab CI/CD pipeline.


![Diagram of the current cloud infrastructure](./Diagram.drawio.svg "Diagram of the current limited free tier cloud infrastructure")


## Infrastructure secret variables
**Create`terraform.tfvars` file in the root module with the following secrets:**  


The authentication block can be generated from:  
Dashboard --> User --> API keys --> Add API key --> [Configuration file](https://docs.oracle.com/en-us/iaas/Content/API/Concepts/sdkconfig.htm)

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


## Running locally
The first run must be done locally to initialize Terraform state.

### Installation
*brew install terraform*

### Usage
- Locally run the script `backend-init-set.sh` It will initialize backend state in the Gitlab's terraform storage.
- Locally run `terraform plan` to create state files in the backend.
- If the Terraform state was destroyed you can recreate it using this import script `import-existing.sh`  
The resource ids can be found in the OCI GUI.
There is a caveat with network security group ids - they are not found in OCI GUI, you can view them using oci-cli command `oci network nsg rules list --nsg-id <nsg-id>`
- You can locally run *terraform apply* to create new cloud resources as it uses the same backend as the Gitlab pipeline.

## Running in Gitlab CI pipeline
Changes pushed to this repository trigger pipeline with a manual deploy step that applies the Terraform configuration changes.  
***Project—>Settings—>CI/CD—>Variables*** must have a secret `TF_VARS` with the contents of `terraform.tfvars`