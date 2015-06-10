#!/bin/bash

# Running test

# Path to Unity command
UNITY_CMD_PATH=/Applications/Unity/Unity.app/Contents/MacOS/Unity
UNITY_PROJECT_PATH=$(pwd)/test-project/
UNITY_EDITOR_LOG=~/Library/Logs/Unity/Editor.log
OUTPUT_DIR=$(pwd)/_output/

# Start clean
rm -rf $OUTPUT_DIR
mkdir -p $OUTPUT_DIR
rm -rf snapshota snapshotb snapshotc fail-meta

echo "1. Run first Unity build ... this should complete successfully"
$UNITY_CMD_PATH -quit -batchmode -projectPath $UNITY_PROJECT_PATH -buildTarget iPhone -executeMethod Build.ClientBuilder.BuildClient_BatchMode -outputDir=$OUTPUT_DIR/build_step_1/
echo "      Result: " $?
sleep 2
cp  ~/Library/Logs/Unity/Editor.log $OUTPUT_DIR/unity_editor_step_1.log

echo "2. Remove a script file and it's corresponding meta file"
mkdir -p $(pwd)/tmp_deleted_file/
mv $UNITY_PROJECT_PATH/Assets/MyFolder/TestScript_toDelete.cs* $(pwd)/tmp_deleted_file/ 

echo "2.1 save snapshot a"
cp -r $UNITY_PROJECT_PATH snapshota
mkdir fail-meta
cp snapshota/Library/metadata/eb/ebf102192028942cdb156ff88fe33d6a      fail-meta/
cp snapshota/Library/metadata/eb/ebf102192028942cdb156ff88fe33d6a.info fail-meta/
cp snapshota/Library/assetDatabase3                                    fail-meta/
cp snapshota/Library/guidmapper                                        fail-meta/

echo "3. Run Unity build again ... this should fail"
$UNITY_CMD_PATH -quit -batchmode -projectPath $UNITY_PROJECT_PATH -buildTarget iPhone -executeMethod Build.ClientBuilder.BuildClient_BatchMode -outputDir=$OUTPUT_DIR/build_step_3/
echo "      Result: " $?
sleep 2
cp  ~/Library/Logs/Unity/Editor.log $OUTPUT_DIR/unity_editor_step_3.log

echo "3.1 save snapshot b"
cp -r $UNITY_PROJECT_PATH snapshotb

echo "4. Run Unity build again ... this should complete successfully"
$UNITY_CMD_PATH -quit -batchmode -projectPath $UNITY_PROJECT_PATH -buildTarget iPhone -executeMethod Build.ClientBuilder.BuildClient_BatchMode -outputDir=$OUTPUT_DIR/build_step_4/
echo "      Result: " $?
sleep 2
cp  ~/Library/Logs/Unity/Editor.log $OUTPUT_DIR/unity_editor_step_4.log

echo "4.1 insert meta files which seemed to cause failure:"
cp fail-meta/ebf102192028942cdb156ff88fe33d6a        $UNITY_PROJECT_PATH/Library/metadata/eb/
cp fail-meta/ebf102192028942cdb156ff88fe33d6a.info   $UNITY_PROJECT_PATH/Library/metadata/eb/
cp fail-meta/assetDatabase3                          $UNITY_PROJECT_PATH/Library/
cp fail-meta/guidmapper                              $UNITY_PROJECT_PATH/Library/

echo "4.2 save snapshot c"
cp -r $UNITY_PROJECT_PATH snapshotc

echo "5. Run Unity build again ..."
$UNITY_CMD_PATH -quit -batchmode -projectPath $UNITY_PROJECT_PATH -buildTarget iPhone -executeMethod Build.ClientBuilder.BuildClient_BatchMode -outputDir=$OUTPUT_DIR/build_step_5/
echo "      Result: " $?
sleep 2
cp  ~/Library/Logs/Unity/Editor.log $OUTPUT_DIR/unity_editor_step_5.log

echo "Cleaning up: Put deleted script back"
mv $(pwd)/tmp_deleted_file/TestScript_toDelete.cs* $UNITY_PROJECT_PATH/Assets/MyFolder/

#rm udsb.zip
#zip udsb.zip -r . > /dev/null
#cp udsb.zip /Volumes/Public/stuff
