(**
  
  This module contains the registration code for the components and a splash screen for the IDE.

  @Author  David Hoyle
  @Version 1.003
  @Date    25 Feb 2022
  
**)
Unit DGHCustomSynEditControlsReg;

Interface

{$INCLUDE CompilerDefinitions.inc}

  Procedure Register;

Implementation

{$R ..\DGHCustomSECompsITHVerInfo.Res}
{$R ..\DGHCustomSynEditControlsSplashScreen.Res}

Uses
  ToolsAPI,
  System.SysUtils,
  System.Classes,
  WinAPI.Windows,
  VCL.Forms,
  VCL.Dialogs,
  SynHighlighterBNF,
  SynHighlighterMD;

Type
  (** A record to describe the build information of the package. **)
  TBuildInfo = Record
    FMajor   : Integer;
    FMinor   : Integer;
    FRelease : Integer;
    FBuild   : Integer;
  End;

(**

  This is a method which obtains information about the package from is version information with the 
  package resources.

  @precon  None.
  @postcon Extracts and display the applications version number present within the EXE file.

  @param   BuildInfo as a TBuildInfo as a reference

**)
Procedure BuildNumber(Var BuildInfo : TBuildInfo);

Const
  i16BitShift = 16;
  iWordMask = $FFFF;

Var
  VerInfoSize: DWORD;
  VerInfo: Pointer;
  VerValueSize: DWORD;
  VerValue: PVSFixedFileInfo;
  Dummy: DWORD;
  strBuffer : Array[0..MAX_PATH] Of Char;

Begin
  BuildInfo.FMajor := 0;
  BuildInfo.FMinor := 0;
  BuildInfo.FRelease := 0;
  BuildInfo.FBuild := 0;
  GetModuleFilename(hInstance, strBuffer, MAX_PATH);
  VerInfoSize := GetFileVersionInfoSize(strBuffer, Dummy);
  If VerInfoSize <> 0 Then
    Begin
      GetMem(VerInfo, VerInfoSize);
      Try
        GetFileVersionInfo(strBuffer, 0, VerInfoSize, VerInfo);
        VerQueryValue(VerInfo, '\', Pointer(VerValue), VerValueSize);
        BuildInfo.FMajor := VerValue^.dwFileVersionMS shr i16BitShift;
        BuildInfo.FMinor := VerValue^.dwFileVersionMS and iWordMask;
        BuildInfo.FRelease := VerValue^.dwFileVersionLS shr i16BitShift;
        BuildInfo.FBuild := VerValue^.dwFileVersionLS and iWordMask;
      Finally
        FreeMem(VerInfo, VerInfoSize);
      End;
    End;
End;

(**

  This method creates a splash screen and registers the package components with the IDE.

  @precon  None.
  @postcon The components are registered.

**)
Procedure Register;

ResourceString
  strSplashScreenName = 'DGH Custom SynEdit Components %d.%d%s';
  {$IFDEF DEBUG}
  strSplashScreenBuild = 'Freeware Components by David Hoyle (DEBUG Build %d.%d.%d.%d)';
  {$ELSE}
  strSplashScreenBuild = 'Freeware Components by David Hoyle (Build %d.%d.%d.%d)';
  {$ENDIF}
  strDGHCustomSynEditControls = 'DGH Custom SynEdit Controls';

Const
  strRevision = ' abcdefghijklmnopqrstuvwxyz';
  strSplashScreenBitMap = 'SplashScreenBitMap24x24';

Var
  SSS : IOTASplashScreenServices;
  BuildInfo : TBuildInfo;
  bmSplashScreen : HBITMAP;

Begin
  If Supports(SplashScreenServices, IOTASplashScreenServices, SSS) Then
    Begin
      BuildNumber(BuildInfo);
      bmSplashScreen := LoadBitmap(hInstance, strSplashScreenBitMap);
      SSS.AddPluginBitmap(
        Format(strSplashScreenName, [
          BuildInfo.FMajor,
          BuildInfo.FMinor,
          strRevision[Succ(BuildInfo.FRelease)]
        ]),
        bmSplashScreen,
        {$IFDEF DEBUG} True {$ELSE} False {$ENDIF},
        Format(strSplashScreenBuild, [
          BuildInfo.FMajor,
          BuildInfo.FMinor,
          BuildInfo.FRelease,
          BuildInfo.FBuild
        ]),
        ''
      );
    End;
  RegisterComponents(strDGHCustomSynEditControls, [TSynBNFSyn, TSynMDSyn]);
End;

End.
