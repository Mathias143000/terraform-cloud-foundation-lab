param(
  [Parameter(Mandatory = $true)]
  [ValidateSet("dev", "stage", "demo")]
  [string]$Environment
)

& (Join-Path $PSScriptRoot "bootstrap-state.ps1")
if ($LASTEXITCODE -ne 0) {
  exit $LASTEXITCODE
}

& (Join-Path $PSScriptRoot "tf.ps1") "-chdir=environments/$Environment" init -input=false -reconfigure "-backend-config=backend.hcl"
if ($LASTEXITCODE -ne 0) {
  exit $LASTEXITCODE
}

& (Join-Path $PSScriptRoot "tf.ps1") "-chdir=environments/$Environment" apply -auto-approve -input=false
exit $LASTEXITCODE
