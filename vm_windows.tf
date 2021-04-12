resource "azurerm_windows_virtual_machine" "machine" {
  count                 = var.source_image_reference.offer == "WindowsServer" ? 1 : 0
  name                  = var.name
  resource_group_name   = var.resource_group
  location              = var.location
  size                  = var.vm_size
  admin_username        = var.admin_user.username
  admin_password        = var.admin_user.password
  network_interface_ids = local.network_interface_ids

  os_disk {
    caching              = var.os_disk.caching
    storage_account_type = var.os_disk.storage_account_type
  }

  # Boot diagnostic settings:
  # If managed boot diagnostics is set, define a null value on storage_account_uri
  # and if not, set the URI for the storage account.
  dynamic "boot_diagnostics" {
    for_each = var.managed_boot_diagnostic ? ["true"] : []
    content {
      storage_account_uri = null
    }
  }
  dynamic "boot_diagnostics" {
    for_each = var.boot_diagnostic_storage_account != null ? ["true"] : []
    content {
      storage_account_uri = var.boot_diagnostic_storage_account
    }
  }

  zone                = var.availability_zone
  availability_set_id = var.availability_set_id
  timezone            = var.timezone

  source_image_reference {
    publisher = var.source_image_reference.publisher
    offer     = var.source_image_reference.offer
    sku       = var.source_image_reference.sku
    version   = var.source_image_reference.version
  }
}