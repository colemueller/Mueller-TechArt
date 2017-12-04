using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class spinAround : MonoBehaviour {

    public float turnAmount;
    public Transform parent;
	
	// Update is called once per frame
	void Update () {
       //transform.RotateAround(Vector3.up, (turnAmount) * Time.deltaTime);

       transform.RotateAround(parent.position, Vector3.up, -turnAmount * Time.deltaTime);


    }
}
