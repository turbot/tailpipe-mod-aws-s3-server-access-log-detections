
benchmark "s3_server_access_log_detections" {
  title       = "S3 Server Access Log Detections"
  description = "This benchmark contains recommendations when scanning S3 server access logs."
  type        = "detection"
  children = [
    detection.s3_bucket_accessed_using_insecure_tls_version,
    detection.s3_object_accessed_outside_business_hours,
    detection.s3_object_accessed_publicly,
    detection.s3_object_accessed_using_insecure_tls_version,
    detection.s3_object_accessed_using_suspicious_user_agent,
    detection.s3_object_accessed_with_large_request_size,
    detection.s3_object_accessed_with_large_response_size,
    detection.s3_object_uploaded_without_encryption,
  ]

  tags = merge(local.aws_s3_server_access_log_detections_common_tags, {
    type = "Benchmark"
  })
}

detection "s3_object_accessed_publicly" {
  title           = "S3 Object Accessed Publicly"
  description     = "Detect when an S3 object was accessed publicly, potentially exposing sensitive data to unauthorized users."
  documentation   = file("./detections/docs/s3_object_accessed_publicly.md")
  severity        = "high"
  display_columns = local.detection_display_columns
  query           = query.s3_object_accessed_publicly

  tags = merge(local.aws_s3_server_access_log_detections_common_tags, {
    mitre_attack_ids = "T1078.004,T1546"
  })
}

query "s3_object_accessed_publicly" {
  sql = <<-EOQ
    select
      ${local.detection_sql_columns}
    from
      aws_s3_server_access_log
    where
      operation = 'REST.GET.OBJECT'
      and (requester IS NULL OR requester = '-')  -- Anonymous access
      and http_status = 200
    order by
      tp_timestamp desc;
  EOQ
}

detection "s3_object_uploaded_without_encryption" {
  title           = "S3 Object Uploaded Without Encryption"
  description     = "Detect when an S3 object was uploaded without server-side encryption. Uploading unencrypted objects can expose sensitive data to unauthorized access."
  documentation   = file("./detections/docs/s3_object_uploaded_without_encryption.md")
  severity        = "medium"
  display_columns = local.detection_display_columns
  query           = query.s3_object_uploaded_without_encryption

  tags = merge(local.aws_s3_server_access_log_detections_common_tags, {
    mitre_attack_ids = "TA0040:T1485"
  })
}

query "s3_object_uploaded_without_encryption" {
  sql = <<-EOQ
    select
      ${local.detection_sql_columns}
    from
      aws_s3_server_access_log
    where
      operation = 'REST.PUT.OBJECT'
      and request_uri not ilike '%x-amz-server-side-encryption=%'
    order by
      tp_timestamp desc;
  EOQ
}

detection "s3_object_accessed_using_insecure_tls_version" {
  title           = "S3 Object Accessed Using Insecure TLS Version"
  description     = "Detect when an S3 object was accessed over a deprecated or insecure TLS version, potentially exposing data in transit to interception or downgrade attacks."
  documentation   = file("./detections/docs/s3_object_accessed_using_insecure_tls_version.md")
  severity        = "medium"
  display_columns = local.detection_display_columns
  query           = query.s3_object_accessed_using_insecure_tls_version

  tags = merge(local.aws_s3_server_access_log_detections_common_tags, {
    mitre_attack_ids = "TA0001:T1078"
  })
}

query "s3_object_accessed_using_insecure_tls_version" {
  sql = <<-EOQ
    select
      ${local.detection_sql_columns}
    from
      aws_s3_server_access_log
    where
      operation in ('REST.GET.OBJECT', 'REST.PUT.OBJECT', 'REST.DELETE.OBJECT')
      and tls_version in ('TLSv1.0', 'TLSv1.1')
    order by
      tp_timestamp desc;
  EOQ
}

detection "s3_bucket_accessed_using_insecure_tls_version" {
  title           = "S3 Bucket Accessed Using Insecure TLS Version"
  description     = "Detect when an S3 bucket was accessed over a deprecated or insecure TLS version, potentially exposing data in transit to interception or downgrade attacks."
  documentation   = file("./detections/docs/s3_bucket_accessed_using_insecure_tls_version.md")
  severity        = "medium"
  display_columns = local.detection_display_columns
  query           = query.s3_bucket_accessed_using_insecure_tls_version

  tags = merge(local.aws_s3_server_access_log_detections_common_tags, {
    mitre_attack_ids = "TA0001:T1078"
  })
}

