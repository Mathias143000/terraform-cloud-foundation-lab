# Terraform Hardening

This lab stays LocalStack-first, but the second hardening wave adds repo-local policy checks around the infrastructure model.

## What Is Covered

- security group administrative ingress is environment-scoped instead of open to the world
- sensitive Terraform variables are marked as `sensitive`
- every environment root keeps remote-backend files present
- CI runs a deterministic hardening policy check before apply/plan validation
- Trivy config scan remains part of the CI security story

## Local Validation

```powershell
python scripts\hardening_check.py
powershell -ExecutionPolicy Bypass -File .\scripts\validate.ps1
```

The hardening check writes a local report to:

```text
artifacts/hardening/hardening-report.json
```

The report is intentionally ignored by Git. It is evidence for local runs, not source code.

## Admin Ingress Model

The app security group still demonstrates HTTP exposure for a demo app host, but SSH/admin access is no longer represented as `0.0.0.0/0`.

Each environment now declares its own admin CIDR:

- `dev`: `10.40.0.0/16`
- `stage`: `10.50.0.0/16`
- `demo`: `10.60.0.0/16`

This is not claiming a full enterprise network model. It is a clear guardrail that prevents accidentally widening administrative ingress while preserving a runnable lab.

## Remaining Backlog

- SOPS-managed tfvars or secret material
- scheduled drift detection against a persistent environment
- real AWS cost and IAM boundary notes
- stronger policy-as-code through OPA/Conftest or Terraform Cloud/Enterprise policy sets
