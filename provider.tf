provider "azurerm" {
version = "=1.30.1"
}

variable "prefix" {
  default = "terraform"
}

resource "azurerm_resource_group" "main" {
  name     = "${var.prefix}-resources"
  location = "uksouth"
}


resource "azurerm_virtual_network" "main" {
  name                = "${var.prefix}-network"
  address_space       = ["10.0.0.0/16"]
  location            = "${azurerm_resource_group.main.location}"
  resource_group_name = "${azurerm_resource_group.main.name}"
}

resource "azurerm_subnet" "internal" {
  name                 = "internal"
  resource_group_name  = "${azurerm_resource_group.main.name}"
  virtual_network_name = "${azurerm_virtual_network.main.name}"
  address_prefix       = "10.0.2.0/24"
}

resource "azurerm_public_ip" "main" {
  name = "myPublicIP"
  location = "${azurerm_resource_group.main.location}"
  resource_group_name = "${azurerm_resource_group.main.name}"
  allocation_method = "Dynamic"
  domain_name_label = "sulayman-${formatdate("DDMMYYhhmmss", timestamp())}"
}

resource "azurerm_network_security_group" "main" {
  name = "terraformNSG"
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
resource "azurerm_network_interface" "main" {
  name                = "${var.prefix}-nic"
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

resource "azurerm_virtual_machine" "main" {
  name                  = "${var.prefix}-vm"
  location              = "${azurerm_resource_group.main.location}"
  resource_group_name   = "${azurerm_resource_group.main.name}"
  network_interface_ids = ["${azurerm_network_interface.main.id}"]
  vm_size               = "Standard_DS1_v2"

  # Uncomment this line to delete the OS disk automatically when deleting the VM
  # delete_os_disk_on_termination = true


  # Uncomment this line to delete the data disks automatically when deleting the VM
  # delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
  storage_os_disk {
    name              = "myosdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "hostname"
    admin_username = "sulayman"
  }
  os_profile_linux_config {
    disable_password_authentication = true
    ssh_keys {
    path = "/home/sulayman/.ssh/authorized_keys"
    key_data = "${file("/home/sulayman/.ssh/id_rsa.pub")}"
      }
  }
  tags = {
    environment = "staging"
  }
  provisioner "remote-exec" {
  inline = [
            "git clone https://github.com/SulaymanSaleem/Jenkins",
            "cd ~/Jenkins",
            "./install.sh"
            ]
  connection {
    type = "ssh"
    user = "sulayman"
    private_key = file("/home/sulayman/.ssh/id_rsa")
    host = "${azurerm_public_ip.main.fqdn}"
  }
  }
}
