Apple Client
===========

The product's visible name is Apple Client. Existing ApexClient.exe files,
the apexclient Fabric mod ID/package, and %APPDATA%\ApexClient data directory
are intentionally retained so existing installations and settings continue to work.

Build on Windows with the .NET Framework 4.x compiler:
  powershell -ExecutionPolicy Bypass -File .\build.ps1

The build writes release\ApexClient.exe. On first launch the app downloads the
official Mojang version manifest and displays available game versions.
Choose a version and player name, then press INSTALUJ I GRAJ. The launcher
downloads the Mojang version metadata, client jar, libraries, assets, and a
matching Temurin Java runtime automatically. Files are cached under:
  %APPDATA%\ApexClient

Installer
---------
Build the self-contained per-user Windows installer after building the launcher
and Fabric mods:
  powershell -ExecutionPolicy Bypass -File .\build-installer.ps1

The installer is written to release\AppleClientSetup.exe. It installs under the
current user's LocalAppData\Programs directory by default, includes the launcher
and the built Apex HUD JARs for 1.21.11 and 26.3, creates Start Menu and optional
desktop shortcuts, and registers an uninstall entry for the current user. It
does not require administrator rights. A separate uninstaller shortcut is
added to the Start Menu. Uninstall removes the program files, Apex mods,
shortcuts, and registry entry; it preserves the launcher's Minecraft data
folder. The installer is unsigned.

Authentication
--------------
Offline mode launches with a local player name and is intended for singleplayer
and local testing. It cannot join authenticated online servers.

Online mode is currently unavailable. The previous browser flow asked the user
to copy a Microsoft redirect URL; that flow has been disabled. Apex never asks
for or stores a Microsoft password. Enabling online requires a properly
configured Microsoft/Windows authentication broker; do not enter Microsoft
credentials into custom Apex fields.

Minecraft versions
------------------
The version list contains stable Minecraft releases starting at 1.8.9. Snapshots,
pre-releases, and release candidates are excluded. Vanilla releases are launched
using their Mojang version metadata and the required Java runtime.

For releases with a compatible Fabric loader (1.14.4+), the launcher installs
Fabric and fetches compatible Modrinth releases for Fabric API, Sodium,
In-Game Account Switcher, Mod Menu, Iris, Zoomify, Freelook, and Shade &
Saturation. Stable releases are preferred;
beta and then alpha releases are used only when no stable release exists.
ModMenu, Account Switcher, and Iris are prepared before Sodium so Iris can pin
the exact Sodium build it requires. A mod is skipped when it has no compatible
release; the launcher console reports which defaults were installed and which
were unavailable. Iris and the other client mods are not available for every
game version. Fabric API is required for a Fabric launch and an installation
failure is reported instead of silently continuing without it.
Required Modrinth dependencies are installed recursively, and downloaded JARs
are SHA-512 verified. Minecraft 1.8.9 starts vanilla because Fabric and these
mods are not available for that release. The Apex HUD is currently built only
for Minecraft 1.21.11 and 26.3.

For a built-in Apple HUD, select Minecraft 1.21.11 or 26.3 and press Right Shift
in game. The in-game menu uses a category sidebar, search field, responsive
module cards, and a separate Mods page that shows which supported add-ons are
actually loaded. Only implemented Apex features are shown as toggles. EDIT HUD
opens a dedicated editor; drag a widget with the left mouse button and its
position is saved to the active profile when the mouse is released. SET IMAGE
opens a local file picker for PNG, JPG/JPEG, GIF, and MP4 files. The selected
path is saved per profile. GIF and MP4 playback loops automatically. MP4
decoding is bundled with the mod through JCodec and currently supports H.264
video without audio; other MP4 codecs may not decode. Images are limited to
4096x4096 pixels and animated GIFs to 120 frames for memory safety. Every HUD
module card has a SET button for its individual settings: scale, text color,
background visibility, and background opacity. TNT Timer settings also adjust
the detection radius from 8 to 96 blocks; Image settings open the file picker.
Reset Style restores that widget's default appearance. These values are saved
per profile. In the launcher, the MODS item switches the main content to the Modrinth screen
without opening another window; Right Shift switches between Home and the
console.

Working HUD modules include FPS, left/right CPS, keystrokes, coordinates and
direction, armor and held-item durability, active potion effects and timers,
real-world clock, server ping, memory use, biome, movement speed, world time,
dimension, chunk coordinates, TNT Timer, and Image / GIF / MP4. TNT Timer
reports the fuse of the nearest client-observed primed TNT within 48 blocks;
it does not claim to detect unprimed TNT blocks or render a world-space label.
The countdown follows Minecraft's 20-tick-per-second fuse and is displayed to
two decimal places. Module switches, widget positions, and selected media path
are saved under the Minecraft Fabric config directory in
apexclient\profile-<name>.json.

Only implemented Apple HUD features have toggle cards. Zoom/freelook,
gameplay automation, hit/combo helpers, fullbright, legacy visuals, local
weather/time changes, Hypixel integrations, replay, voice chat, and emotes are
not included and are not advertised as working Apex toggles. The Mods page
reports Fabric API, Sodium, Account Switcher, Mod Menu, Iris, Zoomify, Freelook,
and Shade & Saturation availability; the launcher attempts to install compatible
versions before game startup. Zoomify, Freelook, and Shade & Saturation are
third-party Modrinth projects and appear only when a compatible Fabric release
exists for the selected Minecraft version.
The HUD modules are local display features and do not automate combat or
modify server state.

The included Apex Fabric mods target Minecraft 26.3 (Java 25+) and Minecraft
1.21.11 (Java 21+). Other Minecraft releases still launch, but do not get the
Apex in-game menu unless a matching Apex mod build is included. Build the
launcher and both Apex mods together with build.ps1. This requires Gradle 9.x
and a Java 25+ JDK.

Modrinth browser
----------------
Use MODS in the left sidebar (or PRZEGLĄDAJ MODRINTH on the launchpad) to
search Modrinth projects by Minecraft version and loader. Compatible .jar
files can be downloaded into the selected Minecraft profile's mods folder;
SHA-512 is verified before the file is installed. Modrinth search does not
require an API key or a Minecraft world seed.

Downloaded Modrinth mods are recorded with their project/version metadata.
When launching a different Minecraft profile, Apple Client checks for installed
Modrinth projects in other profiles. If a compatible Fabric build exists, it
asks before preparing that project for the selected game version. Accepting
installs the newest compatible release (or a downgrade when that is the
available compatible release); declining is remembered for that source and
target profile. Other profiles are not modified. Replaced JARs in the selected
profile are kept under its mod-backups folder. Mods installed before project
metadata was tracked are recognized for the built-in projects by their JAR filename.

Launcher settings
-----------------
Open SET to choose Polish or English for the main launcher controls, switch
between Cyan Dark, Violet Dark, and Light themes, and allocate Minecraft's
maximum Java heap. The RAM setting is applied as -Xmx at launch and is limited
to detected physical RAM minus 2 GB (minimum 2 GB, maximum 32 GB). Preferences
are saved to %APPDATA%\ApexClient\launcher-settings.json.

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
Downloaded mods need to match the selected loader and game version.

Console
-------
Select CONSOLE in the left sidebar to switch the main launcher view to launcher
progress and Minecraft standard output/error. Select HOME to return. The
console keeps a bounded recent history while the launcher is open.
Right Shift also toggles the console while the launcher window is active.
