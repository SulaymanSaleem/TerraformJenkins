resource "azurerm_virtual_machine" "third" {
  name                  = "pythonvm"
  location              = "${azurerm_resource_group.main.location}"
  resource_group_name   = "${azurerm_resource_group.main.name}"
  network_interface_ids = ["${azurerm_network_interface.third.id}"]
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
    name              = "myosdisk3"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "pythonvm"
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
  connection {
    type = "ssh"
    user = "sulayman"
    private_key = file("/home/sulayman/.ssh/id_rsa")
    host = "${azurerm_public_ip.third.fqdn}"
  }
  }
}
