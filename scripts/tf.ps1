param(
  [Parameter(ValueFromRemainingArguments = $true)]
  [string[]]$TerraformArgs
)

$repoRoot = Resolve-Path (Join-Path $PSScriptRoot "..")

Push-Location $repoRoot
try {
  & docker compose run --rm terraform @TerraformArgs
  if ($LASTEXITCODE -ne 0) {
    exit $LASTEXITCODE
  }
}
finally {
  Pop-Location
}
