mod "aws_s3_server_access_log_detections" {
  # hub metadata
  title         = "AWS S3 Server Access Log Detections"
  description   = "Run detections and view dashboards for your AWS S3 server access logs to monitor and analyze activity across your S3 buckets using Powerpipe and Tailpipe."
  color         = "#FF9900"
  # documentation = file("./docs/index.md")
  icon          = "/images/mods/turbot/aws-s3-server-access-log-detections.svg"
  categories    = ["aws", "dashboard", "detections", "public cloud"]
  database      = var.database

  opengraph {
    title       = "Powerpipe Mod for AWS S3 Server Access Log Detections"
    description = "Run detections and view dashboards for your AWS S3 server access logs to monitor and analyze activity across your S3 buckets using Powerpipe and Tailpipe."
    image       = "/images/mods/turbot/aws-s3-server-access-log-detections-social-graphic.png"
  }
}
