using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class disableKelp : MonoBehaviour {

    private void OnTriggerEnter(Collider other)
    {
        if (other.CompareTag("kelp"))
        {
            other.GetComponent<SkinnedMeshRenderer>().enabled = false;
            //other.gameObject.SetActive(false);
        }
    }

    private void OnTriggerExit(Collider other)
    {
        if (other.CompareTag("kelp"))
        {
            other.GetComponent<SkinnedMeshRenderer>().enabled = true;
            //other.gameObject.SetActive(true);
        }
    }
}
