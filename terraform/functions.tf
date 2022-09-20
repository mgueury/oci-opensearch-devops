variable "function_image" {
}

resource "oci_functions_application" "opensearch_application" {
  #Required
  compartment_id = var.compartment_ocid
  display_name   = "opensearch-application"
  subnet_ids     = [oci_core_subnet.opensearch_subnet.id]

  image_policy_config {
    #Required
    is_policy_enabled = false
  }
  trace_config {
    domain_id  = ""
    is_enabled = true
  }
}

variable function_image_uri {}

resource "oci_functions_function" "tika_function" {
  #Required
  application_id = oci_functions_application.opensearch_application.id
  display_name   = "tika-function"
  image          = var.function_image_uri
  memory_in_mbs  = "128"

  #Optional
  timeout_in_seconds = "30"
  trace_config {
    is_enabled = true
  }

  provisioned_concurrency_config {
    strategy = "CONSTANT"
    count = 40
  }
}


