## Overview

Detect when versioning was disabled on an Amazon S3 bucket. Disabling versioning removes the ability to recover previous versions of objects, increasing the risk of data loss due to accidental deletions or overwrites. Ensuring versioning remains enabled helps protect critical data and supports reliable backup and recovery strategies.

**References**:
- [Using Versioning in S3 Buckets](https://docs.aws.amazon.com/AmazonS3/latest/userguide/Versioning.html)
- [Best Practices for S3 Data Protection](https://docs.aws.amazon.com/AmazonS3/latest/userguide/data-protection.html)
- [AWS CLI Command: put-bucket-versioning](https://awscli.amazonaws.com/v2/documentation/api/latest/reference/s3api/put-bucket-versioning.html)
