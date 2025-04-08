## Overview

Detect when an Amazon S3 object was accessed and the request size exceeded 10MB. Large request sizes can indicate scripted or automated bulk downloads that may be part of a data scraping or exfiltration attempt.

While response size is often used to detect data transfers, unusually large request payloads or headers may also be signs of misuse, such as attempts to manipulate large objects, invoke custom behaviors, or exhaust system resources.

**References**:
- [Amazon S3 Server Access Logging](https://docs.aws.amazon.com/AmazonS3/latest/userguide/ServerLogs.html)
- [Amazon S3 Monitoring Metrics](https://docs.aws.amazon.com/AmazonS3/latest/userguide/monitoring-overview.html)