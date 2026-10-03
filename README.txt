Apex Client
===========

Build on Windows with the .NET Framework 4.x compiler:
  powershell -ExecutionPolicy Bypass -File .\build.ps1

The build writes release\ApexClient.exe. On first launch the app downloads the
official Mojang version manifest and displays the available vanilla versions.
Choose a version and player name, then press INSTALUJ I GRAJ. The launcher
downloads the Mojang version metadata, client jar, libraries, assets, and a
matching Temurin Java runtime automatically. Files are cached under:
  %APPDATA%\ApexClient

Authentication
--------------
Offline mode launches with a local player name and is intended for singleplayer
and local testing. It cannot join authenticated online servers.

Online mode is currently unavailable. The previous browser flow asked the user
to copy a Microsoft redirect URL; that flow has been disabled. Apex never asks
for or stores a Microsoft password. Enabling online requires a properly
configured Microsoft/Windows authentication broker; do not enter Microsoft
credentials into custom Apex fields.

Scope
-----
This build installs and launches vanilla Minecraft versions from Mojang's
official manifest. It does not install Fabric, Forge, or OptiFine, and does
not include an in-game HUD/mod. Those require separate loader installations
and game-version-specific mod builds.

Modrinth browser
----------------
Use MODS in the left sidebar (or PRZEGLĄDAJ MODRINTH on the launchpad) to
search Modrinth projects by Minecraft version and loader. Compatible .jar
files can be downloaded into the selected Minecraft profile's mods folder;
SHA-512 is verified before the file is installed. Modrinth search does not
require an API key or a Minecraft world seed.

This launcher currently starts vanilla only. Downloading a mod does not install
its loader or dependencies and does not make vanilla load the mod.

Local AI assistant
------------------
Open APEX AI from the sidebar or launchpad. On first use, the launcher asks
before downloading Ollama's official Windows installer, verifies its
Authenticode signature, and launches the installer. After installation it
downloads a local Qwen 3 model chosen from system RAM:
  under 8 GB: qwen3:1.7b
  8-24 GB: qwen3:4b
  24-40 GB: qwen3:8b
  40 GB or more: qwen3:14b

The model and conversations run locally. For internet mod discovery the AI
uses the public Modrinth API. Available tools read the selected profile's
latest.log, search compatible Modrinth mods, install a compatible JAR only
after confirmation, and verify/repair the official vanilla metadata and client
JAR only after confirmation. It cannot run arbitrary shell commands.
Downloaded mod dependencies are reported but are not installed automatically.
The current game launcher is vanilla, so a downloaded mod will not load until
its matching loader is installed and used.
