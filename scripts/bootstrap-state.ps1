& (Join-Path $PSScriptRoot "localstack-up.ps1")
if ($LASTEXITCODE -ne 0) {
  exit $LASTEXITCODE
}

& (Join-Path $PSScriptRoot "tf.ps1") -chdir=bootstrap init -input=false
if ($LASTEXITCODE -ne 0) {
  exit $LASTEXITCODE
}

& (Join-Path $PSScriptRoot "tf.ps1") -chdir=bootstrap apply -auto-approve -input=false
exit $LASTEXITCODE
