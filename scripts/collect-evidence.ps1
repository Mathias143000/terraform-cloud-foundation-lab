$repoRoot = Resolve-Path (Join-Path $PSScriptRoot "..")
$evidenceDir = Join-Path $repoRoot "artifacts\\evidence\\latest"
New-Item -ItemType Directory -Force -Path $evidenceDir | Out-Null

Push-Location $repoRoot
try {
  & docker compose run --rm awscli --endpoint-url http://localstack:4566 s3 ls | Out-File -Encoding utf8 (Join-Path $evidenceDir "s3-state-buckets.txt")
  & docker compose run --rm awscli --endpoint-url http://localstack:4566 dynamodb describe-table --table-name terraform-cloud-foundation-locks | Out-File -Encoding utf8 (Join-Path $evidenceDir "dynamodb-lock-table.json")
  & docker compose run --rm terraform -chdir=bootstrap output -json | Out-File -Encoding utf8 (Join-Path $evidenceDir "bootstrap-outputs.json")
  & docker compose run --rm terraform -chdir=environments/dev output -json | Out-File -Encoding utf8 (Join-Path $evidenceDir "dev-outputs.json")
  & docker compose run --rm terraform -chdir=environments/stage output -json | Out-File -Encoding utf8 (Join-Path $evidenceDir "stage-outputs.json")
  & docker compose run --rm terraform -chdir=environments/demo output -json | Out-File -Encoding utf8 (Join-Path $evidenceDir "demo-outputs.json")
  & docker compose run --rm terraform -chdir=environments/dev state list | Out-File -Encoding utf8 (Join-Path $evidenceDir "dev-state-list.txt")
  & docker compose run --rm terraform -chdir=environments/stage state list | Out-File -Encoding utf8 (Join-Path $evidenceDir "stage-state-list.txt")
  & docker compose run --rm terraform -chdir=environments/demo state list | Out-File -Encoding utf8 (Join-Path $evidenceDir "demo-state-list.txt")
  & docker compose exec -T postgres-dev pg_isready -U appuser | Out-File -Encoding utf8 (Join-Path $evidenceDir "postgres-dev-ready.txt")
  & docker compose exec -T postgres-stage pg_isready -U appuser | Out-File -Encoding utf8 (Join-Path $evidenceDir "postgres-stage-ready.txt")
  & docker compose exec -T postgres-demo pg_isready -U appuser | Out-File -Encoding utf8 (Join-Path $evidenceDir "postgres-demo-ready.txt")
}
finally {
  Pop-Location
}
