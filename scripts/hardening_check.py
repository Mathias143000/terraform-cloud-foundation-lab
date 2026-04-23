from __future__ import annotations

import json
import re
import sys
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
ENVIRONMENTS = ("dev", "stage", "demo")


def read(path: Path) -> str:
    return path.read_text(encoding="utf-8")


def fail(errors: list[str], message: str) -> None:
    errors.append(message)


def contains_sensitive_marker(text: str, variable_name: str) -> bool:
    pattern = rf'variable\s+"{re.escape(variable_name)}"\s+{{[^}}]*sensitive\s*=\s*true'
    return re.search(pattern, text, re.DOTALL) is not None


def main() -> int:
    errors: list[str] = []

    security_module = read(ROOT / "modules" / "security" / "main.tf")
    if 'description = "SSH"' not in security_module:
        fail(errors, "security module no longer documents the SSH ingress rule")
    if 'cidr_blocks = var.admin_cidr_blocks' not in security_module:
        fail(errors, "SSH ingress must use var.admin_cidr_blocks instead of a hardcoded public CIDR")

    security_variables = read(ROOT / "modules" / "security" / "variables.tf")
    if 'variable "admin_cidr_blocks"' not in security_variables:
        fail(errors, "security module must expose admin_cidr_blocks")

    ci = read(ROOT / ".github" / "workflows" / "ci.yml")
    for marker in ["Hardening policy check", "scripts/hardening_check.py", "Trivy config scan"]:
        if marker not in ci:
            fail(errors, f"CI is missing hardening marker: {marker}")

    for environment in ENVIRONMENTS:
        env_dir = ROOT / "environments" / environment
        variables = read(env_dir / "variables.tf")
        tfvars = read(env_dir / "terraform.tfvars")
        main_tf = read(env_dir / "main.tf")

        for required in ["backend.tf", "backend.hcl", "providers.tf", "main.tf"]:
            if not (env_dir / required).exists():
                fail(errors, f"{environment} is missing {required}")

        if not contains_sensitive_marker(variables, "db_password"):
            fail(errors, f"{environment} db_password must be marked sensitive")
        if not contains_sensitive_marker(variables, "aws_secret_key"):
            fail(errors, f"{environment} aws_secret_key must be marked sensitive")
        if 'variable "admin_cidr_blocks"' not in variables:
            fail(errors, f"{environment} must define admin_cidr_blocks")
        if "admin_cidr_blocks" not in tfvars:
            fail(errors, f"{environment} tfvars must set admin_cidr_blocks")
        if "admin_cidr_blocks = var.admin_cidr_blocks" not in main_tf:
            fail(errors, f"{environment} must pass admin_cidr_blocks into the security module")

    report = {
        "status": "failed" if errors else "passed",
        "checks": [
            "security module avoids public SSH ingress",
            "sensitive variables marked in all environments",
            "remote backend files present for all environments",
            "environment-scoped admin CIDRs are explicit",
            "CI runs the hardening policy check and Trivy config scan",
        ],
        "errors": errors,
    }
    output_dir = ROOT / "artifacts" / "hardening"
    output_dir.mkdir(parents=True, exist_ok=True)
    (output_dir / "hardening-report.json").write_text(json.dumps(report, indent=2), encoding="utf-8")

    if errors:
        for error in errors:
            print(f"ERROR: {error}", file=sys.stderr)
        return 1

    print("Terraform hardening checks passed.")
    print(f"Report: {output_dir / 'hardening-report.json'}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
