
benchmark "s3_server_access_log_detections" {
  title       = "S3 Server Access Log Detections"
  description = "This benchmark contains recommendations when scanning S3 server access logs."
  type        = "detection"
  children = [
    detection.s3_bucket_acl_granted_public_access,
    detection.s3_bucket_encryption_disabled,
    detection.s3_bucket_logging_disabled,
    detection.s3_bucket_policy_granted_public_access,
    detection.s3_bucket_public_access_block_disabled,
    detection.s3_bucket_replication_disabled,
    detection.s3_bucket_versioning_disabled,
    detection.s3_object_accessed_publicly,
    detection.s3_object_uploaded_without_encryption
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
    mitre_attack_ids = "TA0001:T1537"
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

detection "s3_bucket_policy_granted_public_access" {
  title           = "S3 Bucket Policy Granted Public Access"
  description     = "Detect when public access was granted to an S3 bucket by modifying its policy. Granting public access through a bucket policy can expose sensitive data to unauthorized users, increasing the risk of data breaches, data exfiltration, or malicious exploitation."
  documentation   = file("./detections/docs/s3_bucket_policy_granted_public_access.md")
  severity        = "high"
  display_columns = local.detection_display_columns
  query           = query.s3_bucket_policy_granted_public_access

  tags = merge(local.aws_s3_server_access_log_detections_common_tags, {
    mitre_attack_ids = "TA0005:T1070,TA0001:T1190"
  })
}

query "s3_bucket_policy_granted_public_access" {
  sql = <<-EOQ
    select
      ${local.detection_sql_columns}
    from
      aws_s3_server_access_log
    where
      operation = 'REST.PUT.BUCKETPOLICY'
      and (
        json_contains(request_uri, '"Principal": "*"')
        or json_contains(request_uri, '"Principal": {"AWS": "*"}')
      )
      and json_contains(request_uri, '"Effect": "Allow"')
    order by
      tp_timestamp desc;
  EOQ
}

detection "s3_bucket_acl_granted_public_access" {
  title           = "S3 Bucket ACL Granted Public Access"
  description     = "Detect when an S3 bucket ACL was modified to grant public access. Public ACLs can expose sensitive data to unauthorized users, increasing the risk of data breaches and data exfiltration."
  documentation   = file("./detections/docs/s3_bucket_acl_granted_public_access.md")
  severity        = "high"
  display_columns = local.detection_display_columns
  query           = query.s3_bucket_acl_granted_public_access

  tags = merge(local.aws_s3_server_access_log_detections_common_tags, {
    mitre_attack_ids = "TA0005:T1070,TA0001:T1190"
  })
}

query "s3_bucket_acl_granted_public_access" {
  sql = <<-EOQ
    select
      ${local.detection_sql_columns}
    from
      aws_s3_server_access_log
    where
      operation = 'REST.PUT.ACL'
      and (
        json_contains(request_uri, '"Grantee": {"URI": "http://acs.amazonaws.com/groups/global/AllUsers"}')
        or json_contains(request_uri, '"Grantee": {"URI": "http://acs.amazonaws.com/groups/global/AuthenticatedUsers"}')
      )
      and json_contains(request_uri, '"Permission": "FULL_CONTROL"')
    order by
      tp_timestamp desc;
  EOQ
}

detection "s3_bucket_public_access_block_disabled" {
  title           = "S3 Bucket Public Access Block Disabled"
  description     = "Detect when the public access block settings for an S3 bucket were disabled. Disabling public access blocks can expose data to unauthorized users, increasing security risks."
  documentation   = file("./detections/docs/s3_bucket_public_access_block_disabled.md")
  severity        = "high"
  display_columns = local.detection_display_columns
  query           = query.s3_bucket_public_access_block_disabled

  tags = merge(local.aws_s3_server_access_log_detections_common_tags, {
    mitre_attack_ids = "TA0005:T1070,TA0001:T1190"
  })
}

query "s3_bucket_public_access_block_disabled" {
  sql = <<-EOQ
    select
      ${local.detection_sql_columns}
    from
      aws_s3_server_access_log
    where
      operation = 'REST.PUT.PUBLICACCESSBLOCK'
      and (
        json_contains(request_uri, '"BlockPublicAcls": false')
        or json_contains(request_uri, '"IgnorePublicAcls": false')
        or json_contains(request_uri, '"BlockPublicPolicy": false')
        or json_contains(request_uri, '"RestrictPublicBuckets": false')
      )
    order by
      tp_timestamp desc;
  EOQ
}

detection "s3_bucket_versioning_disabled" {
  title           = "S3 Bucket Versioning Disabled"
  description     = "Detect when versioning was disabled on an S3 bucket. Disabling versioning can lead to data loss by preventing object recovery from unintended deletions or modifications."
  documentation   = file("./detections/docs/s3_bucket_versioning_disabled.md")
  severity        = "medium"
  display_columns = local.detection_display_columns
  query           = query.s3_bucket_versioning_disabled

  tags = merge(local.aws_s3_server_access_log_detections_common_tags, {
    mitre_attack_ids = "TA0040:T1485"
  })
}

query "s3_bucket_versioning_disabled" {
  sql = <<-EOQ
    select
      ${local.detection_sql_columns}
    from
      aws_s3_server_access_log
    where
      operation = 'REST.PUT.VERSIONING'
      and json_contains(request_uri, '"Status": "Suspended"')
    order by
      tp_timestamp desc;
  EOQ
}

detection "s3_bucket_encryption_disabled" {
  title           = "S3 Bucket Encryption Disabled"
  description     = "Detect when encryption was disabled on an S3 bucket. Disabling encryption can expose sensitive data to unauthorized access and may violate security compliance policies."
  documentation   = file("./detections/docs/s3_bucket_encryption_disabled.md")
  severity        = "medium"
  display_columns = local.detection_display_columns
  query           = query.s3_bucket_encryption_disabled

  tags = merge(local.aws_s3_server_access_log_detections_common_tags, {
    mitre_attack_ids = "TA0040:T1485"
  })
}

query "s3_bucket_encryption_disabled" {
  sql = <<-EOQ
    select
      ${local.detection_sql_columns}
    from
      aws_s3_server_access_log
    where
      operation = 'REST.PUT.ENCRYPTION'
      and json_contains(request_uri, '"SSEAlgorithm": null')
    order by
      tp_timestamp desc;
  EOQ
}

detection "s3_bucket_replication_disabled" {
  title           = "S3 Bucket Replication Disabled"
  description     = "Detect when replication was disabled on an S3 bucket. Disabling replication can affect data redundancy and disaster recovery strategies."
  documentation   = file("./detections/docs/s3_bucket_replication_disabled.md")
  severity        = "medium"
  display_columns = local.detection_display_columns
  query           = query.s3_bucket_replication_disabled

  tags = merge(local.aws_s3_server_access_log_detections_common_tags, {
    mitre_attack_ids = "TA0040:T1485"
  })
}

query "s3_bucket_replication_disabled" {
  sql = <<-EOQ
    select
      ${local.detection_sql_columns}
    from
      aws_s3_server_access_log
    where
      operation = 'REST.PUT.REPLICATION'
      and json_contains(request_uri, '"Status": "Disabled"')
    order by
      tp_timestamp desc;
  EOQ
}

detection "s3_bucket_logging_disabled" {
  title           = "S3 Bucket Logging Disabled"
  description     = "Detect when logging was disabled on an S3 bucket. Disabling logging can reduce visibility into bucket access and activity, impacting audit and security monitoring."
  documentation   = file("./detections/docs/s3_bucket_logging_disabled.md")
  severity        = "high"
  display_columns = local.detection_display_columns
  query           = query.s3_bucket_logging_disabled

  tags = merge(local.aws_s3_server_access_log_detections_common_tags, {
    mitre_attack_ids = "TA0005:T1070,TA0001:T1190"
  })
}

query "s3_bucket_logging_disabled" {
  sql = <<-EOQ
    select
      ${local.detection_sql_columns}
    from
      aws_s3_server_access_log
    where
      operation = 'REST.PUT.LOGGING'
      and json_contains(request_uri, '"LoggingEnabled": null')
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
      and (
        request_uri NOT LIKE '%x-amz-server-side-encryption=%'
        and request_uri NOT LIKE '%X-Amz-Server-Side-Encryption=%'
      )
    order by
      tp_timestamp desc;
  EOQ
}