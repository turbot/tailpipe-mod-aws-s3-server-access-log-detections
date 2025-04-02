## Overview

Detect when public access block settings were disabled for an Amazon S3 bucket. Disabling settings such as `BlockPublicAcls`, `IgnorePublicAcls`, `BlockPublicPolicy`, or `RestrictPublicBuckets` can expose bucket data to unauthorized users. Monitoring these changes is critical for preventing accidental data exposure and maintaining secure access controls.

**References**:
- [Using Amazon S3 Block Public Access](https://docs.aws.amazon.com/AmazonS3/latest/userguide/access-control-block-public-access.html)
- [AWS CLI Command: put-public-access-block](https://awscli.amazonaws.com/v2/documentation/api/latest/reference/s3control/put-public-access-block.html)
