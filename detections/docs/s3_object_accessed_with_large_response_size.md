## Overview

Detect when an Amazon S3 object was accessed and the response size exceeded 100MB. Large data transfers over S3 can be indicative of bulk data exfiltration, especially when occurring outside of normal access patterns or in combination with unusual requester identities or IP addresses.

Monitoring response sizes helps detect potential data leakage, abnormal automation behavior, or improper use of public or privileged access to retrieve significant volumes of information.

**References**:
- [Amazon S3 Server Access Logging](https://docs.aws.amazon.com/AmazonS3/latest/userguide/ServerLogs.html)
- [AWS Security Best Practices](https://docs.aws.amazon.com/wellarchitected/latest/security-pillar/security-pillar.html)

