# AWS Resource Naming Convention

## Purpose

This standard defines how AWS resources created for AWS Platform are named. Consistent names make resources easier to identify, search, operate, review, and attribute to the correct environment.

The project display abbreviation is `AP`, meaning **AWS Platform**. AWS resource names use the lowercase project token `ap` for compatibility across services.

## Scope

This standard applies to new AWS resources managed by this repository in the `dev`, `staging`, and `production` environments.

Existing resources are not renamed only to comply with this standard. Renaming an existing resource must be handled as a separate change because some AWS resources are replaced when their names change.

## Standard Format

Use the following format unless an AWS service requires a different structure:

```text
ap-<environment>-<resource>[-<qualifier>]
```

| Component | Description | Allowed or example values |
|---|---|---|
| `ap` | Project token for AWS Platform | Fixed value: `ap` |
| `environment` | Deployment environment | `dev`, `staging`, `production` |
| `resource` | Short, recognizable resource type or function | `vpc`, `alb`, `ecs-cluster` |
| `qualifier` | Optional role, workload, Availability Zone suffix, or sequence | `app`, `public-a`, `01` |

Examples:

```text
ap-dev-vpc
ap-staging-alb
ap-production-ecs-cluster
ap-dev-subnet-public-a
```

## General Rules

1. Use lowercase letters, numbers, and hyphens for AWS resource names.
2. Separate name components with a single hyphen.
3. Start every project-owned, environment-specific resource name with `ap-<environment>-`.
4. Use only the approved environment values: `dev`, `staging`, and `production`.
5. Prefer short, recognizable resource identifiers such as `vpc`, `alb`, `sg`, and `tg`.
6. Add a qualifier only when it distinguishes the resource's role, workload, location, or sequence.
7. Prefer descriptive qualifiers such as `public-a` or `app` over a number. Use zero-padded numbers such as `01` only when no meaningful qualifier exists.
8. Do not include secrets, credentials, email addresses, personal data, or other sensitive values in names or tags.
9. Do not include the AWS account ID or Region unless required for uniqueness or operational clarity.
10. Observe the naming rules and length limit of the target AWS service. A service-specific rule takes precedence over the general format.
11. Keep names deterministic. Do not add random suffixes unless a resource requires global uniqueness.
12. Spell out an unfamiliar term instead of introducing an undocumented abbreviation.

## Approved Resource Identifiers

Use these identifiers consistently when they apply:

| Resource | Identifier |
|---|---|
| Virtual private cloud | `vpc` |
| Subnet | `subnet` |
| Route table | `rt` |
| Internet gateway | `igw` |
| Security group | `sg` |
| ECS cluster | `ecs-cluster` |
| ECS service | `service` |
| ECS task definition family | `task` |
| ECR repository | Workload name, such as `app` |
| Application Load Balancer | `alb` |
| Target group | `tg` |
| CloudWatch alarm | `alarm` |
| IAM role | `role` |
| IAM policy | `policy` |
| AWS Budget | `budget` |

New abbreviations must be added to this table before they are used broadly.

## Service Examples

### Networking

| Resource | Example |
|---|---|
| VPC | `ap-dev-vpc` |
| Public subnet in Availability Zone suffix `a` | `ap-dev-subnet-public-a` |
| Private subnet in Availability Zone suffix `a` | `ap-dev-subnet-private-a` |
| Public route table | `ap-dev-rt-public` |
| Internet gateway | `ap-dev-igw` |
| ALB security group | `ap-dev-sg-alb` |
| Application security group | `ap-dev-sg-app` |

Use an Availability Zone suffix such as `a` as a logical position only when the configured AWS Region is known from the environment. Do not embed a developer-specific Region in a reusable module.

### Amazon ECS and Amazon ECR

| Resource | Example |
|---|---|
| ECS cluster | `ap-dev-ecs-cluster` |
| ECS application service | `ap-dev-service-app` |
| ECS task definition family | `ap-dev-task-app` |
| ECR application repository | `ap-dev-app` |

### Elastic Load Balancing

| Resource | Example |
|---|---|
| Application Load Balancer | `ap-dev-alb` |
| Application target group | `ap-dev-tg-app` |

Load balancer and target group names have restrictive service length limits. Keep their qualifiers short and verify the final generated name before deployment.

### AWS Identity and Access Management

| Resource | Example |
|---|---|
| ECS task role | `ap-dev-role-ecs-task` |
| ECS task execution role | `ap-dev-role-ecs-execution` |
| ECS task policy | `ap-dev-policy-ecs-task` |

