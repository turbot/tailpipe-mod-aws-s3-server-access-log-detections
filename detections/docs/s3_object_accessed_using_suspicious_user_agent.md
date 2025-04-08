## Overview

Detect when an Amazon S3 object was accessed using a suspicious user-agent string such as `curl`, `python`, or `bot`. These user agents are often associated with automated scripts, command-line tools, or scraping bots and may indicate unauthorized or non-standard access methods.

Monitoring user-agent patterns helps identify abnormal or automated behavior that could lead to data exfiltration, unauthorized access, or abuse of exposed public content.

**References**:
- [Amazon S3 Server Access Logging](https://docs.aws.amazon.com/AmazonS3/latest/userguide/ServerLogs.html)
- [Understanding and analyzing user agents](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/User-Agent)
- [AWS Security Best Practices](https://docs.aws.amazon.com/wellarchitected/latest/security-pillar/security-pillar.html)

