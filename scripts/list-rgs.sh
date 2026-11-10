#!/bin/bash
# Lists resource groups with their owner tag
set -euo pipefail
echo "Resource Groups:"
az group list --query "[].{Name:name, Owner:tags.owner, Location:location}" -o table