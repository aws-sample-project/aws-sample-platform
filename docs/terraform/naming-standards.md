# Terraform Naming Standards

## Overview

This document defines the naming conventions and coding standards used throughout the Terraform codebase.

The project follows a multi-environment repository structure, where each environment is implemented as an independent Terraform root module.

Consistent naming improves readability, maintainability, and collaboration while reducing configuration errors.

---

# Objective

Establish consistent naming conventions and repository standards for Terraform resources, variables, outputs, files, and deployment environments.

---

# Why This Matters

As infrastructure grows, inconsistent naming makes Terraform configurations difficult to understand and maintain.

Following common standards provides several benefits:

- Improved readability
- Consistent code organization
- Easier collaboration
- Simplified troubleshooting
- Better long-term maintainability

---

# Repository Naming Strategy

The Terraform repository is organized as follows:

```text
terraform/
├── README.md
│
├── environments/
│   ├── dev/
│   ├── staging/
│   └── production/
│
└── modules/
```

Each environment represents an independent Terraform root module.

Terraform commands are executed from within the target environment.

Example:

```bash
cd terraform/environments/dev

terraform init
terraform plan
terraform apply
```

---

# Terraform File Naming

Every environment follows the same Terraform file structure.

```text
backend.tf
versions.tf
providers.tf
variables.tf
terraform.tfvars
locals.tf
outputs.tf
main.tf
```

The repository contains a single `terraform/README.md` that documents the overall Terraform architecture and workflow.

Each file has a single responsibility.

| File | Responsibility |
|------|----------------|
| backend.tf | Configure the Terraform backend |
| versions.tf | Define Terraform and provider version requirements |
| providers.tf | Configure the AWS provider |
| variables.tf | Define input variables |
| terraform.tfvars | Store environment-specific values |
| locals.tf | Define reusable local values |
| outputs.tf | Export Terraform outputs |
| main.tf | Define infrastructure resources |

---

# Repository Evolution Strategy

Initially, each environment maintains its own Terraform configuration.

Infrastructure resources are implemented inside `main.tf`.

Example:

```text
terraform/
└── environments/
    └── dev/
        ├── backend.tf
        ├── providers.tf
        ├── versions.tf
        ├── variables.tf
        ├── terraform.tfvars
        ├── locals.tf
        ├── outputs.tf
        └── main.tf
```

As the infrastructure grows, resources may be split into dedicated files.

Example:

```text
main.tf
network.tf
ecs.tf
alb.tf
ecr.tf
monitoring.tf
```

Terraform automatically loads every `.tf` file within the current working directory.

Splitting files improves readability without changing Terraform behavior.

---

# Future Improvements

The `modules/` directory is reserved for reusable Terraform modules.

It is intentionally left unused during the early milestones.

Once the infrastructure contains reusable components shared across multiple environments, common resources may be extracted into modules.

Example:

```text
terraform/
├── environments/
│   ├── dev/
│   ├── staging/
│   └── production/
│
└── modules/
    ├── networking/
    ├── ecs/
    ├── ecr/
    ├── alb/
    └── monitoring/
```

The project intentionally prioritizes understanding Terraform fundamentals before introducing reusable modules and additional abstraction.

# Resource Naming

Terraform resource identifiers should describe the purpose of the resource rather than the AWS service.

Good examples:

```hcl
resource "aws_vpc" "main" {}

resource "aws_subnet" "public_a" {}

resource "aws_subnet" "public_b" {}

resource "aws_route_table" "public" {}

resource "aws_internet_gateway" "main" {}
```

Avoid:

```hcl
resource "aws_vpc" "vpc1" {}

resource "aws_subnet" "subnet1" {}

resource "aws_route_table" "route1" {}
```

---

# Variable Naming

Variables should:

- use lowercase letters
- use underscores (`_`)
- clearly describe their purpose

Examples:

```hcl
variable "project_name" {}

variable "environment" {}

variable "aws_region" {}

variable "vpc_cidr" {}

variable "public_subnet_a_cidr" {}

variable "public_subnet_b_cidr" {}
```

---

# Local Values

Reusable expressions should be defined using local values.

Example:

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

# Output Naming

Outputs should clearly describe the value they expose.

Examples:

```hcl
output "vpc_id" {}

output "public_subnet_a_id" {}

output "public_subnet_b_id" {}
```

---

# AWS Resource Naming

Terraform identifiers should remain simple.

AWS resource names should include the project name and deployment environment.

Example:

```hcl
tags = {
  Name = "${var.project_name}-${var.environment}-vpc"
}
```

Example resource names:

```text
aws-devops-project-dev-vpc

aws-devops-project-staging-vpc

aws-devops-project-production-vpc
```

---

# Resource Tags

All supported AWS resources should apply the common tagging strategy.

Minimum required tags:

| Tag | Description |
|------|-------------|
| Project | Project name |
| Environment | Deployment environment |
| ManagedBy | Terraform |
| Owner | Project owner |

---

# Future Improvements

Terraform modules are intentionally not introduced during the early stages of the project.

Once the infrastructure becomes larger and contains reusable components, common resources may be extracted into reusable Terraform modules.

The priority is to understand Terraform fundamentals before introducing additional abstraction.

---

# Verification

The following verification steps have been completed.

- Repository structure has been defined.
- Environment naming conventions have been documented.
- Terraform file responsibilities have been defined.
- Resource naming standards have been documented.
- Variable naming conventions have been documented.

---

# Lessons Learned

- Every deployment environment can function as an independent Terraform root module.
- Terraform automatically loads all `.tf` files within the current working directory.
- Clear naming standards improve collaboration and maintainability.
- Simplicity should be prioritized before introducing reusable modules.
- Repository structure should evolve together with the infrastructure.

---

# Screenshots

## Terraform Repository Structure

![Terraform Repository](../assets/terraform/repository-structure.png)

---

## Development Environment Structure

![Development Environment](../assets/terraform/dev-structure.png)

---

# References

- HashiCorp Terraform Documentation
- HashiCorp Terraform Style Guide
- Terraform CLI Documentation