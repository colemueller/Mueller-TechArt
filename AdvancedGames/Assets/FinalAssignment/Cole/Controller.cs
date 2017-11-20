using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Controller : MonoBehaviour {

    
    public float movespeed;
    public float turnAmount;
    public bool inverted = false;
    
	// Use this for initialization
	void Start () {
		
	}
	
	// Update is called once per frame
	void Update () {
        float h = Input.GetAxis("Horizontal");
        float v = Input.GetAxis("Vertical");
        float b = Input.GetAxis("Bertical");
        //Debug.Log(v);

        if (Input.GetKeyDown(KeyCode.LeftShift))
        {
            movespeed += 1f;
        }
        if (Input.GetKeyUp(KeyCode.LeftShift))
        {
            movespeed -= 1f;
        }

        if (inverted)
        {
            transform.Rotate(Vector3.right, (50 * b) * Time.deltaTime);
        }
        else
        {
            transform.Rotate(Vector3.right, (50 * -b) * Time.deltaTime);
        }

        transform.RotateAround(Vector3.up, (h * turnAmount) * Time.deltaTime);
        transform.Translate((Vector3.forward * v) * movespeed * Time.deltaTime);
        
    }
}
