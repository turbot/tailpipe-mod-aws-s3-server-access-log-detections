## Overview

Detect when an Amazon S3 bucket policy was modified to grant public access. Allowing public access by setting `"Principal": "*"` or `"Principal": {"AWS": "*"}` with `"Effect": "Allow"` exposes the bucket to all users, increasing the risk of data breaches, exfiltration, or malicious exploitation. Identifying and remediating these changes helps maintain data confidentiality and enforces least-privilege access principles.

**References**:
- [Bucket Policy Examples](https://docs.aws.amazon.com/AmazonS3/latest/userguide/example-bucket-policies.html)
- [Using Bucket Policies](https://docs.aws.amazon.com/AmazonS3/latest/userguide/using-iam-policies.html)
- [AWS CLI Command: put-bucket-policy](https://awscli.amazonaws.com/v2/documentation/api/latest/reference/s3api/put-bucket-policy.html)
