using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class WaterTrigger : MonoBehaviour {

    public GameObject fish;
    public GameObject cam;
    public Transform closePos;
    public Transform farPos;

    private void OnTriggerExit(Collider other)
    {
        cam.transform.position = Vector3.Lerp(cam.transform.position, closePos.position, 2);
        cam.transform.rotation = Quaternion.Lerp(cam.transform.rotation, closePos.rotation, 2);
        cam.GetComponent<camTex>().enabled = true;
    }
    
       

    private void OnTriggerEnter(Collider other)
    {
        cam.transform.position = Vector3.Lerp(cam.transform.position, farPos.position, 2 );
        cam.transform.rotation = Quaternion.Lerp(cam.transform.rotation, farPos.rotation, 2);
        fish.GetComponent<Rigidbody>().velocity = Vector3.zero;
        cam.GetComponent<camTex>().enabled = false;
    }
}