query "s3_bucket_accessed_using_insecure_tls_version" {
  sql = <<-EOQ
    select
      ${local.detection_sql_columns}
    from
      aws_s3_server_access_log
    where
      operation not in ('REST.GET.OBJECT', 'REST.PUT.OBJECT', 'REST.DELETE.OBJECT')
      and tls_version in ('TLSv1.0', 'TLSv1.1')
    order by
      tp_timestamp desc;
  EOQ
}

detection "s3_object_accessed_using_suspicious_user_agent" {
  title           = "S3 Object Accessed Using Suspicious User-Agent"
  description     = "Detect when an S3 object was accessed using a suspicious user-agent, such as command-line tools or bots, which are commonly used in scraping or automated abuse."
  documentation   = file("./detections/docs/s3_object_accessed_using_suspicious_user_agent.md")
  severity        = "medium"
  display_columns = local.detection_display_columns
  query           = query.s3_object_accessed_using_suspicious_user_agent

  tags = merge(local.aws_s3_server_access_log_detections_common_tags, {
    mitre_attack_ids = "TA0011:T1071.001,TA0009:T1119"
  })
}

query "s3_object_accessed_using_suspicious_user_agent" {
  sql = <<-EOQ
    select
      ${local.detection_sql_columns}
    from
      aws_s3_server_access_log
    where
      operation in ('REST.GET.OBJECT', 'REST.PUT.OBJECT', 'REST.DELETE.OBJECT')
      and (
        user_agent ilike '%curl%' or
        user_agent ilike '%python%' or
        user_agent ilike '%bot%'
      )
    order by
      tp_timestamp desc;
  EOQ
}

detection "s3_object_accessed_outside_business_hours" {
  title           = "S3 Object Accessed Outside Business Hours"
  description     = "Detect when an S3 object was accessed outside of typical business hours, which may indicate unauthorized activity or credential misuse."
  documentation   = file("./detections/docs/s3_object_accessed_outside_business_hours.md")
  severity        = "medium"
  display_columns = local.detection_display_columns
  query           = query.s3_object_accessed_outside_business_hours

  tags = merge(local.aws_s3_server_access_log_detections_common_tags, {
    mitre_attack_ids = "TA0006:T1078"
  })
}

query "s3_object_accessed_outside_business_hours" {
  sql = <<-EOQ
    select
      ${local.detection_sql_columns}
    from
      aws_s3_server_access_log
    where
      extract(hour from timestamp) not between 8 and 18
      and operation = 'REST.GET.OBJECT'
    order by
      tp_timestamp desc;
  EOQ
}

detection "s3_object_accessed_with_large_response_size" {
  title           = "S3 Object Accessed with Large Response Size"
  description     = "Detect when an S3 object was accessed and the response size exceeded 100MB, which may indicate bulk data exfiltration."
  documentation   = file("./detections/docs/s3_object_accessed_with_large_response_size.md")
  severity        = "medium"
  display_columns = local.detection_display_columns
  query           = query.s3_object_accessed_with_large_response_size

  tags = merge(local.aws_s3_server_access_log_detections_common_tags, {
    mitre_attack_ids = "TA0010:T1030"
  })
}

query "s3_object_accessed_with_large_response_size" {
  sql = <<-EOQ
    select
      ${local.detection_sql_columns}
    from
      aws_s3_server_access_log
    where operation = 'REST.GET.OBJECT'
      and bytes_sent > 100000000
    order by
      tp_timestamp desc;
  EOQ
}

detection "s3_object_accessed_with_large_request_size" {
  title           = "S3 Object Accessed with Large Request Size"
  description     = "Detect when an S3 object was accessed and the request size exceeded 10MB, which may indicate bulk data exfiltration."
  documentation   = file("./detections/docs/s3_object_accessed_with_large_request_size.md")
  severity        = "medium"
  display_columns = local.detection_display_columns
  query           = query.s3_object_accessed_with_large_request_size

  tags = merge(local.aws_s3_server_access_log_detections_common_tags, {
    mitre_attack_ids = "TA0010:T1030"
  })
}

query "s3_object_accessed_with_large_request_size" {
  sql = <<-EOQ
    select
      ${local.detection_sql_columns}
    from
      aws_s3_server_access_log
    where operation = 'REST.GET.OBJECT'
      and object_size > 10000000
    order by
      tp_timestamp desc;
  EOQ
}