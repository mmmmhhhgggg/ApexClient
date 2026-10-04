$ErrorActionPreference = "Stop"
$root = Split-Path -Parent $MyInvocation.MyCommand.Path
$release = Join-Path $root "release"
$mods = Join-Path $release "mods"
$csc = Join-Path $env:WINDIR "Microsoft.NET\Framework64\v4.0.30319\csc.exe"
$setupSource = Join-Path $root "installer\ApexSetup.cs"
$setupOutput = Join-Path $release "AppleClientSetup.exe"
$requiredFiles = @(
    (Join-Path $mods "ApexClientHud-1.21.11.jar"),
    (Join-Path $mods "ApexClientHud-26.3.jar"),
    (Join-Path $root "README.txt")
)

if (-not (Test-Path $csc)) { throw ".NET Framework C# compiler was not found: $csc" }
foreach ($file in $requiredFiles) {
    if (-not (Test-Path $file)) { throw "Required installer payload is missing: $file. Build the launcher and mods first." }
}

$temporary = Join-Path $env:TEMP ("ApexSetupBuild-" + [Guid]::NewGuid().ToString("N"))
New-Item -ItemType Directory -Force -Path $temporary | Out-Null
try {
    $launcher = Join-Path $temporary "ApexClient.exe"
    $launcherArgs = @(
        "/nologo", "/target:winexe",
        "/reference:System.Windows.Forms.dll", "/reference:System.Drawing.dll",
        "/reference:System.dll", "/reference:System.Core.dll",
        "/reference:System.Web.Extensions.dll", "/reference:System.IO.Compression.dll",
        "/reference:System.IO.Compression.FileSystem.dll",
        "/out:$launcher", (Join-Path $root "ApexClient.cs")
    )
    & $csc @launcherArgs
    if ($LASTEXITCODE -ne 0) { throw "Could not compile the Apex launcher payload." }

    $setupArgs = @(
        "/nologo", "/target:winexe",
        "/reference:System.Windows.Forms.dll", "/reference:System.Drawing.dll",
        "/reference:System.dll", "/reference:System.Core.dll",
        "/resource:$launcher,payload.ApexClient.exe",
        "/resource:$(Join-Path $mods 'ApexClientHud-1.21.11.jar'),payload.ApexClientHud-1.21.11.jar",
        "/resource:$(Join-Path $mods 'ApexClientHud-26.3.jar'),payload.ApexClientHud-26.3.jar",
        "/resource:$(Join-Path $root 'README.txt'),payload.README.txt",
        "/out:$setupOutput", $setupSource
    )
    & $csc @setupArgs
    if ($LASTEXITCODE -ne 0) {
        $setupOutput = Join-Path $release "AppleClientSetup-next.exe"
        $setupArgs = $setupArgs | ForEach-Object {
            if ($_ -eq "/out:$(Join-Path $release 'AppleClientSetup.exe')") {
                "/out:$setupOutput"
            } else {
                $_
            }
        }
        & $csc @setupArgs
        if ($LASTEXITCODE -ne 0) {         throw "Could not compile the Apple Client installer." }
    }

    & $setupOutput --verify
    if ($LASTEXITCODE -ne 0) { throw "Installer payload verification failed." }
    Get-FileHash $setupOutput -Algorithm SHA256 | Select-Object Path, Hash
}
finally {
    if (Test-Path $temporary) { Remove-Item -LiteralPath $temporary -Recurse -Force }
}
