# AWS Resource Tagging Strategy

## Purpose

This standard defines how AWS Platform resources are tagged to support resource identification, ownership, environment separation, operations, automation, and cost allocation.

Resource names provide quick visual identification. Tags provide structured metadata that can be searched, governed, and used in AWS billing reports. Both must be applied consistently.

## Scope

This standard applies to all new, taggable AWS resources managed by this repository in the `dev`, `staging`, and `production` environments.

AWS-managed resources and resource types that do not support tags are exceptions. The exception must be recorded during code review when the missing tags could affect ownership, operations, security, or cost reporting.

## Mandatory Tags

Apply the following tags to every supported project resource:

| Tag key | Required value | Purpose | Example |
|---|---|---|---|
| `Project` | Approved project identifier | Groups resources and costs by project | `AP` |
| `Environment` | `dev`, `staging`, or `production` | Identifies the deployment lifecycle environment | `dev` |
| `Owner` | Accountable team or role | Identifies who operates and maintains the resource | `PlatformTeam` |
| `ManagedBy` | Approved provisioning system | Identifies how changes must be made | `Terraform` |

The approved project identifier is `AP`, meaning **AWS Platform**.

### Conditional Name Tag

Add the `Name` tag when the AWS resource supports it and the tag improves identification in the AWS Management Console:

| Tag key | Value | Example |
|---|---|---|
| `Name` | Canonical resource name | `ap-dev-vpc` |

The `Name` tag is not a replacement for the mandatory tags. Resources such as security groups, subnets, and VPCs should normally have both a service name and a matching `Name` tag.

## Tag Key Rules

1. Use the exact PascalCase keys defined in this document. Tag keys are case-sensitive, so `Environment` and `environment` are different tags.
2. Use consistent spelling and approved values. Do not mix aliases such as `prod` and `production`.
3. Do not create user-defined tag keys with the reserved `aws:` prefix.
4. Do not place credentials, secrets, tokens, email addresses, personal data, or other sensitive information in tag keys or values. Tags are not secret storage.
5. Keep values concise, stable, and suitable for automation.
6. Use a team or operational role for `Owner`; do not use the name or email address of an individual.
7. Do not encode metadata such as owner or cost classification only in the resource name. Store that information in tags.
8. Observe the tag character and length rules of the target AWS service.
9. Avoid duplicate concepts. Extend this standard before introducing a new tag that overlaps an existing key.

## Approved Values

### Project

| Value | Meaning |
|---|---|
| `AP` | AWS Platform |

### Environment

| Value | Meaning |
|---|---|
| `dev` | Development and infrastructure testing |
| `staging` | Pre-production validation |
| `production` | Production workloads |

Environment values must match the corresponding Terraform environment. Production resources must not use a shortened or non-approved value such as `prod`.

### Owner

| Value | Meaning |
|---|---|
| `PlatformTeam` | Team accountable for the AWS platform infrastructure |

Add a new team value to this table before using it. Ownership must remain valid when individual team members change.

### ManagedBy

| Value | Meaning |
|---|---|
| `Terraform` | Resource lifecycle is managed through Terraform |
| `AWS` | Resource is automatically created and managed by an AWS service |
| `Manual` | Approved exception that is not yet represented in infrastructure as code |

`Terraform` is the default for resources created by this repository. `Manual` requires a documented justification, owner, reconciliation plan, and approval because infrastructure as code is preferred.

## Optional Tags

Optional tags are added only when they serve a defined operational, financial, or security purpose:

| Tag key | Purpose | Example |
|---|---|---|
| `Application` | Identifies the workload using the resource | `sample-app` |
| `CostCenter` | Maps spend to an approved financial owner | `platform` |
| `DataClassification` | Describes the sensitivity of processed or stored data | `Internal` |
| `Backup` | Indicates whether an approved backup policy applies | `Required` |

Optional values must be documented and consistently applied before they are used for automation or access control. Do not add tags without a consumer or management purpose.

## Tagging Examples

### Common Terraform Tags

Define shared tags once and apply them consistently:

```hcl
locals {
  common_tags = {
    Project     = "AP"
    Environment = var.environment
    Owner       = "PlatformTeam"
    ManagedBy   = "Terraform"
  }
}
```

Environment-specific values should come from the environment root module rather than a reusable child module.

### Resource-Specific Name Tag

```hcl
resource "aws_vpc" "main" {
  tags = merge(local.common_tags, {
    Name = "ap-${var.environment}-vpc"
  })
}
```

### Provider Default Tags

Where supported by the AWS provider and target resource type, apply mandatory tags centrally from the environment root module:

```hcl
provider "aws" {
  region = var.aws_region

  default_tags {
    tags = local.common_tags
  }
}
```

Provider default tags reduce duplication but do not remove the need to review the final tags in `terraform plan`. Some resources, generated child resources, or service integrations can require explicit tags or tag propagation settings.

### Service Examples

