param(
  [Parameter(Mandatory = $true)]
  [ValidateSet("dev", "stage", "demo")]
  [string]$Environment
)

& (Join-Path $PSScriptRoot "tf.ps1") "-chdir=environments/$Environment" init -input=false -reconfigure "-backend-config=backend.hcl"
if ($LASTEXITCODE -ne 0) {
  exit $LASTEXITCODE
}

& (Join-Path $PSScriptRoot "tf.ps1") "-chdir=environments/$Environment" destroy -auto-approve -input=false
exit $LASTEXITCODE
