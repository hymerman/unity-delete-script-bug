using UnityEngine;
using System.Collections;
using UnityEngine.SceneManagement;

public class MyScriptA : MonoBehaviour {

	TestScript_ToAdd testScript;

	// Use this for initialization
	void Start () {
		for(int i = 0; i < SceneManager.sceneCount; ++i) {
			SceneManager.GetSceneAt(i);
		}
	}
	
	// Update is called once per frame
	void Update () {
	
	}
}
