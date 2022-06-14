# Terraform configuration code for my cloud infrastructure (OCI)

## Intro
This configuration code automatically provisiones the necessary infrastructure in my cloud using Terraform.
It can run on a local machine or be a part of CI/CD pipeline (Jenkins or Github Actions)


![Philadelphia's Magic Gardens. This place was so cool!](./Diagram.drawio.svg "Diagram of the current limited free tier infrastructure")


## Input Variables
**To create this infrasturcture `terraform.tfvars` file must be present in the root module  with the following secrets:**  


<!-- blank line --> 
Authentication block can be generated from:  
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

## Installation

*brew install terraform*

## Usage
*terraform init*  
*terraform plan*  
*terraform apply*  