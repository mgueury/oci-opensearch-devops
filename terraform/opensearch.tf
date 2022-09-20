resource "oci_opensearch_opensearch_cluster" "opensearch_cluster" {
  #Required
  compartment_id                     = var.compartment_ocid
  data_node_count                    = 1
  data_node_host_memory_gb           = 16
  data_node_host_ocpu_count          = 2
  data_node_host_type                = "FLEX"
  data_node_storage_gb               = 50
  display_name                       = "opensearch-cluster"
  master_node_count                  = 1
  master_node_host_memory_gb         = 16
  master_node_host_ocpu_count        = 1
  master_node_host_type              = "FLEX"
  opendashboard_node_count           = 1
  opendashboard_node_host_memory_gb  = 16
  opendashboard_node_host_ocpu_count = 2
  software_version                   = "1.2.4"
  subnet_compartment_id              = var.compartment_ocid
  subnet_id                          = oci_core_subnet.opensearch_subnet.id
  vcn_compartment_id                 = var.compartment_ocid
  vcn_id                             = oci_core_vcn.opensearch_vcn.id
}

data "oci_opensearch_opensearch_clusters" "opensearch_clusters" {
  #Required
  compartment_id = var.compartment_ocid
}
