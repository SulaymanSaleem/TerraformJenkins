resource "azurerm_network_interface" "main" {
  name                = "${var.prefix}-Nica"
  location            = "${azurerm_resource_group.main.location}"
  resource_group_name = "${azurerm_resource_group.main.name}"
  network_security_group_id = "${azurerm_network_security_group.main.id}"
  ip_configuration {
    name                          = "testconfiguration1"
    subnet_id                     = "${azurerm_subnet.internal.id}"
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = "${azurerm_public_ip.main.id}"
  }
  depends_on = [azurerm_network_security_group.main, azurerm_subnet.internal, azurerm_public_ip.main]
}

resource "azurerm_network_interface" "second" {
  name                = "${var.prefix}-NICb"
  location            = "${azurerm_resource_group.main.location}"
  resource_group_name = "${azurerm_resource_group.main.name}"
  network_security_group_id = "${azurerm_network_security_group.second.id}"
  ip_configuration {
    name                          = "testconfiguration2"
    subnet_id                     = "${azurerm_subnet.internal.id}"
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = "${azurerm_public_ip.second.id}"
  }
  depends_on = [azurerm_network_security_group.main, azurerm_subnet.internal, azurerm_public_ip.second, azurerm_network_security_group.second]
}

resource "azurerm_network_interface" "third" {
  name                = "${var.prefix}-NICc"
  location            = "${azurerm_resource_group.main.location}"
  resource_group_name = "${azurerm_resource_group.main.name}"
  network_security_group_id = "${azurerm_network_security_group.third.id}"
  ip_configuration {
    name                          = "testconfiguration3"
    subnet_id                     = "${azurerm_subnet.internal.id}"
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = "${azurerm_public_ip.third.id}"
  }
  depends_on = [azurerm_network_security_group.main, azurerm_subnet.internal, azurerm_public_ip.main, azurerm_network_security_group.second, azurerm_network_security_group.third]
}
