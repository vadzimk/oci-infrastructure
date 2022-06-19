# Security group

resource "oci_core_network_security_group" "webserver-nsg" {
  #Required
  compartment_id = var.compartment_id
  vcn_id         = var.vcn_id

  #Optional
  display_name = "${var.env_prefix}-webserver-nsg"
}

# SSH rule

resource "oci_core_network_security_group_security_rule" "ssh-rule" {
  #Required
  network_security_group_id = oci_core_network_security_group.webserver-nsg.id
  direction                 = "INGRESS"
  protocol                  = "6" # TCP protocol

  #Optional
  description = "Allow SSH"
  # destination = var.network_security_group_security_rule_destination
  # destination_type = var.network_security_group_security_rule_destination_type
  # usually limited number ip adresses can access but i allow it from anywhere in case i travel
  source      = var.allow_ssh_from_anywhere ? "0.0.0.0/0" : "${var.myip}/32" # CIDR block consisting of just one address
  source_type = "CIDR_BLOCK"
  tcp_options {
    #Optional
    destination_port_range {
      #Required
      max = "22"
      min = "22"
    }
    source_port_range {
      #Required
      max = "22"
      min = "22"
    }

  }
}

# HTTP rule

resource "oci_core_network_security_group_security_rule" "http-rule" {
  #Required
  network_security_group_id = oci_core_network_security_group.webserver-nsg.id
  direction                 = "INGRESS"
  protocol                  = "6" # TCP protocol

  #Optional
  description = "Allow HTTP"
  source      = "0.0.0.0/0" # all
  source_type = "CIDR_BLOCK"
  tcp_options {
    #Optional
    destination_port_range {
      #Required
      max = "80"
      min = "80"
    }
  }
}

# HTTPS rule

resource "oci_core_network_security_group_security_rule" "https-rule" {
  #Required
  network_security_group_id = oci_core_network_security_group.webserver-nsg.id
  direction                 = "INGRESS"
  protocol                  = "6" # TCP protocol

  #Optional
  description = "Allow HTTPS"
  source      = "0.0.0.0/0" # all
  source_type = "CIDR_BLOCK"
  tcp_options {
    #Optional
    destination_port_range {
      #Required
      max = "443"
      min = "443"
    }
  }
}

# PostgreSql rule for test db

resource "oci_core_network_security_group_security_rule" "https-rule" {
  #Required
  network_security_group_id = oci_core_network_security_group.webserver-nsg.id
  direction                 = "INGRESS"
  protocol                  = "6" # TCP protocol

  #Optional
  description = "Allow PostgreSql"
  source      = "0.0.0.0/0" # all
  source_type = "CIDR_BLOCK"
  tcp_options {
    #Optional
    destination_port_range {
      #Required
      max = "5432"
      min = "5432"
    }
  }
}

# Egress rule

resource "oci_core_network_security_group_security_rule" "egress-rule" {
  #Required
  network_security_group_id = oci_core_network_security_group.webserver-nsg.id
  direction                 = "EGRESS"
  protocol                  = "all" # TCP protocol

  #Optional
  description      = "Allow egress"
  destination      = "0.0.0.0/0"
  destination_type = "CIDR_BLOCK"
}