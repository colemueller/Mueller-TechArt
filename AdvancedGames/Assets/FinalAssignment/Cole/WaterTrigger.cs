using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class WaterTrigger : MonoBehaviour {

    public GameObject fish;

	// Use this for initialization
	void Start () {
        fish.GetComponent<Rigidbody>().useGravity = false;
	}
	
	// Update is called once per frame
	void Update () {
		
	}

    private void OnTriggerExit(Collider other)
    {
        fish.GetComponent<Rigidbody>().useGravity = true;
    }

    private void OnTriggerEnter(Collider other)
    {
        fish.GetComponent<Rigidbody>().useGravity = false;
        fish.GetComponent<Rigidbody>().velocity = Vector3.zero;
    }
}
