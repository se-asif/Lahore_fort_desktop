#define MyAppName "Lahore Fort"
#define MyAppVersion "1.0.0"
#define MyAppPublisher "BLS"
#define MyAppURL "https://www.bls.com.pk"
#define MyAppExeName "lahorefort.exe"
#define MyAppIcon "lahore_fort_logo.ico"

[Setup]
AppName={#MyAppName}
AppVersion={#MyAppVersion}
AppVerName={#MyAppName} {#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
DefaultDirName={autopf}\{#MyAppName}
DefaultGroupName={#MyAppName}
OutputDir=output
OutputBaseFilename=LahoreFort_Installer_v{#MyAppVersion}
SetupIconFile={#MyAppIcon}
Compression=lzma
SolidCompression=yes
PrivilegesRequired=admin
WizardStyle=modern
ArchitecturesInstallIn64BitMode=x64
; CRITICAL FIXES BELOW
        DisableWelcomePage=no
DisableDirPage=no
DisableProgramGroupPage=no
CloseApplications=yes
CloseApplicationsFilter=*.exe,*.dll,*.chm
        RestartApplications=no

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Tasks]
Name: "desktopicon"; Description: "Create a &desktop shortcut"; Flags: unchecked
        Name: "startmenuicon"; Description: "Create a &Start Menu shortcut"; Flags: checkedonce

[Files]
; MAIN FIX: Copy EVERYTHING from Release folder
        Source: "build\windows\x64\runner\Release\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs
; Flutter engine data
        Source: "build\windows\x64\runner\Release\data\*"; DestDir: "{app}\data"; Flags: ignoreversion recursesubdirs createallsubdirs
; Your assets
Source: "assets\*"; DestDir: "{app}\assets"; Flags: ignoreversion recursesubdirs
; VC++ Redist
        Source: "VC_redist.x64.exe"; DestDir: "{app}"; Flags: ignoreversion
; Icon for shortcuts
        Source: "{#MyAppIcon}"; DestDir: "{app}"; Flags: ignoreversion

[Icons]
; CRITICAL: Use full path and correct icon
        Name: "{commondesktop}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; WorkingDir: "{app}"; Tasks: desktopicon; IconFilename: "{app}\{#MyAppIcon}"
Name: "{group}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; WorkingDir: "{app}"; Tasks: startmenuicon; IconFilename: "{app}\{#MyAppIcon}"
Name: "{group}\Uninstall {#MyAppName}"; Filename: "{uninstallexe}"

[Run]
; Install VC++ first
        Filename: "{app}\VC_redist.x64.exe"; Parameters: "/install /quiet /norestart"; WorkingDir: "{app}"; Flags: waituntilterminated runhidden; StatusMsg: "Installing required components..."

; Launch app — THIS IS THE FIX
Filename: "{app}\{#MyAppExeName}"; \
    Description: "Launch {#MyAppName}"; \
    Flags: nowait postinstall skipifsilent shellexec runascurrentuser; \
    WorkingDir: "{app}"

[Code]
function InitializeSetup(): Boolean;
begin
        Result := True;
end;