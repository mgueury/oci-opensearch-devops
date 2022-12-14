# Yum
yum install jq -y

# Namespace
export TF_VAR_namespace=`oci os ns get | jq -r .data`
export TF_VAR_ssh_public_key=$(cat id_devops_rsa.pub)
export TF_VAR_ssh_private_key=$(cat id_devops_rsa)

# Echo
echo TF_VAR_tenancy_ocid=$TF_VAR_tenancy_ocid
echo TF_VAR_compartment_ocid=$TF_VAR_compartment_ocid
echo TF_VAR_namespace=$TF_VAR_namespace
echo TF_VAR_function_image_uri=$TF_VAR_function_image_uri
echo TF_VAR_region=$TF_VAR_region

