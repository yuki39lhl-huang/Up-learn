# Publish backend/nacos-config/DEFAULT_GROUP/*.yaml to local Nacos (8858).
# Console: http://localhost:8088  user/pass: nacos/nacos
param(
  [string]$Server = "http://127.0.0.1:8858",
  [string]$Username = "nacos",
  [string]$Password = "nacos",
  [string]$Group = "DEFAULT_GROUP"
)

$ErrorActionPreference = "Stop"
$dir = Join-Path $PSScriptRoot "DEFAULT_GROUP"
if (-not (Test-Path $dir)) {
  throw "config dir not found: $dir"
}

$login = Invoke-RestMethod -Method Post -Uri "$Server/nacos/v1/auth/login" -Body @{
  username = $Username
  password = $Password
}
$token = $login.accessToken
if (-not $token) {
  throw "Nacos login failed: $Server"
}

$files = Get-ChildItem -Path $dir -Filter '*.yaml' | Sort-Object Name
foreach ($f in $files) {
  $content = [IO.File]::ReadAllText($f.FullName, [Text.UTF8Encoding]::new($false))
  $body = @{
    dataId      = $f.Name
    group       = $Group
    type        = "yaml"
    content     = $content
    accessToken = $token
  }
  $ok = Invoke-RestMethod -Method Post -Uri "$Server/nacos/v1/cs/configs" -Body $body
  if ("$ok" -ne "True" -and "$ok" -ne "true") {
    Write-Host "FAIL $($f.Name) => $ok"
  } else {
    Write-Host "OK   $($f.Name)"
  }
}

Write-Host ""
Write-Host "Done. Restart services (IDEA profile=local) to load Nacos configs."
