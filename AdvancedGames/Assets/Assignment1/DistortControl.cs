using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DistortControl : MonoBehaviour {

    public Renderer rend;

	// Use this for initialization
	void Start () {
	rend = this.GetComponent<Renderer>();	
	}
	
	// Update is called once per frame
	void Update () {
        float ocellate = Mathf.PingPong(Time.time, 1000);
        rend.material.SetFloat("_DistortMod", ocellate);
		
	}
}
