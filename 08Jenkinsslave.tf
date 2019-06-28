resource "azurerm_virtual_machine" "second" {
  name                  = "${var.prefix}slaveVM"
  location              = "${azurerm_resource_group.main.location}"
  resource_group_name   = "${azurerm_resource_group.main.name}"
  network_interface_ids = ["${azurerm_network_interface.second.id}"]
  vm_size               = "Standard_B1ms"

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
    name              = "myosdisk2"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "jenkinsslave"
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
  inline = ["sudo apt install -y wget openjdk-8-jdk openjdk-8-jre"]
  connection {
    type = "ssh"
    user = "sulayman"
    private_key = file("/home/sulayman/.ssh/id_rsa")
    host = "${azurerm_public_ip.second.fqdn}"
  }
  }
}
