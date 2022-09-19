resource "oci_events_rule" "test_rule" {
  #Required
  actions {
    #Required
    actions {
      #Required
      action_type = "ONS"
      is_enabled  = true

      #Optional
      description = "description"
      topic_id    = oci_ons_notification_topic.test_notification_topic.id
    }

    actions {
      #Required
      action_type = "OSS"
      is_enabled  = true

      #Optional
      description = "description"
      stream_id   = oci_streaming_stream.test_stream.id
    }
  }

  compartment_id = var.compartment_id
  condition      = "{\"eventType\": \"com.oraclecloud.dbaas.autonomous.database.backup.end\"}"
  display_name   = "This rule sends a notification upon completion of DbaaS backup"
  is_enabled     = true
}

data "oci_events_rules" "test_rules" {
  #Required
  compartment_id = var.compartment_id

  #Optional
  display_name = "This rule sends a notification upon completion of DbaaS backup"
  state        = "ACTIVE"
}

resource "oci_streaming_stream" "test_stream" {
  compartment_id     = var.tenancy_ocid
  name               = "testStream"
  partitions         = "1"
  retention_in_hours = "24"
}

resource "oci_ons_notification_topic" "test_notification_topic" {
  #Required
  compartment_id = var.compartment_id
  name           = "testNotificationTopic"
}
