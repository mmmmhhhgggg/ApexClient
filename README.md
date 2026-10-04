# Apple Client

A Minecraft Java launcher for Windows with a Fabric HUD/client-side quality-of-life mod. The in-game menu opens with Right Shift.

## Source code

Download [AppleClient-source.zip](release/AppleClient-source.zip) for the complete source tree, including the launcher, Fabric mod sources, installer source, build scripts, and the detailed [README.txt](README.txt).

## Build on Windows

Run PowerShell from the extracted source directory:

```powershell
.\build.ps1
.\build-installer.ps1
```

The builds require the .NET Framework 4.x C# compiler, Gradle 9.x, and a Java 25+ JDK. The Fabric projects target Minecraft 1.21.11 and 26.3. See README.txt for features and compatibility notes.
