#ifndef AppVersion
  #define AppVersion "0.2.0"
#endif
#ifndef SourceDir
  #error SourceDir must point to the complete Flutter release bundle
#endif
#ifndef OutDir
  #define OutDir "."
#endif
[Setup]
AppId={{6657D851-F774-43A9-AB7F-09E39061A317}
AppName=Aiva
AppVersion={#AppVersion}
AppPublisher=Aiva contributors
DefaultDirName={localappdata}\Programs\Aiva
DefaultGroupName=Aiva
PrivilegesRequired=lowest
ArchitecturesAllowed=x64compatible
ArchitecturesInstallIn64BitMode=x64compatible
OutputDir={#OutDir}
OutputBaseFilename=Aiva-{#AppVersion}-windows-x64-setup
SetupIconFile=app_icon.ico
UninstallDisplayIcon={app}\Aiva.exe
Compression=lzma2
SolidCompression=yes
WizardStyle=modern
CloseApplications=yes
RestartApplications=no
[Files]
Source: "{#SourceDir}\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs
[Icons]
Name: "{group}\Aiva"; Filename: "{app}\Aiva.exe"
Name: "{autodesktop}\Aiva"; Filename: "{app}\Aiva.exe"; Tasks: desktopicon
[Tasks]
Name: "desktopicon"; Description: "Vytvořit zástupce na ploše"; Flags: unchecked
[Run]
Filename: "{app}\Aiva.exe"; Description: "Spustit Aiva"; Flags: nowait postinstall skipifsilent
; The installer intentionally never deletes the profile or student workspaces.
