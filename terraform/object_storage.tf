resource "oci_events_rule" "opensearch_rule" {
  #Required
  actions {
    #Required
    actions {
      #Required
      action_type = "ONS"
      is_enabled  = true

      #Optional
      description = "description"
      # topic_id    = oci_ons_notification_topic.test_notification_topic.id
    }

    actions {
      #Required
      action_type = "OSS"
      is_enabled  = true

      #Optional
      description = "description"
      stream_id   = oci_streaming_stream.opensearch_stream.id
    }
  }

  compartment_id = var.compartment_ocid
  condition      = "{\"eventType\": \"com.oraclecloud.dbaas.autonomous.database.backup.end\"}"
  display_name   = "This rule sends a notification upon completion of DbaaS backup"
  is_enabled     = true
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
