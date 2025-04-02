## Overview

Detect when encryption was disabled on an Amazon S3 bucket. Disabling bucket encryption increases the risk of storing data in plaintext, making it vulnerable to unauthorized access and potential data breaches. Identifying these changes ensures that all data at rest remains protected in accordance with security and compliance best practices.

**References**:
- [Protecting Data Using Server-Side Encryption](https://docs.aws.amazon.com/AmazonS3/latest/userguide/serv-side-encryption.html)
- [Setting Default Server-Side Encryption](https://docs.aws.amazon.com/AmazonS3/latest/userguide/bucket-encryption.html)
- [AWS CLI Command: put-bucket-encryption](https://awscli.amazonaws.com/v2/documentation/api/latest/reference/s3api/put-bucket-encryption.html)