| AWS resource | Example tags |
|---|---|
| VPC | `Project=AP`, `Environment=dev`, `Owner=PlatformTeam`, `ManagedBy=Terraform`, `Name=ap-dev-vpc` |
| Public subnet | `Project=AP`, `Environment=dev`, `Owner=PlatformTeam`, `ManagedBy=Terraform`, `Name=ap-dev-subnet-public-a` |
| ECR repository | `Project=AP`, `Environment=dev`, `Owner=PlatformTeam`, `ManagedBy=Terraform`, `Application=sample-app` |
| ECS cluster | `Project=AP`, `Environment=staging`, `Owner=PlatformTeam`, `ManagedBy=Terraform`, `Name=ap-staging-ecs-cluster` |
| Application Load Balancer | `Project=AP`, `Environment=production`, `Owner=PlatformTeam`, `ManagedBy=Terraform`, `Name=ap-production-alb` |
| CloudWatch log group | `Project=AP`, `Environment=production`, `Owner=PlatformTeam`, `ManagedBy=Terraform`, `Application=sample-app` |
| IAM role | `Project=AP`, `Environment=dev`, `Owner=PlatformTeam`, `ManagedBy=Terraform` |
| SSM parameter | `Project=AP`, `Environment=dev`, `Owner=PlatformTeam`, `ManagedBy=Terraform`, `Application=sample-app` |

## Cost Allocation

The `Project` and `Environment` tags provide the minimum dimensions for separating AWS Platform costs. `Owner` and an approved `CostCenter` can provide additional accountability when needed.

User-defined cost allocation tags must be activated in AWS Billing and Cost Management before they appear as dimensions in cost reports. Activation is a separate account-level operation and is not performed by this documentation change. Activation does not automatically populate historical reports. If historical attribution is required, assess AWS Billing backfill support; only tag values that existed on resources during the requested period can be included.

The team should use cost reports to identify:

- total AWS Platform spend;
- spend by environment;
- untagged or incorrectly tagged resources; and
- resources whose costs do not have a clear owner.

## Operations and Automation

Tags can support inventory searches, operational dashboards, maintenance workflows, backup selection, and attribute-based access control. A tag must not be used for destructive automation or access control until its allowed values, enforcement, and failure behavior have been reviewed.

The `ManagedBy` tag defines the expected change path:

- `ManagedBy=Terraform`: change the resource through Terraform, not manually in the console.
- `ManagedBy=AWS`: manage the parent AWS service or configuration that owns the resource.
- `ManagedBy=Manual`: follow the documented exception and reconciliation plan.

## Enforcement and Review

For every Terraform change:

1. Define mandatory tags in shared locals or provider default tags.
2. Add resource-specific tags such as `Name` or `Application` where appropriate.
3. Review `terraform plan` to confirm tags are present and values match the target environment.
4. Treat missing or misspelled mandatory tags as a review failure unless a documented exception applies.
5. Verify that no sensitive values are exposed in tags or plan output.

AWS Organizations tag policies are not required for the project's current single-account scope. Automated policy enforcement can be introduced in a separate issue if the project scope changes. Until then, Terraform composition, validation, pull request review, and periodic inventory checks are the enforcement mechanisms.

## Exceptions

An exception is permitted when:

- the AWS resource type does not support tags;
- the resource is created and fully managed by AWS;
- tags cannot be propagated to a generated child resource; or
- a service limitation prevents a required key or value.

Document the affected resource, unsupported tags, operational impact, owner, and mitigation in the Terraform code or pull request. An exception must not be used merely to avoid updating Terraform.

Existing resources should be brought into compliance through reviewed Terraform changes. Do not modify production tags manually or create resources solely to test tagging.

## Security Considerations

- Tags are visible through multiple AWS APIs and billing tools and must be treated as non-confidential metadata.
- Never store secrets, credentials, personal information, or private customer data in tags.
- Review tag-based permissions carefully because changing a tag can change access when attribute-based access control is enabled.
- Restrict tag mutation permissions when tags are used for security or automation decisions.
- Use approved, team-based ownership values instead of personal identifiers.

## References

- [AWS: Best Practices for Tagging AWS Resources](https://docs.aws.amazon.com/whitepapers/latest/tagging-best-practices/)
- [AWS: Tagging best practices and strategies](https://docs.aws.amazon.com/tag-editor/latest/userguide/best-practices-and-strats.html)
- [AWS Prescriptive Guidance: Define a tagging dictionary](https://docs.aws.amazon.com/prescriptive-guidance/latest/cost-allocation-tagging/define-tagging-dictionary.html)
- [AWS Prescriptive Guidance: Apply tags](https://docs.aws.amazon.com/prescriptive-guidance/latest/cost-allocation-tagging/apply-tags.html)
- [AWS Billing: Activating user-defined cost allocation tags](https://docs.aws.amazon.com/awsaccountbilling/latest/aboutv2/activating-tags.html)
- [AWS Billing: Backfill cost allocation tags](https://docs.aws.amazon.com/awsaccountbilling/latest/aboutv2/cost-allocation-backfill.html)
