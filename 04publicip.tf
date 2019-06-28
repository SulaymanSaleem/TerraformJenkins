resource "azurerm_public_ip" "main" {
  name = "myPublicIPa"
  location = "${azurerm_resource_group.main.location}"
  resource_group_name = "${azurerm_resource_group.main.name}"
  allocation_method = "Dynamic"
  domain_name_label = "sulayman-${formatdate("DDMMYYhhmmss", timestamp())}"
}

resource "azurerm_public_ip" "second" {
  name = "myPublicIPb"
  location = "${azurerm_resource_group.main.location}"
  resource_group_name = "${azurerm_resource_group.main.name}"
  allocation_method = "Dynamic"
  domain_name_label = "sulayman-${formatdate("DDMMYYhhmmss", timestamp())}"
  depends_on = [azurerm_public_ip.main]
}

resource "azurerm_public_ip" "third" {
  name = "myPublicIPc"
  location = "${azurerm_resource_group.main.location}"
  resource_group_name = "${azurerm_resource_group.main.name}"
  allocation_method = "Dynamic"
  domain_name_label = "sulayman-${formatdate("DDMMYYhhmmss", timestamp())}"
  depends_on = [azurerm_public_ip.main,azurerm_public_ip.second]
}
