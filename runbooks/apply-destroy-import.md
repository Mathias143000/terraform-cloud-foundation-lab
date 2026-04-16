# Apply, Destroy, and Import Runbook

## Apply flow

1. Start LocalStack and bootstrap the remote state:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\bootstrap-state.ps1
```

2. Validate formatting, backend initialization, and plans:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\validate.ps1
```

3. Apply one environment:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\apply-env.ps1 -Environment dev
```

4. Promote the same module set through `stage` into `demo`:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\apply-env.ps1 -Environment stage
powershell -ExecutionPolicy Bypass -File .\scripts\apply-env.ps1 -Environment demo
```

## Destroy flow

Destroy the workload environment first, then the higher environment if needed.

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\destroy-env.ps1 -Environment demo
powershell -ExecutionPolicy Bypass -File .\scripts\destroy-env.ps1 -Environment stage
powershell -ExecutionPolicy Bypass -File .\scripts\destroy-env.ps1 -Environment dev
```

The bootstrap state bucket and lock table are intentionally left in place so the collaboration workflow still exists after workload teardown.

## Import note

This lab does not require import for the happy path, but the import workflow is still documented because it is a common operational task:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\tf.ps1 -chdir=environments/dev import module.compute.aws_instance.app i-1234567890
```

After import:

1. Run `plan`.
2. Reconcile drift in code instead of editing state manually.

## Drift and reconciliation notes

- Drift should be treated as an engineering signal, not hidden with `ignore_changes`.
- The demo proves that remote state and locking exist, but the right next step is still `plan -> review -> apply`.
- If drift is intentional, update the module or tfvars and re-apply.
- If drift is accidental, converge the infrastructure back through Terraform.
- LocalStack exposes a false-positive diff on `aws_instance.vpc_security_group_ids` because it leaves the top-level EC2 `SecurityGroups` response empty while still attaching the group on the primary network interface. Treat that one as an emulator limitation, not as unmanaged production drift.

## Known failure modes

- LocalStack may take a few extra seconds to initialize on cold start.
- Backend initialization fails if bootstrap has not yet created the S3 bucket and DynamoDB table.
- Destroy order matters if you want to preserve evidence and state.
- Local database endpoints are backed by `postgres-dev`, `postgres-stage`, and `postgres-demo`, not by a real RDS emulator.
