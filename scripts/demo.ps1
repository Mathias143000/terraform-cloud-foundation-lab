& (Join-Path $PSScriptRoot "validate.ps1")
if ($LASTEXITCODE -ne 0) {
  exit $LASTEXITCODE
}

& (Join-Path $PSScriptRoot "apply-env.ps1") -Environment dev
if ($LASTEXITCODE -ne 0) {
  exit $LASTEXITCODE
}

& (Join-Path $PSScriptRoot "apply-env.ps1") -Environment demo
if ($LASTEXITCODE -ne 0) {
  exit $LASTEXITCODE
}

& (Join-Path $PSScriptRoot "collect-evidence.ps1")
exit $LASTEXITCODE
