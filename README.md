# unity-delete-script-bug
To prove deleting a file on batchmode build causes compilation problems.

This has been tested on Windows 10 with Unity 5.4.1p4 and Unity 5.6.0f3.

Project is basic new project, single folder, couple scripts, nothing fancy.
It is set to "Visible Meta Files" for Version Control Mode; and "Force Text" for Serialization.
The build scripts were created based on online docs.

## Usage:
Open run_test_case.bat, verify UNITY_CMD_PATH and observe commands to understand what's happening.
Run:
`bash run_test_case.bat`

The script runs Unity 4 times, twice with TestScript_toDelete.cs present (and building for Linux), then twice with it deleted (and building for Windows).

All 4 runs should succeed, but the third run (the first after deleting the script) fails. The fourth run (with the exact same input files as the third) succeeds.

This behaviour has been present in Unity for a long time (see bug 703290, https://issuetracker.unity3d.com/issues/build-ios-building-in-batchmode-fails-for-first-time-after-removing-file-from-project) and was apparently fixed in Unity 5.3.5, but it still appars broken in 5.4.1p4. Another fix went in later during the 5.5 cycle, which seemed to fix the issue for a while, but it's back yet again in 5.6.0f3.

Interestingly, if the script is changed to build for the same platform on all 4 runs, it succeeds. I think the bug is that refreshing the asset database, and compiling scripts, happens the wrong way round when switching platforms.

Example output is given in example_output.txt and example_unity_editor_step_\*.log
