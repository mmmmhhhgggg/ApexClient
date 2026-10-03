$ErrorActionPreference = "Stop"
$root = Split-Path -Parent $MyInvocation.MyCommand.Path
$csc = Join-Path $env:WINDIR "Microsoft.NET\Framework64\v4.0.30319\csc.exe"
if (-not (Test-Path $csc)) { throw ".NET Framework C# compiler was not found: $csc" }
$src = Join-Path $root "ApexClient.cs"
$out = Join-Path $root "release"
New-Item -ItemType Directory -Force -Path $out | Out-Null
& $csc /nologo /target:winexe /out:"$out\ApexClient.exe" /reference:System.Windows.Forms.dll /reference:System.Drawing.dll /reference:System.dll /reference:System.Core.dll /reference:System.Web.Extensions.dll /reference:System.IO.Compression.dll /reference:System.IO.Compression.FileSystem.dll "$src"
if ($LASTEXITCODE -ne 0) { throw "ApexClient.exe build failed." }
Write-Host "Built Apex Client in $out"
