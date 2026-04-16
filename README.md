# terraform-cloud-foundation-lab

Focused AWS Terraform showcase with reusable modules, remote state, and three reproducible environments. The lab keeps the provider scope fixed to AWS while using LocalStack and Dockerized Terraform so the whole flow is runnable without a host-level Terraform install.

Important trade-off: LocalStack Community does not implement `RDS`, so the local demo uses three PostgreSQL containers as environment-specific stand-ins while Terraform still models the `RDS PostgreSQL` contract and keeps the AWS module boundaries intact.

## What this project shows

- AWS provider with one clear demo scope: `network + IAM + one app host + RDS PostgreSQL + remote state`
- reusable Terraform modules
- remote state in `S3` with locking in `DynamoDB`
- three environment roots: `dev`, `stage`, and `demo`
- environment promotion through separate folders and tfvars
- Docker-based Terraform workflow for local reproducibility
- CI validation and Terraform security scan

## Fixed technology axis

- Provider: `AWS`
- IaC: `Terraform`
- Local runtime: `Docker Compose + LocalStack + PostgreSQL stand-ins`
- Remote state: `S3 + DynamoDB`
- Managed data dependency: `RDS PostgreSQL`
- Security workflow: `Trivy config scan`

## Repository layout

```text
.
|-- bootstrap/
|-- modules/
|-- environments/
|-- scripts/
|-- docs/
`-- runbooks/
```

## Quick demo flow

1. Start LocalStack and bootstrap remote state:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\bootstrap-state.ps1
```

2. Validate all environments:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\validate.ps1
```

3. Apply `dev`, `stage`, and `demo`:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\apply-env.ps1 -Environment dev
powershell -ExecutionPolicy Bypass -File .\scripts\apply-env.ps1 -Environment stage
powershell -ExecutionPolicy Bypass -File .\scripts\apply-env.ps1 -Environment demo
```

4. Collect evidence for the portfolio:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\collect-evidence.ps1
```

5. Tear an environment down:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\destroy-env.ps1 -Environment demo
```

## Demo scenarios

- `terraform apply -> environment ready`
- promotion through environment folders: `dev -> stage -> demo`
- remote state collaboration flow via shared state bucket and lock table
- destroy and recreate environments reproducibly, with the known LocalStack EC2 security-group diff called out in the runbook

## Architecture

See [docs/architecture.md](docs/architecture.md) for the diagram and dependency wiring.

## Runbook

See [runbooks/apply-destroy-import.md](runbooks/apply-destroy-import.md) for apply, destroy, import, and drift notes.

## Operational evidence

The evidence bundle is written to `artifacts/evidence/latest/` and includes:

- S3 state bucket listing
- DynamoDB lock table description
- bootstrap outputs
- `dev`, `stage`, and `demo` outputs
- Terraform state listings for all three environments
- PostgreSQL readiness checks for `dev`, `stage`, and `demo`

## Known limitations

- The lab uses LocalStack to emulate AWS, so resource behavior is close to AWS but not identical.
- `EC2` is created through LocalStack, while `RDS PostgreSQL` is represented through a Terraform contract plus three local PostgreSQL stand-ins because Community LocalStack does not implement RDS APIs.
- LocalStack currently returns the app instance security groups through the attached network interface but leaves the top-level EC2 `SecurityGroups` list empty, so Terraform shows a repeatable in-place diff on `vpc_security_group_ids` after `plan`. This is an emulator quirk, not an unresolved module dependency.
- Secrets are demo-safe values inside tfvars because the lab is meant to be runnable without external secret stores.
- The repo demonstrates remote state and environment promotion locally; production cloud rollout would still require a real AWS account.

## Backlog / future improvements

- Add `SOPS`-managed secrets instead of plain demo tfvars
- Add a small user-data bootstrap with `cloud-init` validation
- Add cost notes for the real AWS version of the same design
- Extend CI with drift-detection scheduled job
