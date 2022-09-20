
# Namespace
export TF_VAR_namespace=`oci os ns get | jq -r .data`
export TF_VAR_tenancy_ocid=`oci iam compartment list --all --compartment-id-in-subtree true --access-level ACCESSIBLE --include-root --raw-output --query "data[?contains(\"id\",'tenancy')].id | [0]"`
export TF_VAR_ssh_public_key=$(cat id_devops_rsa.pub)
export TF_VAR_ssh_private_key=$(cat id_devops_rsa)

echo TF_VAR_tenancy_ocid=$TF_VAR_tenancy_ocid
echo TF_VAR_compartment_ocid=$TF_VAR_compartment_ocid
echo TF_VAR_namespace=$TF_VAR_namespace

# parameter
echo TF_VAR_region=$TF_VAR_region

# Vault
export DOCKER_USER=ssh_private_key=$(TF_VAR_namespace)/$(OCI_USER)
echo DOCKER_USER=$DOCKER_USER

# Docker registry Path
export TF_VAR_registry_path=${TF_VAR_ocir_docker_repository}/$TF_VAR_namespace
export TF_VAR_function_image=$TF_VAR_registry_path/tikaparser:latest