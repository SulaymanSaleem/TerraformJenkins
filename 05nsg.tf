resource "azurerm_network_security_group" "main" {
  name = "${var.prefix}hostNSG"
  location = "${azurerm_resource_group.main.location}"
  resource_group_name = "${azurerm_resource_group.main.name}"

  security_rule {
    name ="SSH"
    priority = 400
    direction = "Inbound"
    access = "Allow"
    protocol = "*"
    source_port_range = "*"
    destination_port_range ="22"
    source_address_prefix = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name ="HTTP"
    priority = 500
    direction = "Inbound"
    access = "Allow"
    protocol = "*"
    source_port_range = "*"
    destination_port_range ="8080"
    source_address_prefix = "*"
    destination_address_prefix = "*"
  }
}
resource "azurerm_network_security_group" "second" {
  name = "${var.prefix}slaveNSG"
  location = "${azurerm_resource_group.main.location}"
  resource_group_name = "${azurerm_resource_group.main.name}"

  security_rule {
    name ="SSH"
    priority = 400
    direction = "Inbound"
    access = "Allow"
    protocol = "*"
    source_port_range = "*"
    destination_port_range ="22"
    source_address_prefix = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_security_group" "third" {
  name = "pythonNSG"
  location = "${azurerm_resource_group.main.location}"
  resource_group_name = "${azurerm_resource_group.main.name}"

  security_rule {
    name ="SSH"
    priority = 400
    direction = "Inbound"
    access = "Allow"
    protocol = "*"
    source_port_range = "*"
    destination_port_range ="22"
    source_address_prefix = "*"
    destination_address_prefix = "*"
  }
}
