pushd %~dp0
setlocal


rem Path to Unity command
set UNITY_CMD_PATH=D:\Unity501p3\Editor\Unity.exe
set UNITY_PROJECT_PATH=%~dp0test-project\
set UNITY_EDITOR_LOG=%LOCALAPPDATA%\Unity\Editor\Editor.log
set OUTPUT_DIR=%~dp0_output

rem Start clean
rd /s /q %OUTPUT_DIR%
mkdir %OUTPUT_DIR%

echo "1. Run first Unity build ... this should complete successfully"
%UNITY_CMD_PATH% -quit -batchmode -projectPath %UNITY_PROJECT_PATH% -buildTarget iPhone -executeMethod Build.ClientBuilder.BuildClient_BatchMode -outputDir=%OUTPUT_DIR%\build_step_1\
echo "      Result: " %ERRORLEVEL%
copy %UNITY_EDITOR_LOG% %OUTPUT_DIR%\unity_editor_step_1.log

popd
