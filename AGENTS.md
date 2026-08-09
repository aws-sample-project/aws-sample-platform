# AGENTS.md

## Purpose

This repository is the source of truth for the project's AWS platform and infrastructure. Work in this repository primarily involves Terraform, AWS services, AWS CLI operations, IAM, networking, container infrastructure, observability, CI/CD, security, cost management, and supporting documentation.

These instructions apply to the entire repository.

## Project Context

- The platform targets a single AWS account with separate `dev`, `staging`, and `production` Terraform environments.
- Human access uses AWS IAM Identity Center and temporary credentials. Do not create IAM users or long-lived access keys unless an issue explicitly requires and justifies them.
- The current project handbook is authoritative for platform scope. The current target uses Amazon ECS Fargate, Amazon ECR, an Application Load Balancer, Amazon VPC, CloudWatch, IAM, Systems Manager Parameter Store, AWS Budgets, and GitHub Actions.
- Amazon EKS, Amazon RDS, Redis, Kafka, OpenSearch, service mesh, multi-account landing zones, AWS Organizations, WAF, and NAT Gateway are currently out of scope unless an issue explicitly changes the scope.
- The target monthly AWS cost is USD 20, with USD 30 as the maximum acceptable monthly cost. Prefer simple, low-cost designs and explain meaningful cost implications.
- Some Terraform and operational files are placeholders. Do not assume an empty file represents an implemented component.

When documentation conflicts, use this order of precedence:

1. The current issue and its acceptance criteria
2. This `AGENTS.md`
3. `docs/project-handbook.md`
4. Service-specific documents under `docs/`
5. The top-level `README.MD`

Call out unresolved conflicts instead of silently choosing a materially different architecture.

## Repository Layout

- `terraform/modules/`: reusable Terraform modules
- `terraform/environments/`: environment-specific root modules and state configuration
- `scripts/`: operational and Terraform helper scripts
- `policies/`: IAM and GitHub Actions policy documents
- `docs/`: architecture, security, deployment, operations, and AWS foundation documentation
- `.github/`: repository ownership, pull request templates, and automation

Keep reusable resource logic in `terraform/modules/`. Keep environment composition and environment-specific values in `terraform/environments/<environment>/`.

## Working Principles

- Read the relevant issue, documentation, and nearby Terraform files before editing.
- Make the smallest coherent change that satisfies the issue and its acceptance criteria.
- Preserve unrelated user changes and do not rewrite files outside the task's scope.
- Prefer infrastructure as code over manual console changes.
- If a manual AWS operation is unavoidable, document why it is needed, the exact steps, and how the resulting state is represented or reconciled in Terraform.
- Use secure-by-default, least-privilege, cost-aware designs.
- Do not deploy, apply, destroy, import, move state, modify remote state, or mutate live AWS resources unless the user explicitly authorizes that action.
- Treat production, IAM, networking, state, data, and security changes as high-impact work.

## Terraform Standards

### Structure and Naming

- Use a consistent resource naming pattern: `<project>-<environment>-<resource>`.
- Use `snake_case` for Terraform identifiers, variables, locals, and outputs.
- Give variables and outputs clear descriptions and explicit types.
- Add validation blocks for important constraints when useful.
- Use locals for shared naming, tags, and derived values.
- Avoid unnecessary abstraction. Create or extend a module when logic is genuinely reusable.
- Keep provider configuration in environment root modules, not reusable child modules.
- Pin Terraform and provider versions using compatible, intentional constraints. Commit dependency lock files when Terraform generates them for an environment.

### Security and State

- Never commit credentials, access keys, secret values, private keys, real `.tfvars` files, state files, plan files, or crash logs.
- Mark outputs containing sensitive information as `sensitive = true`, but do not rely on that flag as secret storage.
- Store application secrets and sensitive configuration in an approved AWS service such as Systems Manager Parameter Store or Secrets Manager, according to project scope.
- Use a separate remote state for each environment.
- Enable state locking and encryption when remote state is implemented.
- Do not add broad IAM permissions such as `Action = "*"` or `Resource = "*"` without a documented service requirement and explicit justification.
- Do not expose resources publicly by default. Any public ingress must be narrowly scoped and documented.
- Prefer encryption at rest and in transit, private networking where practical, and restrictive security group rules.

