$repoRoot = Resolve-Path (Join-Path $PSScriptRoot "..")

Push-Location $repoRoot
try {
  & docker compose up -d localstack postgres-dev postgres-stage postgres-demo
  if ($LASTEXITCODE -ne 0) {
    exit $LASTEXITCODE
  }

  & (Join-Path $PSScriptRoot "wait-localstack.ps1")
  if ($LASTEXITCODE -ne 0) {
    exit $LASTEXITCODE
  }

  $postgresServices = @("postgres-dev", "postgres-stage", "postgres-demo")
  foreach ($service in $postgresServices) {
    $ready = $false
    foreach ($attempt in 1..30) {
      & docker compose exec -T $service pg_isready -U appuser | Out-Null
      if ($LASTEXITCODE -eq 0) {
        $ready = $true
        break
      }
      Start-Sleep -Seconds 2
    }

    if (-not $ready) {
      Write-Error "$service did not become ready."
      exit 1
    }
  }
}
finally {
  Pop-Location
}
