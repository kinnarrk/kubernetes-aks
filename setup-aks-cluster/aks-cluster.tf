resource "azurerm_resource_group" "cluster-rg" {
  name     = var.cluster-rg-name
  location = var.location
}

resource "azurerm_virtual_network" "aks-network" {
  name          = var.aks-network-name
  address_space = ["10.1.0.0/16"]
  location      = azurerm_resource_group.cluster-rg.location
  resource_group_name = azurerm_resource_group.cluster-rg.name
}

resource "azurerm_subnet" "aks-subnet" {
  name                 = var.aks-subnet-name
  resource_group_name  = azurerm_resource_group.cluster-rg.name
  virtual_network_name = azurerm_virtual_network.aks-network.name
  address_prefixes     = ["10.1.1.0/24"]
  service_endpoints    = ["Microsoft.Sql"]
}

resource "azurerm_mysql_server" "mysql-db" {
  name                         = var.server-name
  resource_group_name          = azurerm_resource_group.cluster-rg.name
  location                     = azurerm_resource_group.cluster-rg.location
  version                      = "5.7"
  administrator_login          = var.administrator_login
  administrator_login_password = var.administrator_login_password

  tags = {
    environment = "production"
    Name = "mysql-server"
  }
  sku_name = var.sku_name
  storage_mb = 5120
  public_network_access_enabled     = var.public_network_access_enabled
  ssl_enforcement_enabled           = false
}

resource "azurerm_mysql_database" "webapp-db" {
  name                = var.webapp-db-name
  resource_group_name = azurerm_resource_group.cluster-rg.name
  server_name         = azurerm_mysql_server.mysql-db.name
  charset   = "utf8"
  collation = "utf8_unicode_ci"
}

resource "azurerm_mysql_database" "poller-db" {
  name                = var.poller-db-name
  resource_group_name = azurerm_resource_group.cluster-rg.name
  server_name         = azurerm_mysql_server.mysql-db.name
  charset   = "utf8"
  collation = "utf8_unicode_ci"
}

resource "azurerm_mysql_database" "notifier-db" {
  name                = var.notifier-db-name
  resource_group_name = azurerm_resource_group.cluster-rg.name
  server_name         = azurerm_mysql_server.mysql-db.name
  charset   = "utf8"
  collation = "utf8_unicode_ci"
}

resource "azurerm_kubernetes_cluster" "aks-cluster" {
  name                = var.aks-cluster-name
  location            = azurerm_resource_group.cluster-rg.location
  resource_group_name = azurerm_resource_group.cluster-rg.name
  node_resource_group = var.node-rg-name
  dns_prefix          = var.dns_prefix
  private_cluster_enabled = var.private_cluster_enabled

  default_node_pool {
    name            = "default"
    min_count = var.min_count
    max_count = var.max_count
    enable_auto_scaling = true
    node_count      = var.node_count
    vm_size         = "Standard_D2_v2"
    os_disk_size_gb = 30
    vnet_subnet_id = azurerm_subnet.aks-subnet.id
    availability_zones = ["1","2","3"]
  }

  service_principal {
    client_id     = var.appId
    client_secret = var.password
  }

  role_based_access_control {
    enabled = true
  }

  network_profile {
    network_plugin = "azure"
    network_policy= "calico"
    load_balancer_sku = "standard"
  }

  linux_profile {
    admin_username = "ubuntu"
    ssh_key {
      key_data = var.public_key
    }
  }

  addon_profile {
    kube_dashboard {
      enabled = true
    }
  }

  tags = {
    environment = "PROD",
    Name = "aks-cluster"
  }
}

resource "azurerm_mysql_virtual_network_rule" "msql-vnet-rule" {
  name                = "mysql-vnet-rule"
  resource_group_name = azurerm_resource_group.cluster-rg.name
  server_name         = azurerm_mysql_server.mysql-db.name
  subnet_id           = azurerm_subnet.aks-subnet.id
  depends_on = [

  ]
}

output "resource_group_name" {
  value = azurerm_resource_group.cluster-rg.name
}

output "kubernetes_cluster_name" {
  value = azurerm_kubernetes_cluster.aks-cluster.name
}
