@echo off

if "%1"=="" goto HELP
if "%2"=="" goto HELP
if "%3"=="" goto HELP

set WL_VC=%1
set WL_ENV=%2
set WL_PLATFORM=%3

if NOT "debug"=="%WL_ENV%" (
	if NOT "release"=="%WL_ENV%" (
		echo Invalid env
		goto HELP
	)
)

if NOT "x86"=="%WL_PLATFORM%" (
	if NOT "x64"=="%WL_PLATFORM%" (
		echo Invalid platform
		goto HELP
	)
)

if "vc9"=="%WL_VC%" (
	if "x86"=="%WL_PLATFORM%" (
		call "%ProgramFiles%\Microsoft Visual Studio 9.0\VC\bin\vcvars32.bat" 
		rem call "%ProgramFiles%\Microsoft SDKs\Windows\v6.1\Bin\SetEnv.Cmd" /%WL_ENV% /%WL_PLATFORM% /xp 
		setenv /%WL_ENV% /%WL_PLATFORM% /xp

	) else (
		rem call "%ProgramFiles%\Microsoft Visual Studio 9.0\VC\bin\vcvarsx86_amd64.bat" 
		echo only x86 build for vc9 are supported
		goto EXIT_BAD 
	)
	cd vc9
) else if "vc11"=="%WL_VC%" (

	call "%ProgramFiles%\Microsoft Visual Studio 11.0\VC\vcvarsall.bat" %WL_PLATFORM%

	cd vc11
) else (
	echo Unsupported Visual Studio version
)

if "release"=="%WL_ENV%" (
	set WL_USE_ENV=Release
) else (
	set WL_USE_ENV=Debug
)

if "x86"=="%WL_PLATFORM%" (
	set WL_USE_PLATFORM=Win32
) else (
	set WL_USE_PLATFORM=x64
)

msbuild /p:Configuration=%WL_USE_ENV% /p:Platform=%WL_USE_PLATFORM% dirent.sln

cd ..

:EXIT_GOOD
	exit /b 0

:EXIT_BAD
	exit /b 3

:HELP
	echo Builds a winlibs project
	echo Usage: build.bat project vc env platform
	echo     vc - vc9 or vc11
	echo     env - release or debug
	echo     platform - x86 or x64
