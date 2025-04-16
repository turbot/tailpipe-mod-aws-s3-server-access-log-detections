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
      query = query.activity_dashboard_total_requests
      width = 2
    }

    card {
      query = query.activity_dashboard_success_count
      width = 2
      type  = "ok"
    }

    card {
      query = query.activity_dashboard_redirect_count
      width = 2
      type  = "info"
    }

    card {
      query = query.activity_dashboard_client_error_count
      width = 2
      type  = "alert"
    }

    card {
      query = query.activity_dashboard_server_error_count
      width = 2
      type  = "alert"
    }
  }

  container {

    chart {
      title = "Requests by Day"
      query = query.activity_dashboard_requests_by_day
      type  = "line"
      width = 6
    }

    chart {
      title = "Requests by Bucket"
      query = query.activity_dashboard_requests_by_bucket
      type  = "column"
      width = 6
    }

    chart {
      title = "Requests by Status Code"
      query = query.activity_dashboard_requests_by_status_category
      type  = "pie"
      width = 6
    }

    chart {
      title = "Top 10 URLs"
      query = query.activity_dashboard_top_10_urls
      type  = "table"
      width = 6
    }

    chart {
      title = "Top 10 Operations"
      query = query.activity_dashboard_requests_by_operation
      type  = "table"
      width = 6
    }

    chart {
      title = "Top 10 Error Codes"
      query = query.activity_dashboard_requests_by_error
      type  = "table"
      width = 6
    }

    chart {
      title = "Top 10 Requesters"
      query = query.activity_dashboard_requests_by_requester
      type  = "table"
      width = 6
    }

    chart {
      title = "Top 10 Source IPs"
      query = query.activity_dashboard_requests_by_source_ip
      type  = "table"
      width = 6
    }

    chart {
      title = "Top 10 URLs (Successful Requests)"
      query = query.activity_dashboard_top_10_successful_urls
      type  = "table"
      width = 6
    }

    chart {
      title = "Top 10 URLs (Errors)"
      query = query.activity_dashboard_top_10_error_urls
      type  = "table"
      width = 6
    }
  }

}

# Query definitions

query "activity_dashboard_total_requests" {
  title       = "Request Count"
  description = "Count the total S3 server access requests."

  sql = <<-EOQ
    select
      count(*) as "Total Requests"
    from
      aws_s3_server_access_log;
  EOQ

  tags = {
    folder = "S3"
  }
}

query "activity_dashboard_success_count" {
  title       = "Successful Request Count"
  description = "Count of successful HTTP requests (status 2xx)."

  sql = <<-EOQ
    select
      count(*) as "Successful (2xx)"
    from
      aws_s3_server_access_log
    where
      http_status between 200 and 299;
  EOQ

  tags = {
    folder = "S3"
  }
}

query "activity_dashboard_redirect_count" {
  title       = "Redirect Request Count"
  description = "Count of redirect HTTP requests (status 3xx)."

  sql = <<-EOQ
    select
      count(*) as "Redirections (3xx)"
    from
      aws_s3_server_access_log
    where
      http_status between 300 and 399;
  EOQ

  tags = {
    folder = "S3"
  }
}

query "activity_dashboard_client_error_count" {
  title       = "Client Error Count"
  description = "Count of client error HTTP requests (status 4xx)."

  sql = <<-EOQ
    select
      count(*) as "Client Errors (4xx)"
    from
      aws_s3_server_access_log
    where
      http_status between 400 and 499;
  EOQ

  tags = {
    folder = "S3"
  }
}

query "activity_dashboard_server_error_count" {
  title       = "Server Error Count"
  description = "Count of server error HTTP requests (status 5xx)."

  sql = <<-EOQ
    select
      count(*) as "Server Errors (5xx)"
    from
      aws_s3_server_access_log
    where
      http_status between 500 and 599;
  EOQ

  tags = {
    folder = "S3"
  }
}

query "activity_dashboard_requests_by_source_ip" {
  title       = "Top 10 Source IPs"
  description = "List the top 10 source IPs by request count."

  sql = <<-EOQ
    select
      tp_source_ip as "Client IP",
      count(*) as "Request Count"
    from
      aws_s3_server_access_log
    where
      tp_source_ip != ''
    group by
      tp_source_ip
    order by
      count(*) desc,
      tp_source_ip
    limit 10;
  EOQ

  tags = {
    folder = "S3"
  }
}

