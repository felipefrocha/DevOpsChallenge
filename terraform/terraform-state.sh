set -euv
ENVIRONMENT=dev
RESOURCE_GROUP_NAME=rg-nibodevops-tfstate
RG_PORTAL_NIBO=rg-nibodevops-
STORAGE_ACCOUNT_NAME=stnibodevopsterraform
CONTAINER_NAME=ctn-nibodevops-terraform-state
echo '#### Create resource group for terraform #### \n'
az group create --name $RESOURCE_GROUP_NAME --location eastus
echo '\n'
echo '#### Create storage account ####\n'
az storage account create \
    --resource-group $RESOURCE_GROUP_NAME \
    --name $STORAGE_ACCOUNT_NAME \
    --sku Standard_LRS \
    --encryption-services blob
echo '\n'
echo '#### Get storage account key ####'
ACCOUNT_KEY=$(az storage account keys list --resource-group $RESOURCE_GROUP_NAME --account-name $STORAGE_ACCOUNT_NAME --query "[0].value" -o tsv)
echo '\n'
echo '#### Create blob container ####'
az storage container create \
    --name $CONTAINER_NAME \
    --account-name $STORAGE_ACCOUNT_NAME \
    --account-key $ACCOUNT_KEY
echo '\n'
echo "storage_account_name: $STORAGE_ACCOUNT_NAME"
echo "container_name: $CONTAINER_NAME"
echo "access_key: $ACCOUNT_KEY"

cat << EOF > ../${ENVIRONMENT}.backend.tfvars
resource_group_name   = "$RESOURCE_GROUP_NAME"
storage_account_name  = "$STORAGE_ACCOUNT_NAME"
container_name        = "$CONTAINER_NAME"
key                   = "$ENVIRONMENT.terraform.tfstate"
EOF

export ARM_ACCESS_KEY=$ACCOUNT_KEY