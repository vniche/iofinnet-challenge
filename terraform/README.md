# terraform

This Terraform module provides a way to provision and manage a CloudFront backed by S3 (with Versioning and Server-Side Encryption - a.k.a. SSE).

## Summary

This module consists of the following sub-modules:

- bucket: provides a common way to manage S3 buckets with versioning and server-side encryption by default.
- cloudfront: provides a common way to manage CloudFront distributions backed by a provided (via variables) S3 bucket.
- iam: provides a least privileged set of policies to manage and use the resources managed by the above modules.

Where the process of the module can be reasoned in the the following way:

1. Operator (automated or manual) provides the required variables (only `buckets`).
2. A random UUID is generated to be used for buckets (as they are required to be unique across all AWS system).
3. The sub-module `buckets` creates an S3 bucket (with versioning and SSE) for each item of the variable `buckets`.
4. A simple HTML5 page is uploaded to the bucket with the name of the bucket as its title and content, for each item of the variable `buckets`.
5. A CloudFront Origin Access Control is created to support access control of S3 buckets.
6. The sub-module `cloudfront_distributions` creates a CloudFront Distribution backed by a respective S3 bucket, for each item of the variable `buckets`.
7. The sub-module `iam` creates two policies related to the managed resources:
    - CloudFrontS3PowerUserAccessPolicy: enables both write and read of the resources with the application and environment tags.
    - CloudFrontS3CICDPolicy: enables updating of S3 buckets contents and creation of invalidation of CloudFront distributions, which is the least a pipeline needs to release updates to a distribution.
