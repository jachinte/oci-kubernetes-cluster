resource "oci_core_vcn" "FoggyKitchenVCN" {
  cidr_block     = var.VCN-CIDR
  compartment_id = oci_identity_compartment.FoggyKitchenCompartment.id
  display_name   = "FoggyKitchenVCN"
}

resource "oci_core_internet_gateway" "FoggyKitchenInternetGateway" {
  compartment_id = oci_identity_compartment.FoggyKitchenCompartment.id
  display_name   = "FoggyKitchenInternetGateway"
  vcn_id         = oci_core_vcn.FoggyKitchenVCN.id
}

resource "oci_core_route_table" "FoggyKitchenRouteTableViaIGW" {
  compartment_id = oci_identity_compartment.FoggyKitchenCompartment.id
  vcn_id         = oci_core_vcn.FoggyKitchenVCN.id
  display_name   = "FoggyKitchenRouteTableViaIGW"

  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_internet_gateway.FoggyKitchenInternetGateway.id
  }
}

resource "oci_core_security_list" "FoggyKitchenOKESecurityList" {
  compartment_id = oci_identity_compartment.FoggyKitchenCompartment.id
  display_name   = "FoggyKitchenOKESecurityList"
  vcn_id         = oci_core_vcn.FoggyKitchenVCN.id

  egress_security_rules {
    protocol    = "All"
    destination = "0.0.0.0/0"
  }

  /* This entry is necesary for DNS resolving (open UDP traffic). */
  ingress_security_rules {
    protocol = "17" // UDP
    source   = var.VCN-CIDR
  }

  // Ingress and egress rules for file system storage
  egress_security_rules {
    destination = var.FoggyKitchenNodePoolSubnet-CIDR
    protocol    = "06"
    tcp_options {
      source_port_range {
        min = 111
        max = 111
      }
    }
  }

  egress_security_rules {
    destination = var.FoggyKitchenNodePoolSubnet-CIDR
    protocol    = "17"
    udp_options {
      source_port_range {
        min = 111
        max = 111
      }
    }
  }

  egress_security_rules {
    destination = var.FoggyKitchenNodePoolSubnet-CIDR
    protocol    = "06"
    tcp_options {
      source_port_range {
        min = 2048
        max = 2050
      }
    }
  }

  ingress_security_rules {
    source   = var.FoggyKitchenNodePoolSubnet-CIDR
    protocol = "06"
    tcp_options {
      min = 111
      max = 111
    }
  }

  ingress_security_rules {
    source   = var.FoggyKitchenNodePoolSubnet-CIDR
    protocol = "17"
    udp_options {
      min = 111
      max = 111
    }
  }

  ingress_security_rules {
    source   = var.FoggyKitchenNodePoolSubnet-CIDR
    protocol = "06"
    tcp_options {
      min = 2048
      max = 2050
    }
  }

  ingress_security_rules {
    source   = var.FoggyKitchenNodePoolSubnet-CIDR
    protocol = "17"
    udp_options {
      min = 2048
      max = 2048
    }
  }
}

resource "oci_core_subnet" "FoggyKitchenClusterSubnet" {
  cidr_block     = var.FoggyKitchenClusterSubnet-CIDR
  compartment_id = oci_identity_compartment.FoggyKitchenCompartment.id
  vcn_id         = oci_core_vcn.FoggyKitchenVCN.id
  display_name   = "FoggyKitchenClusterSubnet"

  security_list_ids = [oci_core_vcn.FoggyKitchenVCN.default_security_list_id, oci_core_security_list.FoggyKitchenOKESecurityList.id]
  route_table_id    = oci_core_route_table.FoggyKitchenRouteTableViaIGW.id
}

resource "oci_core_subnet" "FoggyKitchenNodePoolSubnet" {
  cidr_block     = var.FoggyKitchenNodePoolSubnet-CIDR
  compartment_id = oci_identity_compartment.FoggyKitchenCompartment.id
  vcn_id         = oci_core_vcn.FoggyKitchenVCN.id
  display_name   = "FoggyKitchenNodePoolSubnet"

  security_list_ids = [oci_core_vcn.FoggyKitchenVCN.default_security_list_id, oci_core_security_list.FoggyKitchenOKESecurityList.id]
  route_table_id    = oci_core_route_table.FoggyKitchenRouteTableViaIGW.id
}

