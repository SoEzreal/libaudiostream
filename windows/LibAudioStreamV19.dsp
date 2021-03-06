# Microsoft Developer Studio Project File - Name="LibAudioStreamV19" - Package Owner=<4>
# Microsoft Developer Studio Generated Build File, Format Version 6.00
# ** DO NOT EDIT **

# TARGTYPE "Win32 (x86) Dynamic-Link Library" 0x0102

CFG=LibAudioStreamV19 - Win32 Debug
!MESSAGE This is not a valid makefile. To build this project using NMAKE,
!MESSAGE use the Export Makefile command and run
!MESSAGE 
!MESSAGE NMAKE /f "LibAudioStreamV19.mak".
!MESSAGE 
!MESSAGE You can specify a configuration when running NMAKE
!MESSAGE by defining the macro CFG on the command line. For example:
!MESSAGE 
!MESSAGE NMAKE /f "LibAudioStreamV19.mak" CFG="LibAudioStreamV19 - Win32 Debug"
!MESSAGE 
!MESSAGE Possible choices for configuration are:
!MESSAGE 
!MESSAGE "LibAudioStreamV19 - Win32 Release" (based on "Win32 (x86) Dynamic-Link Library")
!MESSAGE "LibAudioStreamV19 - Win32 Debug" (based on "Win32 (x86) Dynamic-Link Library")
!MESSAGE 

# Begin Project
# PROP AllowPerConfigDependencies 0
# PROP Scc_ProjName ""
# PROP Scc_LocalPath ""
CPP=cl.exe
MTL=midl.exe
RSC=rc.exe

!IF  "$(CFG)" == "LibAudioStreamV19 - Win32 Release"

# PROP BASE Use_MFC 0
# PROP BASE Use_Debug_Libraries 0
# PROP BASE Output_Dir "Release"
# PROP BASE Intermediate_Dir "Release"
# PROP BASE Target_Dir ""
# PROP Use_MFC 0
# PROP Use_Debug_Libraries 0
# PROP Output_Dir "Release"
# PROP Intermediate_Dir "Release"
# PROP Ignore_Export_Lib 0
# PROP Target_Dir ""
# ADD BASE CPP /nologo /MT /W3 /GX /O2 /D "WIN32" /D "NDEBUG" /D "_WINDOWS" /D "_MBCS" /D "_USRDLL" /D "LibAudioStreamV19_EXPORTS" /YX /FD /c
# ADD CPP /nologo /MT /W3 /GR /GX /O2 /I "../src/renderer" /I "." /I "../src/atomic" /I "../src/" /D "WIN32" /D "NDEBUG" /D "_WINDOWS" /D "_MBCS" /D "_USRDLL" /D "LIBAUDIOSTREAM_EXPORTS" /D "__PORTAUDIO__" /D "__PORTAUDIOV19__" /FR /YX /FD /c
# ADD BASE MTL /nologo /D "NDEBUG" /mktyplib203 /win32
# ADD MTL /nologo /D "NDEBUG" /mktyplib203 /win32
# ADD BASE RSC /l 0x40c /d "NDEBUG"
# ADD RSC /l 0x40c /d "NDEBUG"
BSC32=bscmake.exe
# ADD BASE BSC32 /nologo
# ADD BSC32 /nologo
LINK32=link.exe
# ADD BASE LINK32 kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib /nologo /dll /machine:I386
# ADD LINK32 kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib dsound.lib winmm.lib /nologo /dll /machine:I386 /nodefaultlib:"LIBCMT" /out:"Release/LibAudioStream.dll"

!ELSEIF  "$(CFG)" == "LibAudioStreamV19 - Win32 Debug"

