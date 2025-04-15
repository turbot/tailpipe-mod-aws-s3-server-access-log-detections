// Benchmarks and controls for specific services should override the "service" tag
locals {
  aws_s3_server_access_log_detections_common_tags = {
    category = "Detections"
    plugin   = "aws"
    service  = "AWS/S3"
  }
}

locals {
  # Local internal variables to build the SQL select clause for common
  # dimensions. Do not edit directly.
  detection_sql_columns = <<-EOQ
  tp_timestamp as timestamp,
  operation,
  bucket as resource,
  requester as actor,
  tp_source_ip as source_ip,
  tp_index as account_id,
  tp_id as source_id,
  http_status,
  error_code,
  *
  EOQ
}

locals {
  // Keep same order as SQL statement for easier readability
  detection_display_columns = [
    "timestamp",
    "operation",
    "resource",
    "actor",
    "source_ip",
    "account_id",
    "source_id",
    "http_status",
    "error_code"
  ]
}
