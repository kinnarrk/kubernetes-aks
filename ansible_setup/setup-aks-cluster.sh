#!/bin/bash

export PROJECT_DIR=/home/rajashree/Desktop/Advanced_Cloud/kubernetes-aks/
export DNS_ZONE=aks.rajashreejoshi.me
export SUB_DOMAIN_NAME=webapp
export EMAIL=joshi.raj@northeastern.edu
export RESOURCE_GROUP=cluster-rg
ANSIBLE_STDOUT_CALLBACK=debug ansible-playbook setup-aks-cluster.yml --extra-vars "project_dir=${PROJECT_DIR} dns_zone=${DNS_ZONE} sub_domain_name=${SUB_DOMAIN_NAME} email=${EMAIL} resource_group=${RESOURCE_GROUP}"
