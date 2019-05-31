#!/usr/bin/env bash

# Read in config.json
configFile='config.json'
BINDERHUB_NAME=`jq -r '.binderhub .name' ${configFile}`
RESOURCE_GROUP=`jq -r '.azure .res_grp_name' ${configFile}`
AKS_NAME=`echo ${BINDERHUB_NAME} | tr -cd '[:alnum:]-' | cut -c 1-59`-AKS

# Purge the Helm release and delete the Kubernetes namespace
echo "--> Purging the helm chart"
helm delete ${BINDERHUB_NAME} --purge

echo "--> Deleting the namespace: ${BINDERHUB_NAME}}"
kubectl delete namespace ${BINDERHUB_NAME}

echo "--> Purging the kubectl config file"
python3 edit_kube_config.py -n ${AKS_NAME} --purge

# Delete Azure Resource Group
echo "--> Deleting the resource group: ${RESOURCE_GROUP}"
az group delete -n ${RESOURCE_GROUP}

echo "--> Deleting the resource group: NetworkWatcherRG"
az group delete -n NetworkWatcherRG

echo "Double check resources are down:"
echo "               https://portal.azure.com/#home -> Click on Resource Groups"
echo "Check your DockerHub registry:"
echo "               https://hub.docker.com/"
echo "For more info: https://zero-to-jupyterhub.readthedocs.io/en/latest/turn-off.html#delete-the-helm-release"
echo "               https://zero-to-jupyterhub.readthedocs.io/en/latest/turn-off.html#microsoft-azure-aks"
