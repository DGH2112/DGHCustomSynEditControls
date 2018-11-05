(**
  
  This module contains the registration code for the components and a splash screen for the IDE.

  @Author  David Hoyle
  @Version 1.0
  @Date    05 Nov 2018
  
**)
Unit DGHCustomSynEditControlsReg;

Interface

{$INCLUDE CompilerDefinitions.inc}

  Procedure Register;

Implementation

Uses
  ToolsAPI,
  System.SysUtils,
  System.Classes,
  WinAPI.Windows,
  VCL.Forms,
  VCL.Dialogs,
  SynHighlighterBNF,
  SynHighlighterRegEx,
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
  strSplashScreenName = 'DGH Custom SynEdit Components %d.%d%s for %s';
  {$IFDEF DEBUG}
  strSplashScreenBuild = 'Freeware Components by David Hoyle (DEBUG Build %d.%d.%d.%d)';
  strDGHCustomSynEditControls = 'DGH Custom SynEdit Controls';
  {$ELSE}
  strSplashScreenBuild = 'Freeware Components by David Hoyle (Build %d.%d.%d.%d)';
  {$ENDIF}

Const
  strRevision = ' abcdefghijklmnopqrstuvwxyz';
  strSplashScreenBitMap = 'SplashScreenBitMap24x24';

{$IFDEF D2005}
Var
  SSS : IOTASplashScreenServices;
  BuildInfo : TBuildInfo;
  bmSplashScreen : HBITMAP;
{$ENDIF}

Begin
  {$IFDEF D2005}
  If Supports(BorlandIDEServices, IOTASplashScreenServices, SSS) Then
    Begin
      BuildNumber(BuildInfo);
      bmSplashScreen := LoadBitmap(hInstance, strSplashScreenBitMap);
      SSS.AddPluginBitmap(Format(strSplashScreenName, [BuildInfo.FMajor, BuildInfo.FMinor,
        Copy(strRevision, BuildInfo.FRelease + 1, 1), Application.Title]), bmSplashScreen,
        {$IFDEF DEBUG} True {$ELSE} False {$ENDIF},
        Format(strSplashScreenBuild, [BuildInfo.FMajor, BuildInfo.FMinor, BuildInfo.FRelease,
          BuildInfo.FBuild]), ''
        );
    End;
  {$ENDIF}
  RegisterComponents(strDGHCustomSynEditControls, [TSynRegExSyn, TSynBNFSyn, TSynMDSyn]);
End;

End.
