#!/bin/bash
set -euo pipefail
RG=rg-tfstate; LOC=eastus; SA=sttfstate$RANDOM
az group create -n $RG -l $LOC --tags owner=gabriel env=lab
az storage account create -n $SA -g $RG -l $LOC --sku Standard_LRS \
--min-tls-version TLS1_2 --allow-blob-public-access false --tags owner=gabriel env=lab
az storage account blob-service-properties update -n $SA -g $RG --enable-versioning true
az storage container create -n tfstate --account-name $SA
echo "Storage account: $SA" # write this down