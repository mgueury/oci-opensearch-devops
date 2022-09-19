# From the devops parameters
# - TF_VAR_tenancy_ocid
# - TF_VAR_compartment_ocid
# - TF_VAR_region

export TF_VAR_ssh_public_key=$(cat id_devops_rsa.pub)
export TF_VAR_ssh_private_key=$(cat id_devops_rsa)

echo TF_VAR_tenancy_ocid=$TF_VAR_tenancy_ocid
echo TF_VAR_compartment_ocid=$TF_VAR_compartment_ocid
echo TF_VAR_region=$TF_VAR_region
