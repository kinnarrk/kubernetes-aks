# Kubernetes with Azure Kubernetes Service (AKS)

##Implementation of managed Kubernetes cluster in Azure with Terraform
This project implemented and tested on Linux (Ubuntu 18.04 LTS).

### Getting Started with Azure

#### What is Azure?
Azure is a complete cloud platform that can host your existing applications and streamline new application development. Azure can even enhance on-premises applications.
Azure integrates the cloud services that you need to develop, test, deploy, and manage your applications, all while taking advantage of the efficiencies of cloud computing.

#### Where do I start?
Create a free account on Azure Portal
> https://portal.azure.com

### Prerequisite

- Terraform 
    > version >= 0.14.1
  
    Please download the latest package for your operating system and architecture. 
        
    >  https://www.terraform.io/downloads.html
  
- Azure CLI
    
    > azure-cli >= 2.16.0
  
    Install with one command

    >  curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
  
    For manual instructions and more information about installation on other platforms
    
    > https://docs.microsoft.com/en-us/cli/azure/install-azure-cli-apt
  
### Setup Service Principle 
An Azure service principal is an identity created for use with applications, hosted services, and automated tools to access Azure resources. 
This access is restricted by the roles assigned to the service principal, giving you control over which resources can be accessed and at which level.

>   az ad sp create-for-rbac --name <servicePrincipleName>

This command will give you require credentials which you use to access the resources. Make sure to store this information for future use. This command will output as:

    {
        "appId": "asome-random-string-of-appId",
        "displayName": "servicePrincipleName",
        "name": "http://servicePrincipleName",
        "password": "somerandomP-big.1h.password-G",
        "tenant": "this-isa-tenant-id-111111"
    }

We need APP_ID, PASSWORD, and TENANT to create a cluster in AKS

### Create AKS Cluster 

> terraform apply

Parameters passed with this command can be included in the `terraform.tfvars` file. Below is the parameter list:

    appId = "APP_ID"
    password = "PASSWORD"
    cluster-rg-name = "CLUSTER_NAME"
    location = "REGION"
    aks-network-name = "CLUSTER_VNET_NAME"
    aks-subnet-name = "CLUSTER_SUBNET_NAME"
    server-name = "MYSQL_SERVER_NAME"
    administrator_login = "MYSQL_ADMIN_LOGIN"
    administrator_login_password ="MYSQL_ADMIN_PASSWORD"
    sku_name = "MYSQL_SKU"
    public_network_access_enabled = ISACCESSIBLE_TO_OTHER_SERVICES
    webapp-db-name = "DB_FOR_WEBAPP"
    poller-db-name = "DB_FOR_POLLER"
    notifier-db-name = "DB_FOR_NOTIFIER"
    aks-cluster-name = "CLUSTER_NAME"
    node-rg-name = "NODE_RESOURCE_GROUP_NAME"
    dns_prefix = "DNS_FOR_CLUSTER"
    private_cluster_enabled = ISCLUSTER_PRIVATE
    min_count = MIN_NODE_COUNT
    max_count = MAX_NODE_COUNT
    node_count = NODE_COUNT
    public_key = "PUBLIC_KEY"

### Delete AKS Cluster
> terraform destroy

Running this command will delete an entire AKS cluster

### References

> https://docs.microsoft.com/en-us/azure/guides/developer/azure-developer-guide

> https://docs.microsoft.com/en-us/azure/?product=featured

> https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs

> https://learn.hashicorp.com/tutorials/terraform/aks

> https://learn.hashicorp.com/tutorials/terraform/azure-build?in=terraform/azure-get-started

> https://docs.microsoft.com/en-us/azure/aks/concepts-clusters-workloads

## Author

### Rajashree Joshi (NUID: 001356039)



