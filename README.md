# Terraform configuration for cloud infrastructure (OCI)

## Overview
This configuration code automatically provisiones the necessary infrastructure in my cloud using Terraform.
It can run on a local machine or be a part of CI/CD pipeline (Jenkins or GitLab)



![Diagram of the current cloud infrastructure](./Diagram.drawio.svg "Diagram of the current limited free tier cloud infrastructure")


## Input Variables
**To create this infrasturcture `terraform.tfvars` file must be present in the root module  with the following secrets:**  


The authentication block can be generated from:  
Dashboard --> User --> API keys --> Add API key --> [Configuration file](https://docs.oracle.com/en-us/iaas/Content/API/Concepts/sdkconfig.htm)

/* --------- authentication --------- */

`user`         
`fingerprint`  
`tenancy`  
`region`  
`key_file`  

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

### Installation
*brew install terraform*

### Usage
*terraform init*  
*terraform plan*  
*terraform apply* 

## Running in Gitlab CI pipeline
**This is a multi-project pipeline**  
It creates the cloud infrastructure AND triggers all downstream pipelines to redeploy all the residing applications.