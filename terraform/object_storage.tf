resource "oci_objectstorage_bucket" "opensearch_bucket" {
  compartment_id = var.compartment_ocid
  namespace      = local.ocir_namespace
  name           = "opensearch-bucket"
  access_type    = "NoPublicAccess"
}

resource oci_events_rule opensearch_rule {
  actions {
    actions {
      action_type = "OSS"
      is_enabled = "true"
      stream_id  = oci_streaming_stream.opensearch_stream.id
    }
  }
  compartment_id = var.compartment_ocid
  condition      = "{\"eventType\":[\"com.oraclecloud.objectstorage.createobject\",\"com.oraclecloud.objectstorage.deleteobject\",\"com.oraclecloud.objectstorage.updateobject\"],\"data\":{\"additionalDetails\":{\"bucketName\":[\"opensearch-bucket\"]}}}"
  #description = <<Optional value not found in discovery>>
  display_name = "opensearch-input-rule"
  is_enabled = "true"
}

data "oci_events_rules" "opensearch_rules" {
  #Required
  compartment_id = var.compartment_ocid

  #Optional
  display_name = "This rule sends a notification upon completion of DbaaS backup"
  state        = "ACTIVE"
}

resource "oci_streaming_stream" "opensearch_stream" {
  compartment_id     = var.tenancy_ocid
  name               = "opensearch-stream"
  partitions         = "1"
  retention_in_hours = "24"
}

# resource "oci_ons_notification_topic" "test_notification_topic" {
  #Required
#  compartment_id = var.compartment_ocid
#  name           = "opensearch"
# }
