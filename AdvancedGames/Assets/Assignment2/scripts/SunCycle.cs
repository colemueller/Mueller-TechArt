using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SunCycle : MonoBehaviour {
	
	// Update is called once per frame
	void Update () {
		transform.RotateAround(Vector3.zero, Vector3.back, 10f*Time.deltaTime);
		transform.LookAt(Vector3.zero);
	}
}
