; Inno Setup script for PoseThumbnailProvider
#define MyAppName        "Pose Thumbnail Provider"
#define MyAppVersion     "1.0.0"
#define MyAppPublisher   "NightshadeNx"
#define MyAppURL         "https://github.com/NightshadeNx/PoseThumbnailProvider"
#define MyAppExeName     "PoseThumbnailProvider.dll"
#define MyAppGuid        "{{74896d02-3916-4920-b875-df9111819cf5}"

[Setup]
AppId={#MyAppGuid}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
DefaultDirName={autopf}\PoseThumbnailProvider
DefaultGroupName={#MyAppName}
DisableProgramGroupPage=yes
OutputDir=..\..\dist
OutputBaseFilename=PoseThumbnailProvider-Setup-{#MyAppVersion}
Compression=lzma
SolidCompression=yes
ArchitecturesInstallIn64BitMode=x64compatible
ArchitecturesAllowed=x64compatible
PrivilegesRequired=admin
UninstallDisplayIcon={app}\{#MyAppExeName}
WizardStyle=modern

[Files]
Source: "..\bin\x64\Release\PoseThumbnailProvider.dll"; DestDir: "{app}"; Flags: ignoreversion 64bit
Source: "..\bin\x64\Release\SharpShell.dll";            DestDir: "{app}"; Flags: ignoreversion 64bit

[Registry]
; .pose extension association
Root: HKCR; Subkey: ".pose"; ValueType: string; ValueName: ""; ValueData: "AnamnesisPoFile"; Flags: uninsdeletekey
; Register our thumbnail provider under the shell association
Root: HKCR; Subkey: "AnamnesisPoFile\ShellEx\{{E357FCCD-A995-4576-B01F-234630154E96}"; ValueType: string; ValueName: ""; ValueData: "{{8328811d-cd39-4b96-abab-6e156b5cdcaa}"; Flags: uninsdeletekey
; Optional logging flag
Root: HKLM; Subkey: "SOFTWARE\PoseThumbnailProvider"; ValueType: dword; ValueName: "Logging"; ValueData: 0; Flags: uninsdeletekey

[Run]
; Stop explorer before registering
Filename: "{sys}\taskkill.exe"; Parameters: "/f /im explorer.exe"; Flags: runhidden waituntilterminated
; Register the COM shell extension using .NET regasm
Filename: "{win}\Microsoft.NET\Framework64\v4.0.30319\regasm.exe"; \
    Parameters: "/codebase ""{app}\{#MyAppExeName}"""; \
    Flags: runhidden waituntilterminated 64bit; \
    StatusMsg: "Registering shell extension..."
; Restart explorer
Filename: "{win}\explorer.exe"; Flags: nowait postinstall skipifsilent

[UninstallRun]
Filename: "{sys}\taskkill.exe"; Parameters: "/f /im explorer.exe"; Flags: runhidden waituntilterminated
Filename: "{win}\Microsoft.NET\Framework64\v4.0.30319\regasm.exe"; \
    Parameters: "/u ""{app}\{#MyAppExeName}"""; \
    Flags: runhidden waituntilterminated 64bit
Filename: "{win}\explorer.exe"; Flags: nowait
