variable "tenancy_ocid" {
}

variable "region" {
}

variable "compartment_ocid" {
}

variable "ssh_public_key" {
}

variable "ssh_private_key" {
}

# Defines the number of instances to deploy
variable "num_instances" {
  default = "1"
}

variable "instance_shape" {
  default = "VM.Standard.E3.Flex"
}

variable "instance_ocpus" {
  default = 1
}

variable "instance_shape_config_memory_in_gbs" {
  default = 8 
}

variable "instance_image_ocid" {
  type = map(string)

  default = {
    eu-frankfurt-1 = "ocid1.image.oc1.eu-frankfurt-1.aaaaaaaarwsp3psjjpluqpb4krvao2xvs5cnaei3whekxlc2a6oqqbrfpliq"
  }
}

variable  availability_domain {
  default="Vihs:EU-FRANKFURT-1-AD-1"
}

variable "db_size" {
  default = "50" # size in GBs
}

resource "oci_core_instance" "opensearch_instance" {
  availability_domain = var.availability_domain 
  compartment_id      = var.compartment_ocid
  display_name        = "opensearch-instance"
  shape               = var.instance_shape

  shape_config {
    ocpus = var.instance_ocpus
    memory_in_gbs = var.instance_shape_config_memory_in_gbs
  }

  create_vnic_details {
    subnet_id                 = oci_core_subnet.opensearch_subnet.id 
    display_name              = "Primaryvnic"
    assign_public_ip          = true
    assign_private_dns_record = true
    hostname_label            = "opensearch-instance"
  }

  source_details {
    source_type = "image"
    source_id = var.instance_image_ocid[var.region]
  }

  metadata = {
    ssh_authorized_keys = var.ssh_public_key
    user_data           = base64encode(file("./userdata_bootstrap.sh"))
  }

  provisioner "file" {
    connection {
      agent       = false
      timeout     = "5m"
      user        = "opc"
      private_key = var.ssh_private_key
      host        = oci_core_instance.opensearch_instance.*.public_ip[0]
    }

    source      = "index.html"
    destination = "/tmp/index.html"
  }

  preemptible_instance_config {
    preemption_action {
      type = "TERMINATE"
      preserve_boot_volume = false
    }
  }

  timeouts {
    create = "60m"
  }
}

# --- Network ---

resource "oci_core_vcn" "opensearch_vcn" {
  cidr_block     = "10.1.0.0/16"
  compartment_id = var.compartment_ocid
  display_name   = "opensearch-vcn"
  dns_label      = "opensearch-vcn"
}

resource "oci_core_internet_gateway" "opensearch_internet_gateway" {
  compartment_id = var.compartment_ocid
  display_name   = "opensearch-internet-gateway"
  vcn_id         = oci_core_vcn.opensearch_vcn.id
}

resource "oci_core_default_route_table" "default_route_table" {
  manage_default_resource_id = oci_core_vcn.opensearch_vcn.default_route_table_id
  display_name               = "DefaultRouteTable"

  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_internet_gateway.opensearch_internet_gateway.id
  }
}

resource "oci_core_subnet" "opensearch_subnet" {
  availability_domain = data.oci_identity_availability_domain.ad.name
  cidr_block          = "10.1.20.0/24"
  display_name        = "opensearch-subnet"
  dns_label           = "opensearch-subnet"
  security_list_ids   = [oci_core_vcn.opensearch_vcn.default_security_list_id]
  compartment_id      = var.compartment_ocid
  vcn_id              = oci_core_vcn.opensearch_vcn.id
  route_table_id      = oci_core_vcn.opensearch_vcn.default_route_table_id
  dhcp_options_id     = oci_core_vcn.opensearch_vcn.default_dhcp_options_id
}



# Output the private and public IPs of the instance
output "instance_private_ips" {
  value = [oci_core_instance.opensearch_instance.*.private_ip]
}

output "instance_public_ips" {
  value = [oci_core_instance.opensearch_instance.*.public_ip]
}

data "oci_identity_availability_domain" "ad" {
  compartment_id = var.tenancy_ocid
  ad_number      = 1
}

