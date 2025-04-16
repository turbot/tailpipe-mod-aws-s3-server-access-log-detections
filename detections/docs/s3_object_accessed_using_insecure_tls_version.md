## Overview

Detect when an Amazon S3 object was accessed using a deprecated or insecure TLS version such as TLS 1.0 or TLS 1.1. These older versions of TLS lack modern cryptographic protections and are susceptible to known vulnerabilities and downgrade attacks. Continued use of deprecated protocols increases the risk of man-in-the-middle attacks and data exposure.

Monitoring and eliminating use of insecure TLS versions ensures data transmitted to and from S3 remains encrypted using up-to-date and secure protocols.

**References**:
- [AWS Security Blog: TLS deprecation for AWS APIs](https://aws.amazon.com/blogs/security/tls-1-2-required-for-aws-endpoints/)
- [NIST Guidelines on TLS](https://csrc.nist.gov/publications/detail/sp/800-52/rev-2/final)
