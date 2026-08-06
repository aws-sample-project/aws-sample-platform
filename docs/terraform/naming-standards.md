# Terraform Naming Standards

## Overview

This document defines the naming conventions and coding standards used throughout the Terraform codebase.

Consistent naming improves readability, maintainability, and collaboration while reducing configuration errors.

These standards apply to all Terraform resources created in this project.

---

# Objective

Establish a consistent naming convention for Terraform resources, variables, outputs, files, and local values.

---

# Why This Matters

As the infrastructure grows, inconsistent naming can make Terraform code difficult to understand and maintain.

Following a standard naming convention provides several benefits:

- Improved readability
- Consistent code structure
- Easier collaboration
- Simplified troubleshooting
- Better scalability

---

# Naming Principles

- Use lowercase letters only.
- Use underscores (`_`) instead of hyphens (`-`) for Terraform identifiers.
- Use descriptive names.
- Keep names concise and meaningful.
- Follow HashiCorp Terraform Style Guide recommendations.

---

# Resource Naming

Terraform resource labels should describe the purpose of the resource rather than the AWS service.

## Good Examples

```hcl
resource "aws_vpc" "main" {}

resource "aws_subnet" "public_a" {}

resource "aws_subnet" "public_b" {}

resource "aws_route_table" "public" {}

resource "aws_internet_gateway" "main" {}
```

## Avoid

```hcl
resource "aws_vpc" "vpc1" {}

resource "aws_subnet" "subnet1" {}

resource "aws_subnet" "test" {}
```

---

# Variable Naming

Variables should:

- use lowercase
- use underscores
- clearly describe their purpose

## Good Examples

```hcl
variable "aws_region" {}

variable "project_name" {}

variable "vpc_cidr" {}

variable "public_subnet_a_cidr" {}

variable "public_subnet_b_cidr" {}
```

---

# Output Naming

Outputs should clearly describe the value being exported.

## Good Examples

```hcl
output "vpc_id" {}

output "public_subnet_a_id" {}

output "public_subnet_b_id" {}
```

---

# Local Values

Local values should describe reusable expressions.

## Example

```hcl
locals {
  common_tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}
```

---

# File Organization

Terraform configuration should be organized by responsibility.

Example:

```text
terraform/
├── backend.tf
├── providers.tf
├── versions.tf
├── variables.tf
├── outputs.tf
├── locals.tf
├── network.tf
├── terraform.tfvars.example
└── README.md
```

---

# Resource Tags

All supported AWS resources should use a common tagging strategy.

Example:

```hcl
tags = local.common_tags
```

The common tags should include:

| Tag | Description |
|------|-------------|
| Project | Project name |
| Environment | Deployment environment |
| ManagedBy | Terraform |
| Owner | Team owner |

---

# Module Naming

Although Terraform Modules are not introduced in the current milestone, future modules should follow these naming conventions.

Examples:

```text
modules/

network/

ecs/

alb/

ecr/

monitoring/
```

---

# Naming Examples

| Resource | Terraform Name |
|-----------|----------------|
| VPC | main |
| Public Subnet A | public_a |
| Public Subnet B | public_b |
| Internet Gateway | main |
| Route Table | public |
| ECS Cluster | main |
| ALB | public |
| Security Group | alb |

---

# Verification

The following verification steps have been completed:

- Naming conventions have been documented.
- Naming examples have been provided.
- File organization has been defined.
- Terraform identifiers follow HashiCorp recommendations.

---

# Lessons Learned

- Consistent naming improves long-term maintainability.
- Descriptive resource names are easier to understand than generic names.
- Separating Terraform configuration by responsibility keeps the project organized.
- A shared naming standard reduces confusion when multiple contributors work on the same infrastructure.

---

# Screenshots

## Terraform Project Structure

![Terraform Project Structure](../assets/terraform/project-structure.png)

---

## Terraform Repository

![Terraform Repository](../assets/terraform/repository-structure.png)

---

## Example Terraform Resources

![Terraform Resources](../assets/terraform/resource-naming-example.png)

---

# References

- HashiCorp Terraform Style Guide
- Terraform Language Documentation