& (Join-Path $PSScriptRoot "bootstrap-state.ps1")
if ($LASTEXITCODE -ne 0) {
  exit $LASTEXITCODE
}

& (Join-Path $PSScriptRoot "tf.ps1") fmt -check -recursive
if ($LASTEXITCODE -ne 0) {
  exit $LASTEXITCODE
}

$environments = @("dev", "stage", "demo")

foreach ($environment in $environments) {
  & (Join-Path $PSScriptRoot "tf.ps1") "-chdir=environments/$environment" init -input=false -reconfigure "-backend-config=backend.hcl"
  if ($LASTEXITCODE -ne 0) {
    exit $LASTEXITCODE
  }

  & (Join-Path $PSScriptRoot "tf.ps1") "-chdir=environments/$environment" validate
  if ($LASTEXITCODE -ne 0) {
    exit $LASTEXITCODE
  }

  & (Join-Path $PSScriptRoot "tf.ps1") "-chdir=environments/$environment" plan -input=false -out=tfplan
  if ($LASTEXITCODE -ne 0) {
    exit $LASTEXITCODE
  }
}
