function Get-TimeStamp {
  return "[{0:MM/dd/yy} {0:HH:mm:ss}]" -f (Get-Date)
}

function PrettyPrintJson {
  param(
      [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
      $json
  )
  $json | ConvertFrom-Json | ConvertTo-Json -Depth 100
}