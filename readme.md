Basic Terraform plan that interacts with an on-prem vSphere cluster to deploy an Ubuntu VM using the base Ubuntu cloud-image OVA file and cloud-init configuration file. To use this, you will need to do the following:
1) Copy or rename terraform.tfvars.example to terraform.tfvars
2) Fill in the information about your environment
3) Go to https://cloud-images.ubuntu.com/ and download the OVA file fo the version you want to use
4) Deploy it as a template and update the "templatename" variable with the name of the deployed template