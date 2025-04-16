## Overview

Detect when an Amazon S3 object was uploaded without server-side encryption. Uploading unencrypted data increases the risk of unauthorized access and may violate data protection and compliance requirements. Ensuring that all uploaded objects are encrypted helps protect data at rest and supports secure storage practices.

**References**:
- [Protecting Data Using Server-Side Encryption](https://docs.aws.amazon.com/AmazonS3/latest/userguide/serv-side-encryption.html)
- [Amazon S3 Data Protection](https://docs.aws.amazon.com/AmazonS3/latest/userguide/data-protection.html)
- [AWS CLI Command: put-object](https://awscli.amazonaws.com/v2/documentation/api/latest/reference/s3api/put-object.html)
