# AWS DevOps Portfolio Project Handbook

> Last Updated: YYYY-MM-DD

---

# 1. Project Overview

## Goal

Build a production-like AWS DevOps portfolio project that demonstrates the skills required for a Senior DevOps / Platform Engineer role.

The project focuses on modern DevOps practices including Infrastructure as Code, CI/CD, container orchestration, observability, security, and cost optimization.

---

## Target Duration

4 months

---

## Team

- Project Owner (Admin)
- Project Contributor

---

# 2. Project Scope

## In Scope

- AWS
- Terraform
- GitHub Actions
- Amazon ECS Fargate
- Amazon ECR
- Application Load Balancer
- CloudWatch
- IAM Identity Center
- AWS Budgets
- AWS Systems Manager Parameter Store
- Docker
- GitHub Projects
- GitHub Issues

## Out of Scope

- Amazon EKS
- Amazon RDS
- Redis
- Kafka
- OpenSearch
- Service Mesh
- Multi-account Landing Zone
- AWS Organizations
- WAF
- NAT Gateway (unless required)

---

# 3. AWS Account Strategy

A single AWS account will be used throughout the project.

## Access Model

- Root Account
- IAM Identity Center
- Permission Sets

Only the Project Owner has administrative responsibility.

The collaborator receives permissions through IAM Identity Center.

IAM Users should not be created unless absolutely required.

AWS CLI authentication should use IAM Identity Center (SSO).

---

# 4. Cost Management

Target monthly AWS cost:

20 USD

Maximum acceptable monthly cost:

30 USD

AWS Budgets must be configured before provisioning infrastructure.

---

# 5. Repository Strategy

Two repositories are maintained.

## Repository 1

Application Repository

Responsibilities

- Application source code
- Dockerfile
- GitHub Actions (Build)
- Container image publishing
- Security scanning
- SBOM generation

---

## Repository 2

Platform Repository

Responsibilities

- Terraform
- Infrastructure
- ECS
- IAM
- Monitoring
- Documentation
- ADRs
- GitHub Actions (Deployment)

---

# 6. Git Workflow

Branch Naming

feature/<description>

bugfix/<description>

docs/<description>

hotfix/<description>

One Issue = One Branch = One Pull Request

---

# 7. GitHub Project Workflow

Backlog

↓

Ready

↓

In Progress

↓

Review

↓

Done

---

# 8. Labels

## Type

type:feature

type:documentation

type:research

type:bug

---

## Priority

priority:high

priority:medium

priority:low

---

## Area

area:security

area:iam

area:terraform

area:ecs

area:ecr

area:github-actions

area:observability

area:cost

area:standards

---

# 9. Issue Convention

Every GitHub Issue should contain:

- Objective
- Background
- Scope
- Learning Outcome
- Requirements
- Acceptance Criteria
- Deliverables
- References

Issue metadata:

- Epic
- Milestone
- Labels
- Priority
- Dependencies
- Estimated Time

---

# 10. Pull Request Convention

Each Pull Request should

- reference the related Issue
- include a summary
- describe implementation details
- include validation results
- update documentation if required

---

# 11. Documentation Structure

docs/

├── architecture/

├── aws/

├── standards/

├── runbooks/

├── adr/

└── project-handbook.md

---

# 12. Project Milestones

## Milestone 1

AWS Foundation

- AWS Account Security
- IAM Identity Center
- AWS Budget
- Engineering Standards

---

## Milestone 2

Terraform Foundation

- Terraform project structure
- Backend
- State Management
- VPC
- Networking

---

## Milestone 3

Container Platform

- Amazon ECR
- ECS Cluster
- ECS Service
- Application Load Balancer

---

## Milestone 4

CI/CD

- GitHub Actions
- OIDC
- Build Pipeline
- Deployment Pipeline

---

## Milestone 5

Observability

- CloudWatch
- Logging
- Metrics
- Alarms

---

## Milestone 6

Production Readiness

- Security Hardening
- Cost Optimization
- Disaster Recovery
- Documentation
- Final Architecture Review

---

# 13. Definition of Done

A task is considered complete when:

- Implementation is completed.
- Acceptance Criteria are satisfied.
- Documentation is updated.
- Pull Request is merged.
- Issue is closed.

---

# 14. Architecture Principles

- Infrastructure as Code first.
- Immutable container images.
- Least privilege access.
- Secure by default.
- Cost-aware design.
- Production-like implementation.
- Simplicity over unnecessary complexity.

---

# 15. Learning Objective

The project should demonstrate practical experience with:

- AWS
- Terraform
- Docker
- GitHub Actions
- ECS
- IAM
- Observability
- CI/CD
- Infrastructure Design
- DevOps Best Practices

The outcome should be sufficient to support interviews for Senior DevOps / Platform Engineer positions.