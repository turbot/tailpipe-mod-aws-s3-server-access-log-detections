## Overview

Detect when replication was disabled for an Amazon S3 bucket. Disabling replication reduces data redundancy and may hinder disaster recovery capabilities, increasing the risk of data loss in the event of accidental deletions or service disruptions. Monitoring these changes ensures that critical data remains resilient and meets availability and compliance requirements.

**References**:
- [Replicating Objects Using S3 Replication](https://docs.aws.amazon.com/AmazonS3/latest/userguide/replication.html)
- [AWS CLI Command: put-bucket-replication](https://awscli.amazonaws.com/v2/documentation/api/latest/reference/s3api/put-bucket-replication.html)
