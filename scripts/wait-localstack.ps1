param(
  [int]$TimeoutSeconds = 90
)

$deadline = (Get-Date).AddSeconds($TimeoutSeconds)
$healthUrl = "http://127.0.0.1:4566/_localstack/health"

while ((Get-Date) -lt $deadline) {
  try {
    $response = Invoke-RestMethod -Uri $healthUrl -TimeoutSec 5
    $s3Ready = $response.services.s3 -in @("running", "available")
    $dynamoReady = $response.services.dynamodb -in @("running", "available")
    $hasReadyServices = $s3Ready -and $dynamoReady
    if ($hasReadyServices) {
      Write-Host "LocalStack is ready."
      exit 0
    }
  }
  catch {
    Start-Sleep -Seconds 2
    continue
  }

  Start-Sleep -Seconds 2
}

Write-Error "LocalStack did not become ready within $TimeoutSeconds seconds."
exit 1
