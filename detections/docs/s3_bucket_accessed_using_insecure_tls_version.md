## Overview

Detect when an Amazon S3 bucket was accessed using an insecure or deprecated TLS version such as TLS 1.0 or TLS 1.1. These older protocols are known to have cryptographic weaknesses and are no longer considered secure for transmitting sensitive data.

Accessing S3 buckets over insecure TLS can expose control plane requests (like listing objects or modifying settings) to interception or downgrade attacks. Enforcing modern TLS versions helps ensure data-in-transit confidentiality and integrity.

**References**:
- [Amazon S3 and Transport Layer Security (TLS)](https://docs.aws.amazon.com/AmazonS3/latest/userguide/TransportLayerSecurity.html)
- [AWS guidance on TLS 1.2 requirement](https://aws.amazon.com/blogs/security/tls-1-2-required-for-aws-endpoints/)
- [NIST Special Publication 800-52 Rev. 2](https://csrc.nist.gov/publications/detail/sp/800-52/rev-2/final)