# unity-delete-script-bug
To prove deleting a file on batchmode build causes compilation problems.

This has been tested on Windows 10 with Unity 5.4.1p4.

Project is basic new project, single folder, couple scripts, nothing fancy.
It is set to "Visible Meta Files" for Version Control Mode; and "Force Text" for Serialization.
The build scripts were created based on online docs.

## Usage:
Open run_test_case.bat, verify UNITY_CMD_PATH and observe commands to understand what's happening.
Run:
`bash run_test_case.bat`

The script runs Unity 4 times, twice with TestScript_toDelete.cs present (and building for Linux), then twice with it deleted (and building for Windows).

All 4 runs should succeed, but the third run (the first after deleting the script) fails. The fourth run (with the exact same input files as the third) succeeds.

This behaviour has been present in Unity for a long time (see bug 703290, https://issuetracker.unity3d.com/issues/build-ios-building-in-batchmode-fails-for-first-time-after-removing-file-from-project) and was apparently fixed in Unity 5.3.5, but as far as I can see the behaviour has just improved slightly - it still happens occasionally.

Interestingly, if the script is changed to build for the same platform on all 4 runs, it succeeds. I think the bug is that refreshing the asset database, and compiling scripts, happens the wrong way round when switching platforms.