IAM names must describe the intended workload and responsibility. A name does not replace least-privilege policy design.

### Amazon CloudWatch

| Resource | Example |
|---|---|
| High CPU alarm | `ap-dev-alarm-app-high-cpu` |
| Application log group | `/aws/ecs/ap/dev/app` |

CloudWatch log groups use a service-oriented path because paths are easier to browse than a flat hyphenated name.

### AWS Systems Manager Parameter Store

Parameter Store names use a hierarchical path:

```text
/ap/<environment>/<workload>/<parameter>
```

Examples:

```text
/ap/dev/app/image-tag
/ap/staging/app/log-level
/ap/production/app/database-url
```

Parameter names may describe a secret's purpose but must never contain the secret value. Sensitive values must use an approved secure parameter type and access policy.

### AWS Budgets

Use an environment component only when a budget is environment-specific:

```text
ap-monthly-budget
ap-production-monthly-budget
```

The project-wide budget omits the environment because it covers the whole project.

### Globally Unique Names

Some resources, including Amazon S3 buckets, use a global namespace. Add only the components needed to make the name unique:

```text
ap-<environment>-tfstate-<account-id>-<region>
```

Example with placeholders:

```text
ap-dev-tfstate-123456789012-ap-southeast-1
```

Never copy a real account ID into documentation or reusable Terraform defaults. Obtain it from the active AWS identity or an AWS data source when a generated name requires it.

## Terraform Naming

Terraform identifiers are code identifiers and follow a different convention from AWS resource names:

- Use `snake_case` for resources, variables, locals, and outputs.
- Use `main` or `this` for the only resource of its type in a focused module.
- Use a meaningful role such as `public`, `private`, `alb`, or `application` when multiple resources of the same type exist.
- Do not repeat project and environment values in Terraform identifiers; those values belong in resource arguments and tags.

Example:

```hcl
locals {
  name_prefix = "ap-${var.environment}"
}

resource "aws_vpc" "main" {
  tags = merge(var.common_tags, {
    Name = "${local.name_prefix}-vpc"
  })
}

resource "aws_security_group" "alb" {
  name = "${local.name_prefix}-sg-alb"
}
```

## Resource Tags

Names contain only the information required for quick identification. Use tags for searchable operational and ownership metadata.

The following tags are required on supported project resources:

| Tag key | Required value or source | Example |
|---|---|---|
| `Project` | Project display abbreviation | `AP` |
| `Environment` | Approved environment value | `dev` |
| `ManagedBy` | Provisioning system | `Terraform` |
| `Name` | Canonical resource name, when supported | `ap-dev-vpc` |

Tag keys and approved values are case-sensitive. Apply common tags centrally through Terraform provider `default_tags` or shared locals where supported. Do not store sensitive or personally identifiable information in tags.

An `Owner` tag can be added after the project defines an approved team-based ownership value. Do not use a person's email address as the owner value.

## Exceptions

An exception is allowed when:

- the AWS service rejects the standard format;
- a strict length limit requires a shorter name;
- the resource requires a hierarchical path;
- the resource requires global uniqueness; or
- an AWS-managed resource controls its own name.

Document a material exception in the Terraform code or pull request. Preserve the `ap` project token and environment wherever the service permits them.

## Adoption and Review

- Apply this standard to new resources.
- Review generated names in `terraform plan` before deployment.
- Handle renaming or replacement of an existing resource in a dedicated issue with impact and rollback analysis.
- Update this document when a new environment, service, or approved abbreviation is introduced.
- Do not rename live resources manually when Terraform manages them.

## References

- [AWS Prescriptive Guidance: Terraform code structure and naming conventions](https://docs.aws.amazon.com/prescriptive-guidance/latest/terraform-aws-provider-best-practices/structure.html)
- [AWS Prescriptive Guidance: Define rules for applying tags](https://docs.aws.amazon.com/prescriptive-guidance/latest/cost-allocation-tagging/define-rules.html)
- [AWS: Best Practices for Tagging AWS Resources](https://docs.aws.amazon.com/whitepapers/latest/tagging-best-practices/)
- [AWS: Tagging best practices and strategies](https://docs.aws.amazon.com/tag-editor/latest/userguide/best-practices-and-strats.html)
- [AWS Prescriptive Guidance: Amazon S3 bucket naming FAQ](https://docs.aws.amazon.com/prescriptive-guidance/latest/defining-bucket-names-data-lakes/faq.html)
