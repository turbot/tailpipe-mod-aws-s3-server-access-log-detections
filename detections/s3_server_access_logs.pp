benchmark "s3_server_access_log_detections" {
  title       = "S3 Server Access Log Detections"
  description = "This benchmark contains recommendations when scanning S3 server access logs."
  type        = "detection"
  children = [
    detection.s3_bucket_accessed_using_insecure_tls_version,
    detection.s3_object_accessed_outside_business_hours,
    detection.s3_object_accessed_using_insecure_tls_version,
    detection.s3_object_accessed_using_suspicious_user_agent,
    detection.s3_object_accessed_with_large_request_size,
    detection.s3_object_accessed_with_large_response_size,
  ]

  tags = merge(local.aws_s3_server_access_log_detections_common_tags, {
    type = "Benchmark"
  })
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
  description     = "Detect when an S3 object was accessed using a suspicious user-agent, such as penetration testing tools, command-line tools, or known malicious agents, which are commonly used in automated attacks."
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
        -- Command-line tools
        user_agent ilike '%curl%' or
        user_agent ilike '%wget%' or
        user_agent ilike '%python%' or
        user_agent ilike '%go-http%' or
        user_agent ilike '%ruby%' or
        user_agent ilike '%powershell%' or
        
        -- Known scanners and penetration testing tools
        user_agent ilike '%nuclei%' or
        user_agent ilike '%nmap%' or
        user_agent ilike '%burpsuite%' or
        user_agent ilike '%sqlmap%' or
        user_agent ilike '%nikto%' or
        user_agent ilike '%hydra%' or
        user_agent ilike '%metasploit%' or
        user_agent ilike '%gobuster%' or
        user_agent ilike '%dirbuster%' or
        
        -- Suspicious bots and crawlers
        user_agent ilike '%zgrab%' or
        user_agent ilike '%masscan%' or
        user_agent ilike '%googlebot%' or
        user_agent ilike '%baiduspider%' or
        
        -- Generic indicators
        user_agent ilike '%scanner%' or
        user_agent ilike '%exploit%' or
        user_agent ilike '%attack%' or
        user_agent = '-' or
        user_agent is null
      )
    order by
      tp_timestamp desc;
  EOQ
}

detection "s3_object_accessed_outside_business_hours" {
  title           = "S3 Object Accessed Outside Business Hours"
  description     = "Detect when an S3 object was accessed outside of typical business hours, which may indicate unusual activity patterns worth investigating."
  documentation   = file("./detections/docs/s3_object_accessed_outside_business_hours.md")
  severity        = "low"
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
      extract(hour from tp_timestamp) not between 8 and 18
      and operation = 'REST.GET.OBJECT'
    order by
      tp_timestamp desc;
  EOQ
}

detection "s3_object_accessed_with_large_response_size" {
  title           = "S3 Object Accessed with Large Response Size"
  description     = "Detect when an S3 object was accessed and the response size exceeded 100MB, which may indicate potential data exfiltration or unusual access patterns."
  documentation   = file("./detections/docs/s3_object_accessed_with_large_response_size.md")
  severity        = "low"
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
  description     = "Detect when an S3 object was accessed and the request size exceeded 10MB, which may indicate unusual upload patterns."
  documentation   = file("./detections/docs/s3_object_accessed_with_large_request_size.md")
  severity        = "low"
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