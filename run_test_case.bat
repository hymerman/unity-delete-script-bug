pushd %~dp0
setlocal


rem Path to Unity command
set UNITY_CMD_PATH=C:\Program Files\Unity5.6.0f3\Editor\Unity.exe
set UNITY_PROJECT_PATH=%~dp0test-project\
set UNITY_EDITOR_LOG=%LOCALAPPDATA%\Unity\Editor\Editor.log
set OUTPUT_DIR=%~dp0_output
set TEMP_DIR=%~dp0_temp

rem Start clean
rd /s /q %OUTPUT_DIR%
mkdir %OUTPUT_DIR%
rd /s /q %TEMP_DIR%
mkdir %TEMP_DIR%



echo "1. Run Unity build with script present... this should complete successfully"
"%UNITY_CMD_PATH%" -quit -batchmode -projectPath %UNITY_PROJECT_PATH% -buildTarget linux -executeMethod Build.ClientBuilder.BuildClient_BatchMode -outputDir=%OUTPUT_DIR%\build_step_1\build.x86 -logFile %OUTPUT_DIR%\unity_editor_step_1.log

echo "2. Run Unity build with script still present... this should complete successfully"
"%UNITY_CMD_PATH%" -quit -batchmode -projectPath %UNITY_PROJECT_PATH% -buildTarget linux -executeMethod Build.ClientBuilder.BuildClient_BatchMode -outputDir=%OUTPUT_DIR%\build_step_2\build.x86 -logFile %OUTPUT_DIR%\unity_editor_step_2.log

echo "2.5 Delete script"
move /-y %UNITY_PROJECT_PATH%\Assets\MyFolder\TestScript_toDelete.cs %TEMP_DIR%\TestScript_toDelete.cs
move /-y %UNITY_PROJECT_PATH%\Assets\MyFolder\TestScript_toDelete.cs.meta %TEMP_DIR%\TestScript_toDelete.cs.meta

echo "3. Run Unity build after deleting script... this should complete successfully but doesn't - check the log file for the error"
"%UNITY_CMD_PATH%" -quit -batchmode -projectPath %UNITY_PROJECT_PATH% -buildTarget win32 -executeMethod Build.ClientBuilder.BuildClient_BatchMode -outputDir=%OUTPUT_DIR%\build_step_3\build.exe -logFile %OUTPUT_DIR%\unity_editor_step_3.log

echo "3. Run Unity build after deleting script... this should be no different to step 3, but succeeds, showing that step 3 failed wrongly"
"%UNITY_CMD_PATH%" -quit -batchmode -projectPath %UNITY_PROJECT_PATH% -buildTarget win32 -executeMethod Build.ClientBuilder.BuildClient_BatchMode -outputDir=%OUTPUT_DIR%\build_step_4\build.exe -logFile %OUTPUT_DIR%\unity_editor_step_4.log



echo "4. Clean up; restore deleted script"
move /-y %TEMP_DIR%\TestScript_toDelete.cs %UNITY_PROJECT_PATH%\Assets\MyFolder\TestScript_toDelete.cs
move /-y %TEMP_DIR%\TestScript_toDelete.cs.meta %UNITY_PROJECT_PATH%\Assets\MyFolder\TestScript_toDelete.cs.meta


popd
