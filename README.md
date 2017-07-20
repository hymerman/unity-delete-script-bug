# unity-delete-script-bug
To prove deleting or adding a script file before a batchmode build causes compilation problems.

This has been tested on Windows 10 with Unity 5.4.1p4, Unity 5.6.0f3 and Unity 2017.1.0f3, which each display variations on the same bug. Others report it has been present (and apparently fixed!) in several versions starting from 5.0.

Project is basic new project, single folder, couple scripts, nothing fancy.
The build scripts were created based on online docs.

## Usage:
Open run_test_case.bat, verify UNITY_CMD_PATH and observe commands to understand what's happening.
Run:
`bash run_test_case.bat`

The script runs Unity 6 times, twice with TestScript_toDelete.cs present (and building for Linux), then twice with it deleted (and building for Windows), then twice with a new script ("TestScript_toAdd.cs") added and with MyScriptA referencing it.

All 6 runs should succeed, but in 5.6.0f3, the third run (the first after deleting the script) fails, specifically when changing platforms. On previous Unity versions, it would fail also when not changing platforms. The fourth run (with the exact same input files as the third) succeeds. And in 2017.1.0f3, the fifth run fails - there is a problem when adding new scripts and changing other scripts to reference them.

This behaviour has been present in Unity for a long time (see bug 703290, https://issuetracker.unity3d.com/issues/build-ios-building-in-batchmode-fails-for-first-time-after-removing-file-from-project) and was apparently fixed in Unity 5.3.5, but it still appars broken in 5.4.1p4. Another fix went in later during the 5.5 cycle, which seemed to fix the issue for a while, but it's back yet again in 5.6.0f3. This was fixed in 5.6.0p2, but it appears that some time between then and 2017.1.0f3, the old bug of it breaking when adding scripts has crept back in - I hadn't noticed it for a long time before the 2017 update.

Interestingly, if the script is changed to build for the same platform on all 4 runs, it succeeds. I think the bug is that refreshing the asset database, and compiling scripts, happens the wrong way round when switching platforms.

Example output is given in example_output.txt and example_unity_editor_step_\*.log
