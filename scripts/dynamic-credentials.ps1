. .\env.ps1
. .\functions.ps1

Write-Host "--- $(Get-TimeStamp) Retrieving Dynamic Credentials from HashiCorp Vault"
$json=(vault read azure/creds/read_only -format=json | ConvertFrom-Json)

$Env:AZURE_CLIENT_ID=$json.data.client_id
$Env:AZURE_CLIENT_SECRET=$json.data.client_secret

Write-Host "--- $(Get-TimeStamp) Sleeping for 10 Seconds"
Start-Sleep -Seconds 10

1..5 | ForEach-Object {
  Write-Host "--- $(Get-TimeStamp) Running list_groups.py Using Dynamic Credentials"
  python .\list_groups.py
  Write-Host ""
  Write-Host "--- $(Get-TimeStamp) Sleeping for 10 Seconds"
  Start-Sleep -Seconds 10
}

Write-Host "--- $(Get-TimeStamp) Running list_groups.py Using Dynamic Credentials"
python .\list_groups.py
Write-Host ""
