resource "oci_file_storage_mount_target" "FoggyKitchenMountTarget" {
  availability_domain = var.availablity_domain_name
  compartment_id      = oci_identity_compartment.FoggyKitchenCompartment.id
  subnet_id           = oci_core_subnet.FoggyKitchenNodePoolSubnet.id
  ip_address          = "10.0.3.10"
  display_name        = "FoggyKitchenMountTarget"
}

resource "oci_file_storage_export_set" "FoggyKitchenExportSet" {
  mount_target_id = oci_file_storage_mount_target.FoggyKitchenMountTarget.id
  display_name    = "FoggyKitchenExportSet"
}

resource "oci_file_storage_file_system" "FoggyKitchenFileSystem" {
  availability_domain = var.availablity_domain_name
  compartment_id      = oci_identity_compartment.FoggyKitchenCompartment.id
  display_name        = "FoggyKitchenFileSystem"
}

resource "oci_file_storage_export" "FoggyKitchenExport" {
  export_set_id  = oci_file_storage_mount_target.FoggyKitchenMountTarget.export_set_id
  file_system_id = oci_file_storage_file_system.FoggyKitchenFileSystem.id
  path           = "/sharedfs"
  export_options {
    source                         = var.VCN-CIDR
    access                         = "READ_WRITE"
    identity_squash                = "NONE"
    require_privileged_source_port = true
  }
}