# PROP BASE Use_MFC 0
# PROP BASE Use_Debug_Libraries 1
# PROP BASE Output_Dir "Debug"
# PROP BASE Intermediate_Dir "Debug"
# PROP BASE Target_Dir ""
# PROP Use_MFC 0
# PROP Use_Debug_Libraries 1
# PROP Output_Dir "Debug"
# PROP Intermediate_Dir "Debug"
# PROP Ignore_Export_Lib 0
# PROP Target_Dir ""
# ADD BASE CPP /nologo /MTd /W3 /Gm /GX /ZI /Od /D "WIN32" /D "_DEBUG" /D "_WINDOWS" /D "_MBCS" /D "_USRDLL" /D "LibAudioStreamV19_EXPORTS" /YX /FD /GZ /c
# ADD CPP /nologo /MTd /W3 /Gm /GR /GX /ZI /Od /I "." /I "../src/atomic" /I "../src/" /I "../src/renderer" /D "WIN32" /D "_DEBUG" /D "_WINDOWS" /D "_MBCS" /D "_USRDLL" /D "LIBAUDIOSTREAM_EXPORTS" /D "__PORTAUDIO__" /D "__PORTAUDIOV19__" /FR /YX /FD /GZ /c
# ADD BASE MTL /nologo /D "_DEBUG" /mktyplib203 /win32
# ADD MTL /nologo /D "_DEBUG" /mktyplib203 /win32
# ADD BASE RSC /l 0x40c /d "_DEBUG"
# ADD RSC /l 0x40c /d "_DEBUG"
BSC32=bscmake.exe
# ADD BASE BSC32 /nologo
# ADD BSC32 /nologo
LINK32=link.exe
# ADD BASE LINK32 kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib /nologo /dll /debug /machine:I386 /pdbtype:sept
# ADD LINK32 kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib dsound.lib winmm.lib /nologo /dll /debug /machine:I386 /nodefaultlib:"LIBCMTD" /out:"Debug/LibAudioStream.dll" /pdbtype:sept

!ENDIF 

# Begin Target

# Name "LibAudioStreamV19 - Win32 Release"
# Name "LibAudioStreamV19 - Win32 Debug"
# Begin Group "Source Files"

# PROP Default_Filter "cpp;c;cxx;rc;def;r;odl;idl;hpj;bat"
# Begin Source File

SOURCE=..\src\Envelope.cpp
# End Source File
# Begin Source File

SOURCE=..\src\la_smartpointer.cpp
# End Source File
# Begin Source File

SOURCE=..\src\atomic\lffifo.c
# End Source File
# Begin Source File

SOURCE=..\src\atomic\lflifo.c
# End Source File
# Begin Source File

SOURCE=..\src\LibAudioStream.cpp
# End Source File
# Begin Source File

SOURCE=..\src\Object.cpp
# End Source File
# Begin Source File

SOURCE=..\src\StringTools.c
# End Source File
# Begin Source File

SOURCE=..\src\TAudioChannel.cpp
# End Source File
# Begin Source File

SOURCE=..\src\TAudioEffect.cpp
# End Source File
# Begin Source File

SOURCE=..\src\TAudioEngine.cpp
# End Source File
# Begin Source File

SOURCE=..\src\TAudioGlobals.cpp
# End Source File
# Begin Source File

SOURCE=..\src\TAudioMixer.cpp
# End Source File
# Begin Source File

SOURCE=..\src\TAudioRenderer.cpp
# End Source File
# Begin Source File

SOURCE=..\src\TAudioRendererFactory.cpp
# End Source File
# Begin Source File

SOURCE=..\src\TAudioStreamFactory.cpp
# End Source File
# Begin Source File

SOURCE=..\src\TBufferedAudioStream.cpp
# End Source File
# Begin Source File

SOURCE=..\src\TCutEndAudioStream.cpp
# End Source File
# Begin Source File

SOURCE=..\src\TFadeAudioStream.cpp
# End Source File
# Begin Source File

SOURCE=..\src\TFileAudioStream.cpp
# End Source File
# Begin Source File

SOURCE=..\src\TLoopAudioStream.cpp
# End Source File
# Begin Source File

SOURCE=..\src\TMixAudioStream.cpp
# End Source File
# Begin Source File

SOURCE=..\src\renderer\TPortAudioV19Renderer.cpp
# End Source File
# Begin Source File

SOURCE=..\src\TReadFileAudioStream.cpp
# End Source File
# Begin Source File

SOURCE=..\src\TRendererAudioStream.cpp
# End Source File
# Begin Source File

SOURCE=..\src\TSeqAudioStream.cpp
# End Source File
# Begin Source File

SOURCE=..\src\TThreadCmdManager.cpp
# End Source File
# Begin Source File

SOURCE=..\src\TTransformAudioStream.cpp
# End Source File
# Begin Source File

SOURCE=..\src\TWriteFileAudioStream.cpp
# End Source File
# End Group
# Begin Group "Header Files"

# PROP Default_Filter "h;hpp;hxx;hm;inl"
# End Group
# Begin Group "Resource Files"

# PROP Default_Filter "ico;cur;bmp;dlg;rc2;rct;bin;rgs;gif;jpg;jpeg;jpe"
# Begin Source File

SOURCE=.\resource.rc
# End Source File
# End Group
# Begin Source File

SOURCE=.\libsndfile.lib
# End Source File
# Begin Source File

SOURCE=.\PortAudioV19.lib
# End Source File
# End Target
# End Project
