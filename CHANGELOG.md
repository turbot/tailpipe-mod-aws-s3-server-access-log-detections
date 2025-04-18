## v0.2.0 [2025-04-18]

_What's new?_

- Added Top 10 Keys table to Activity Dashboard.

_Enhancements_

- Added missing bucket information to Top 10 URI tables in Activity Dashboard.
- Added link for collecting logs in Getting Started section in README and index documentation.

_Bug fixes_

- Added `folder = "S3"` tag to Activity Dashboard queries.

## v0.1.0 [2025-04-16]

_What's new?_

- New benchmarks added:
  - MITRE ATT&CK v16.1 benchmark (`powerpipe benchmark run aws_s3_server_access_log_detections.benchmark.mitre_attack_v161`).
  - S3 Server Access Log Detections benchmark (`powerpipe benchmark run aws_s3_server_access_log_detections.benchmark.s3_server_access_log_detections`).

- New dashboards added:
  - [S3 Server Access Log Activity Dashboard](https://hub.powerpipe.io/mods/turbot/tailpipe-mod-aws-s3-server-access-log-detections/dashboards/dashboard.activity_dashboard)
