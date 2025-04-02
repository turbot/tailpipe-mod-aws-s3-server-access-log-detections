## Overview

Detect when an Amazon S3 bucket ACL was modified to grant public access. Public ACLs—especially those granting `FULL_CONTROL` to `AllUsers` or `AuthenticatedUsers`—can expose sensitive data to the internet, increasing the risk of data breaches and data exfiltration. Identifying and remediating such changes helps ensure buckets remain private and compliant with security best practices.

**References**:
- [Access Control List (ACL) Overview](https://docs.aws.amazon.com/AmazonS3/latest/userguide/acl-overview.html)
- [Controlling Access with ACLs](https://docs.aws.amazon.com/AmazonS3/latest/userguide/ManagingBucketAccess.html)
- [AWS CLI Command: put-bucket-acl](https://awscli.amazonaws.com/v2/documentation/api/latest/reference/s3api/put-bucket-acl.html)
