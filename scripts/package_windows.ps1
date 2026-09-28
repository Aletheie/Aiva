param([switch]$SkipBuild, [switch]$ZipOnly)
$ErrorActionPreference = 'Stop'
$root = Split-Path $PSScriptRoot -Parent
Set-Location $root
function Invoke-Checked([string]$Exe, [string[]]$Arguments) {
  & $Exe @Arguments
  if ($LASTEXITCODE -ne 0) { throw "$Exe failed with exit code $LASTEXITCODE" }
}
if (-not $SkipBuild) {
  Invoke-Checked 'dart' @('tool/bootstrap.dart')
  Invoke-Checked 'flutter' @('pub', 'get')
  Invoke-Checked 'flutter' @('build', 'windows', '--release')
}
Invoke-Checked 'dart' @('tool/export_licenses.dart')
$release = Join-Path $root 'build/windows/x64/runner/Release'
if (-not (Test-Path "$release/AIVA.exe")) { throw 'Missing x64 release bundle. Build on Windows first.' }
$versionMatch = [regex]::Match((Get-Content pubspec.yaml -Raw), '(?m)^version:\s*([^+\s]+)')
if (-not $versionMatch.Success) { throw 'No version in pubspec.yaml.' }
$version = $versionMatch.Groups[1].Value
$out = Join-Path $root 'dist'
$bundle = Join-Path $root 'build/package/AIVA'
New-Item -ItemType Directory -Force $out | Out-Null
if (Test-Path $bundle) { Remove-Item -Recurse -Force $bundle }
New-Item -ItemType Directory -Force $bundle | Out-Null
Copy-Item "$release/*" $bundle -Recurse -Force
Copy-Item LICENSE "$bundle/LICENSE.txt"
Copy-Item THIRD_PARTY_NOTICES.md $bundle
Copy-Item build/legal/DEPENDENCY-LICENSES.txt $bundle
# App-local Microsoft CRT: students do not install the VS runtime separately.
# Only copy redistributable CRT files from a properly licensed VS installation.
$crt = $env:VCToolsRedistDir
$vswhere = "${env:ProgramFiles(x86)}\Microsoft Visual Studio\Installer\vswhere.exe"
if (-not $crt -and (Test-Path $vswhere)) {
  $vs = & $vswhere -latest -products '*' -requires Microsoft.VisualStudio.Component.VC.Tools.x86.x64 -property installationPath
  if ($vs) { $crt = Join-Path $vs 'VC/Redist/MSVC' }
}
if (-not $crt -or -not (Test-Path $crt)) { throw 'Cannot locate VC redistributables. Set VCToolsRedistDir.' }
$crtDir = Get-ChildItem $crt -Directory -Recurse |
  Where-Object { $_.FullName -match '[\\/]x64[\\/]Microsoft\.VC\d+\.CRT$' } |
  Sort-Object FullName -Descending | Select-Object -First 1
if (-not $crtDir) { throw 'Cannot find the x64 Microsoft.VC*.CRT directory.' }
Copy-Item "$($crtDir.FullName)/*.dll" $bundle -Force
foreach ($required in @('flutter_windows.dll', 'vcruntime140.dll', 'vcruntime140_1.dll', 'msvcp140.dll', 'data/flutter_assets')) {
  if (-not (Test-Path (Join-Path $bundle $required))) { throw "Incomplete bundle: $required" }
}
if ($env:WINDOWS_SIGN_PFX) {
  if (-not $env:WINDOWS_SIGN_PASSWORD) { throw 'WINDOWS_SIGN_PASSWORD is missing.' }
  Invoke-Checked 'signtool.exe' @('sign', '/fd', 'SHA256', '/tr', 'http://timestamp.digicert.com', '/td', 'SHA256',
    '/f', $env:WINDOWS_SIGN_PFX, '/p', $env:WINDOWS_SIGN_PASSWORD, "$bundle/AIVA.exe")
}
Add-Type -AssemblyName System.IO.Compression.FileSystem
$zip = Join-Path $out "AIVA-$version-windows-x64-portable.zip"
if (Test-Path $zip) { Remove-Item $zip }
[IO.Compression.ZipFile]::CreateFromDirectory($bundle, $zip)
if (-not $ZipOnly) {
  $iscc = (Get-Command ISCC.exe -ErrorAction SilentlyContinue).Source
  if (-not $iscc) { $iscc = "${env:ProgramFiles(x86)}\Inno Setup 6\ISCC.exe" }
  if (-not (Test-Path $iscc)) { throw "Install Inno Setup 6 or pass -ZipOnly. Portable ZIP created: $zip" }
  Invoke-Checked $iscc @("/DAppVersion=$version", "/DSourceDir=$bundle", "/DOutDir=$out", "$root/packaging/windows/setup.iss")
  if ($env:WINDOWS_SIGN_PFX) {
    $installer = Join-Path $out "AIVA-$version-windows-x64-setup.exe"
    Invoke-Checked 'signtool.exe' @('sign', '/fd', 'SHA256', '/tr', 'http://timestamp.digicert.com', '/td', 'SHA256',
      '/f', $env:WINDOWS_SIGN_PFX, '/p', $env:WINDOWS_SIGN_PASSWORD, $installer)
  }
}
Get-ChildItem $out -File | Where-Object Name -match "^AIVA-$([regex]::Escape($version))-windows" |
  ForEach-Object { Get-FileHash $_.FullName -Algorithm SHA256 } |
  Format-Table -AutoSize
