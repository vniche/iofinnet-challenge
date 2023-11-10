# iofinnet-challenge

## Terraform Assessment

Scenario:

A project aims to deploy a web application infrastructure on AWS through Terraform. This application requires setups across three distinct environments: development, staging, and production. Your challenge involves crafting Terraform code that fulfills the given criteria, while maintaining industry best practices in security, scalability, and code structure.

Requirements:

Your task is to create Terraform code that establishes CloudFront distributions, utilizing separate Amazon S3 buckets to direct static content for each environment: dev, staging, and prod. The specific configurations are outlined below:

Development Environment:

- /auth >> Bucket1_dev
- /info >> Bucket2_dev
- /customers >> Bucket3_dev

Staging Environment:

- /auth >> Bucket1_staging
- /info >> Bucket2_staging
- /customers >> Bucket3_staging

Production Environment:

- /auth >> Bucket1_prod
- /info >> Bucket2_prod
- /customers >> Bucket3_prod

Make sure that each S3 bucket adheres to versioning and server-side encryption standards using Terraform. Furthermore, implement Terraform code to establish CloudFront distributions, each directed towards its respective S3 bucket and configured for the appropriate paths:

Development Environment:

- /auth >> CloudFront_Distribution1_dev
- /info >> CloudFront_Distribution2_dev
- /customers >> CloudFront_Distribution3_dev

Staging Environment:

- /auth >> CloudFront_Distribution1_staging
- /info >> CloudFront_Distribution2_staging
- /customers >> CloudFront_Distribution3_staging

Production Environment:

- /auth >> CloudFront_Distribution1_prod
- /info >> CloudFront_Distribution2_prod
- /customers >> CloudFront_Distribution3_prod

Additionally, your Terraform code should define customized IAM policies and roles for S3 bucket and CloudFront distribution access. Uphold the principle of least privilege while designing IAM roles.

To enhance maintainability and reusability, structure your Terraform code with modules. Employ variables and outputs to parameterize your configuration effectively.

Evaluation Criteria:

- Best Practices: Demonstrated adherence to security and scalability best practices, ensuring that the code is production-ready.
- S3 Implementation: Accurate implementation of S3 bucket versioning and encryption through Terraform.
- Modularity: Effective use of Terraform modules for improved code organization and reusability.
- Documentation: Clearly documented design decisions, assumptions, and rationale.
- CloudFront Configurations: Successful setup of CloudFront distributions, with distinct paths (/auth, /info, /customers) for hosting diverse static content tailored to each environment.

## Ansible Assessment

Scenario:

A project's app development phase has concluded, and they're ready to deploy their app image to two environments: dev and staging. The app image comes with specific requirements and configurations for each environment. Your task is to deploy three instances of the app image on two instances (hosts) using Ansible, while adhering to production best practices.

Requirements:

Deploy three instances of the app image on each host (dev:host1, staging:host2) using Docker Compose.
Ensure that each app instance meets the following criteria:

- Requires 1GB of RAM and 0.3 cores
- Needs 5GB of storage to run efficiently
- Exposes an API on port 8181
- Utilizes a consistent storage volume (secret-keys-volume) that persists across restarts

Configure the instances according to the provided environment-specific properties and settings:

Dev Configuration:

- Tuning: true
- Debug: true
- External URL: "<https://dev/approve>"
- Client: "dev_client_external"
- Interaction Mode: "API"
- Device ID: 2346456

Staging Configuration:

- Tuning: true
- Debug: false
- External URL: "<https://staging/approve>"
- Client: "staging_client_external"
- Interaction Mode: "API"
- Device ID: 32443532

Ensure that all app instances are reachable from the local environment on their respective ports.
Write the Ansible code following best practices for both Ansible and production deployment.

Evaluation Criteria:

- Best Practices: Demonstrated adherence to best practices in security and scalability, ensuring that the Ansible code aligns with production standards.
- Deployment: Successful deployment of three instances of the application on dev:host1 and staging:host2 using Docker Compose.
- Resource Fulfillment: Ensuring that each app instance satisfies the specified resource requirements and environment configurations.
- Storage Management: Proper establishment of a consistent storage volume (secret-keys-volume) for the app instances, maintaining data integrity across restarts.
- Accessibility: Verification that all app instances are accessible from the local environment through their designated ports.
- Ansible Proficiency: Utilization of Ansible best practices, including a well-structured playbook and clearly defined tasks.
- Dynamic Configuration: Skillful use of templates for dynamic configuration within the Ansible playbook.
- Documentation: Provision of comprehensive documentation that offers insights into design choices, assumptions, and code organization.
- Production Considerations: Thoughtful consideration of production best practices, encompassing aspects of security, scalability, and maintainability in the Ansible deployment.
