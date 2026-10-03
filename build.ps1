$ErrorActionPreference = "Stop"
$root = Split-Path -Parent $MyInvocation.MyCommand.Path
$csc = Join-Path $env:WINDIR "Microsoft.NET\Framework64\v4.0.30319\csc.exe"
if (-not (Test-Path $csc)) { throw ".NET Framework C# compiler was not found: $csc" }
$src = Join-Path $root "ApexClient.cs"
$out = Join-Path $root "release"
New-Item -ItemType Directory -Force -Path $out | Out-Null
$launcher = Join-Path $out "ApexClient.exe"
$cscArgs = @("/nologo", "/target:winexe", "/reference:System.Windows.Forms.dll", "/reference:System.Drawing.dll", "/reference:System.dll", "/reference:System.Core.dll", "/reference:System.Web.Extensions.dll", "/reference:System.IO.Compression.dll", "/reference:System.IO.Compression.FileSystem.dll")
& $csc @cscArgs "/out:$launcher" "$src"
if ($LASTEXITCODE -ne 0) {
    $launcher = Join-Path $out "ApexClient-next.exe"
    & $csc @cscArgs "/out:$launcher" "$src"
    if ($LASTEXITCODE -ne 0) { throw "ApexClient.exe build failed." }
    Write-Host "ApexClient.exe is in use; the updated launcher was built as $launcher"
}
$gradle = Get-Command gradle -ErrorAction SilentlyContinue
if (-not $gradle) { throw "Gradle was not found. Install Gradle 9.x and add it to PATH to build the Fabric mod." }
$modProject = Join-Path $root "fabric-mod"
& $gradle.Source -p $modProject build --no-daemon
if ($LASTEXITCODE -ne 0) { throw "Apex Fabric mod build failed." }
$modJar = Join-Path $modProject "build\libs\apex-hud-1.0.0.jar"
if (-not (Test-Path $modJar)) { throw "The Apex Fabric mod JAR was not produced: $modJar" }
$modOutput = Join-Path $out "mods"
New-Item -ItemType Directory -Force -Path $modOutput | Out-Null
Copy-Item -Force $modJar (Join-Path $modOutput "ApexClientHud-26.3.jar")
$legacyProject = Join-Path $root "fabric-mod-1.21"
& $gradle.Source -p $legacyProject build --no-daemon
if ($LASTEXITCODE -ne 0) { throw "Apex Fabric mod build for Minecraft 1.21.11 failed." }
$legacyJar = Join-Path $legacyProject "build\libs\apex-hud-1.0.0.jar"
if (-not (Test-Path $legacyJar)) { throw "The Apex Fabric mod JAR for Minecraft 1.21.11 was not produced: $legacyJar" }
Copy-Item -Force $legacyJar (Join-Path $modOutput "ApexClientHud-1.21.11.jar")
Write-Host "Built Apex Client: $launcher"