### Tags

Apply consistent tags to supported resources. At minimum, use project and environment tags; include ownership and Terraform-management tags when the surrounding configuration defines them. Centralize common tags through provider `default_tags` or shared locals rather than duplicating them.

### Environment Separation

- Do not copy production-only values into development or staging.
- Do not share state between environments.
- Put example values in `terraform.tfvars.example`; never add real account-specific or secret values to Git.
- Make production safeguards explicit, including deletion protection, retention, and approval expectations where applicable.

## AWS CLI Standards

- Use AWS CLI v2 and IAM Identity Center/SSO profiles for human access.
- Before any authorized AWS action, verify the selected identity and region with read-only commands such as:

  ```bash
  aws sts get-caller-identity --profile <profile>
  aws configure get region --profile <profile>
  ```

- Pass `--profile` and `--region` explicitly when ambiguity could affect the target account or region.
- Prefer read-only inspection commands while diagnosing.
- Never print, copy, or commit credentials or secret parameter values.
- Do not use `--no-verify-ssl`, disable security controls, or bypass approval mechanisms.
- For mutating commands, state the target account, region, environment, and expected impact before execution and obtain explicit authorization.
- Capture useful non-sensitive verification evidence for documentation or pull requests.

## Validation

Run validation appropriate to the change. For Terraform changes, normally run from the relevant environment or module:

```bash
terraform fmt -check -recursive
terraform init -backend=false
terraform validate
```

Also run when available and relevant:

- `terraform plan` with safe, non-secret inputs
- Terraform linting
- security and policy scanning
- shell linting for scripts
- JSON validation for IAM policy documents

Do not claim a check passed unless it was run successfully. If validation cannot run because configuration, credentials, backend access, variables, providers, or tooling are unavailable, report the exact limitation and any checks that did run.

Do not run `terraform apply` or `terraform destroy` merely to test a change.

## Shell Scripts

- Write portable Bash for files under `scripts/` unless the project explicitly adopts another shell.
- Start new Bash scripts with `#!/usr/bin/env bash` and `set -euo pipefail`.
- Quote variable expansions and validate environment arguments.
- Require explicit confirmation for destructive operations and make the selected environment obvious.
- Do not embed AWS account IDs, credentials, secrets, or developer-specific absolute paths.

## Documentation

- Update documentation when behavior, architecture, permissions, prerequisites, costs, deployment steps, or operational procedures change.
- Keep `README.MD`, `docs/project-handbook.md`, architecture documentation, and implemented Terraform aligned.
- Document assumptions, dependencies, security implications, expected cost, validation, rollback, and manual prerequisites when relevant.
- Prefer commands that can be copied safely, using placeholders for account IDs, profiles, regions, resource names, and secrets.
- Do not include sensitive AWS console screenshots or identifiers without redaction.

## Git and Pull Requests

- Follow the project convention: one issue, one branch, one pull request.
- Use branch names such as `feature/<description>`, `bugfix/<description>`, `docs/<description>`, or `hotfix/<description>` unless the user requests another convention.
- Do not commit, push, or open a pull request unless the user asks.
- Keep commits focused and do not include generated Terraform state or plan artifacts.
- Pull request notes should include the related issue, summary, implementation details, validation evidence, risk, affected environments/resources, cost impact, and a concrete rollback procedure.
- Follow `.github/CODEOWNERS` and `.github/pull_request_template.md`.

## Completion Checklist

Before considering infrastructure work complete, confirm as applicable:

- The issue's acceptance criteria are satisfied.
- Terraform is formatted and validated.
- Plans or other verification results were reviewed without exposing secrets.
- IAM permissions follow least privilege.
- Public access and security group rules are intentional.
- State and environment boundaries remain intact.
- Cost implications are acceptable and documented.
- Documentation and examples are current.
- Rollback steps are specific and verifiable.
- No credentials, secrets, state, plan files, or unrelated changes are included.
