$ErrorActionPreference = 'Stop'
Set-Location (Split-Path $PSScriptRoot -Parent)
& dart tool/bootstrap.dart
if ($LASTEXITCODE -ne 0) { throw 'Host bootstrap failed.' }
& flutter pub get
if ($LASTEXITCODE -ne 0) { throw 'Dependency resolution failed.' }
& flutter doctor -v
if ($LASTEXITCODE -ne 0) { throw 'Check Flutter doctor diagnostics.' }
Write-Host 'Start: flutter run -d windows'
