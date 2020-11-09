
resource "azurerm_mysql_server" "mysql" {
  name                = "mysql-${var.server_name}-${var.environment}"
  location            = var.location
  resource_group_name = var.resource_group

  administrator_login          = var.mysql_admin_username
  administrator_login_password = var.mysql_admin_password

  sku_name   = "GP_Gen5_2"
  storage_mb = 5120
  version    = "5.7"

  charset   = "latin1"
  collation = "latin1_swedish_ci"


  auto_grow_enabled                 = true
  backup_retention_days             = 7
  geo_redundant_backup_enabled      = true
  infrastructure_encryption_enabled = true
  public_network_access_enabled     = true
  ssl_enforcement_enabled           = true
  ssl_minimal_tls_version_enforced  = "TLS1_2"

  tags = var.tags
}

resource "azurerm_mysql_database" "database" {
  name                = var.database_name
  resource_group_name = var.resource_group
  server_name         = azurerm_mysql_server.mysql.name
  charset             = "utf8"
  collation           = "utf8_unicode_ci"
}
