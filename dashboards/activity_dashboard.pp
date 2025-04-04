dashboard "activity_dashboard" {

  title         = "S3 Server Access Logs Dashboard"
  documentation = file("./dashboards/docs/activity_dashboard.md")

  tags = {
    type    = "Dashboard"
    service = "AWS/S3"
  }

  container {

    # Analysis
    card {
      query = query.activity_dashboard_total_logs
      width = 2
    }

    card {
      query = query.activity_dashboard_error_rate
      width = 2
    }

    card {
      query = query.activity_dashboard_total_data_transferred
      width = 2
    }

  }

  container {

    chart {
      title = "Logs by Bucket"
      query = query.activity_dashboard_logs_by_bucket
      type  = "column"
      width = 6
    }

    chart {
      title = "Activity Over Time (Last 30 Days)"
      query = query.activity_dashboard_logs_over_time
      type  = "line"
      width = 6
    }

    chart {
      title = "Top 10 Requesters"
      query = query.activity_dashboard_logs_by_requester
      type  = "table"
      width = 6
    }

    chart {
      title = "Top 10 Source IPs (Excluding AWS Services and Internal)"
      query = query.activity_dashboard_logs_by_source_ip
      type  = "table"
      width = 6
    }

    chart {
      title = "Top 10 Operations"
      query = query.activity_dashboard_logs_by_operation
      type  = "table"
      width = 6
    }

    chart {
      title = "Top 10 Error Codes"
      query = query.activity_dashboard_logs_by_error
      type  = "table"
      width = 6
    }

  }

  container {
    
    chart {
      title = "Top 10 HTTP Status Codes"
      query = query.activity_dashboard_logs_by_status
      type  = "table"
      width = 6
    }

    chart {
      title = "Top 10 User Agents"
      query = query.activity_dashboard_logs_by_user_agent
      type  = "table"
      width = 6
    }
  }

}

# Query definitions

query "activity_dashboard_total_logs" {
  title       = "Log Count"
  description = "Count the total S3 server access log entries."

  sql = <<-EOQ
    select
      count(*) as "Total Logs"
    from
      aws_s3_server_access_log;
  EOQ

  tags = {
    folder = "S3"
  }
}

query "activity_dashboard_error_rate" {
  title       = "Error Rate"
  description = "Percentage of requests resulting in an error (non-2xx status)."

  sql = <<-EOQ
    select
      round(
        (count(*) filter (where http_status >= 400)::numeric / 
        nullif(count(*)::numeric, 0)) * 100,
        2
      ) as "Error Rate %"
    from
      aws_s3_server_access_log;
  EOQ

  tags = {
    folder = "S3"
  }
}

query "activity_dashboard_total_data_transferred" {
  title       = "Data Transferred"
  description = "Total bytes sent from S3."

  sql = <<-EOQ
    select
      sum(cast(bytes_sent as BIGINT)) as "Data Transferred"
    from
      aws_s3_server_access_log;
  EOQ

  tags = {
    folder = "S3"
  }
}

query "activity_dashboard_logs_by_source_ip" {
  title       = "Top 10 Source IPs (Excluding AWS Services and Internal)"
  description = "List the top 10 source IPs by frequency, excluding events from AWS services and internal."

  sql = <<-EOQ
    select
      tp_source_ip as "Source IP",
      count(*) as "Logs"
    from
      aws_s3_server_access_log
    where
      tp_source_ip != ''
      and requester not like 'svc:%'
      and requester not like '%AWSServiceRole%'
    group by
      tp_source_ip
    order by
      count(*) desc
    limit 10;
  EOQ

  tags = {
    folder = "S3"
  }
}

query "activity_dashboard_logs_by_requester" {
  title       = "Top 10 Requesters"
  description = "List the top 10 requesters by frequency."

  sql = <<-EOQ
    select
      requester as "Requester",
      count(*) as "Logs"
    from
      aws_s3_server_access_log
    where
      requester != '-'
    group by
      requester
    order by
      count(*) desc
    limit 10;
  EOQ

  tags = {
    folder = "S3"
  }
}

query "activity_dashboard_logs_by_operation" {
  title       = "Top 10 Operations"
  description = "List the top 10 S3 operations by frequency."

  sql = <<-EOQ
    select
      operation as "Operation",
      count(*) as "Logs"
    from
      aws_s3_server_access_log
    group by
      operation
    order by
      count(*) desc
    limit 10;
  EOQ

  tags = {
    folder = "S3"
  }
}

query "activity_dashboard_logs_by_error" {
  title       = "Top 10 Error Codes"
  description = "List the 10 most frequent error codes."

  sql = <<-EOQ
    select
      error_code as "Error Code",
      count(*) as "Logs"
    from
      aws_s3_server_access_log
    where
      error_code is not null
      and error_code != '-'
      and error_code != ''
    group by
      error_code
    order by
      count(*) desc
    limit 10;
  EOQ

  tags = {
    folder = "S3"
  }
}

query "activity_dashboard_logs_by_status" {
  title       = "Top 10 HTTP Status Codes"
  description = "List the 10 most frequent HTTP status codes returned."

  sql = <<-EOQ
    select
      http_status as "Status Code",
      count(*) as "Logs"
    from
      aws_s3_server_access_log
    group by
      http_status
    order by
      count(*) desc
    limit 10;
  EOQ

  tags = {
    folder = "S3"
  }
}

query "activity_dashboard_logs_by_user_agent" {
  title       = "Top 10 User Agents"
  description = "List the 10 most frequent user agents."

  sql = <<-EOQ
    select
      user_agent as "User Agent",
      count(*) as "Logs"
    from
      aws_s3_server_access_log
    where
      user_agent != '-'
    group by
      user_agent
    order by
      count(*) desc
    limit 10;
  EOQ

  tags = {
    folder = "S3"
  }
}

query "activity_dashboard_logs_by_bucket" {
  title       = "Logs by Bucket"
  description = "Count log entries grouped by bucket name."

  sql = <<-EOQ
    select
      bucket as "Bucket",
      count(*) as "Logs"
    from
      aws_s3_server_access_log
    group by
      bucket
    order by
      count(*) desc;
  EOQ

  tags = {
    folder = "S3"
  }
}

query "activity_dashboard_logs_over_time" {
  title       = "Activity Over Time (Last 30 Days)"
  description = "Count log entries grouped by day for the last 30 days, with more robust date handling."

  sql = <<-EOQ
    select
      cast(tp_timestamp as date) as "Date",
      count(*) as "Logs"
    from
      aws_s3_server_access_log
    where
      tp_timestamp >= current_date - interval '30 days'
    group by
      cast(tp_timestamp as date)
    order by
      "Date";
  EOQ

  tags = {
    folder = "S3"
  }
}