query "activity_dashboard_requests_by_requester" {
  title       = "Top 10 Requesters"
  description = "List the top 10 requesters by frequency."

  sql = <<-EOQ
    select
      requester as "Requester",
      count(*) as "Request Count"
    from
      aws_s3_server_access_log
    where
      requester != '-'
    group by
      requester
    order by
      count(*) desc,
      requester
    limit 10;
  EOQ

  tags = {
    folder = "S3"
  }
}

query "activity_dashboard_requests_by_operation" {
  title       = "Top 10 Operations"
  description = "List the top 10 S3 operations by frequency."

  sql = <<-EOQ
    select
      operation as "Operation",
      count(*) as "Request Count"
    from
      aws_s3_server_access_log
    group by
      operation
    order by
      count(*) desc,
      operation
    limit 10;
  EOQ

  tags = {
    folder = "S3"
  }
}

query "activity_dashboard_requests_by_error" {
  title       = "Top 10 Error Codes"
  description = "List the 10 most frequent error codes."

  sql = <<-EOQ
    select
      error_code as "Error Code",
      count(*) as "Request Count"
    from
      aws_s3_server_access_log
    where
      error_code is not null
      and error_code != '-'
      and error_code != ''
    group by
      error_code
    order by
      count(*) desc,
      error_code
    limit 10;
  EOQ

  tags = {
    folder = "S3"
  }
}

query "activity_dashboard_requests_by_status_category" {
  title       = "Requests by Status Code Category"
  description = "Count of requests grouped by HTTP status code category."

  sql = <<-EOQ
    select
      case
        when http_status between 200 and 299 then '2xx Success'
        when http_status between 300 and 399 then '3xx Redirect'
        when http_status between 400 and 499 then '4xx Client Error'
        when http_status between 500 and 599 then '5xx Server Error'
        else 'Other'
      end as "Status Category",
      count(*) as "Request Count"
    from
      aws_s3_server_access_log
    where
      http_status is not null
    group by
      "Status Category"
    order by
      "Status Category";
  EOQ

  tags = {
    folder = "S3"
  }
}

query "activity_dashboard_top_10_urls" {
  title       = "Top 10 URLs"
  description = "List the top 10 requested URLs by request count."

  sql = <<-EOQ
    select
      key as "URL",
      count(*) as "Request Count"
    from
      aws_s3_server_access_log
    where
      key != '-'
    group by
      key
    order by
      count(*) desc,
      key
    limit 10;
  EOQ

  tags = {
    folder = "S3"
  }
}

query "activity_dashboard_top_10_successful_urls" {
  title       = "Top 10 URLs (Successful Requests)"
  description = "List the top 10 requested URLs by successful request count."

  sql = <<-EOQ
    select
      key as "URL",
      count(*) as "Request Count",
      string_agg(distinct http_status::text, ', ' order by http_status::text) as "Status Codes"
    from
      aws_s3_server_access_log
    where
      http_status between 200 and 299
      and key != '-'
    group by
      key
    order by
      count(*) desc,
      key
    limit 10;
  EOQ

  tags = {
    folder = "S3"
  }
}

query "activity_dashboard_top_10_error_urls" {
  title       = "Top 10 URLs (Errors)"
  description = "List the top 10 requested URLs by error count."

  sql = <<-EOQ
    select
      key as "URL",
      count(*) as "Error Count",
      string_agg(distinct http_status::text, ', ' order by http_status::text) as "Status Codes"
    from
      aws_s3_server_access_log
    where
      http_status between 400 and 599
      and key != '-'
    group by
      key
    order by
      count(*) desc,
      key
    limit 10;
  EOQ

  tags = {
    folder = "S3"
  }
}

query "activity_dashboard_requests_by_bucket" {
  title       = "Requests by Bucket"
  description = "Count requests grouped by bucket name."

  sql = <<-EOQ
    select
      bucket as "Bucket",
      count(*) as "Request Count"
    from
      aws_s3_server_access_log
    group by
      bucket
    order by
      count(*) desc,
      bucket;
  EOQ

  tags = {
    folder = "S3"
  }
}

query "activity_dashboard_requests_by_day" {
  title       = "Requests by Day"
  description = "Count requests grouped by day."

  sql = <<-EOQ
    select
      cast(tp_timestamp as date) as "Date",
      count(*) as "Request Count"
    from
      aws_s3_server_access_log
    group by
      cast(tp_timestamp as date)
    order by
      "Date";
  EOQ

  tags = {
    folder = "S3"
  }
}