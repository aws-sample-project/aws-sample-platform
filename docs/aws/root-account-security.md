# Root Account Security

## Overview

The AWS Root Account has unrestricted access to all AWS services and resources within the AWS account.

As a security best practice, the Root Account should only be used for account-level administrative tasks and emergency situations.

Daily administration must be performed using IAM Identity Center.

---

# Objective

Protect the AWS Root Account by enabling Multi-Factor Authentication (MFA) and defining a secure operational policy.

---

# Why This Matters

Compromising the Root Account means compromising the entire AWS account.

Unlike IAM identities, the Root Account cannot be restricted using IAM policies.

AWS strongly recommends securing the Root Account immediately after account creation.

---

# Implementation

## MFA

| Item | Value |
|------|-------|
| MFA Enabled | Yes |
| MFA Type | Authenticator App |
| Verified | Yes |

---

## Root Account Usage Policy

The Root Account should only be used for:

- Account creation
- Billing configuration
- Closing the AWS account
- Emergency recovery
- Account-level support cases

The Root Account must NOT be used for:

- Terraform
- AWS CLI
- GitHub Actions
- Daily AWS Console access
- Infrastructure provisioning

---

# Verification

The following verification steps were completed.

- Successfully signed in using MFA.
- Confirmed MFA status is Enabled.
- Verified Root Account credentials are stored securely.
- Confirmed future administration will use IAM Identity Center.

---

# Lessons Learned

- The Root Account bypasses IAM permissions.
- MFA is the first security control that should be enabled.
- Human users should authenticate through IAM Identity Center rather than the Root Account.
- Following AWS security best practices from the beginning simplifies future administration.

---

# References

- AWS IAM Best Practices
- AWS Root User Best Practices