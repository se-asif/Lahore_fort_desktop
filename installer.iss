#define MyAppName      "Lahore Fort"
#define MyAppVersion   "1.0.8"
#define MyAppExeName   "lahorefort.exe"
#define SourcePath     "build\windows\x64\runner\Release"

[Setup]
AppName={#MyAppName}
AppVersion={#MyAppVersion}
DefaultDirName={autopf}\{#MyAppName}
DefaultGroupName={#MyAppName}
OutputDir=installer_output
OutputBaseFilename=LahoreFort_Setup_v{#MyAppVersion}
SetupIconFile=lahore_fort_logo.ico
Compression=lzma
SolidCompression=no
ArchitecturesAllowed=x64
ArchitecturesInstallIn64BitMode=x64
PrivilegesRequiredOverridesAllowed=dialog
WizardStyle=modern
UninstallDisplayIcon={app}\{#MyAppExeName}

[Files]
; Main application files
        Source: "{#SourcePath}\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs

; Add sqlite3.dll from windows/flutter/runner folder
Source: "windows\sqlite3.dll"; DestDir: "{app}"; Flags: ignoreversion

[Tasks]
Name: "desktopicon"; Description: "Create a &desktop icon"

[Icons]
Name: "{group}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; WorkingDir: "{app}"
Name: "{autodesktop}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; Tasks: desktopicon; WorkingDir: "{app}"

[Run]
; Install VC++ Redistributable if needed
        Filename: "https://aka.ms/vs/17/release/vc_redist.x64.exe"; Parameters: "/quiet /norestart"; Flags: shellexec waituntilterminated; StatusMsg: "Installing Visual C++ Runtime..."; Check: VCRedistNeedsInstall

; Launch app
Filename: "{app}\{#MyAppExeName}"; Description: "Launch {#MyAppName}"; Flags: nowait postinstall skipifsilent; WorkingDir: "{app}"

[Code]
function VCRedistNeedsInstall: Boolean;
var
        Version: String;
begin
Result := not RegQueryStringValue(HKLM64, 'SOFTWARE\Microsoft\VisualStudio\14.0\VC\Runtimes\X64', 'Version', Version);
end;