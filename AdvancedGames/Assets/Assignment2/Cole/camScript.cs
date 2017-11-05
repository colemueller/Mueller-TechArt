using UnityEngine;
using System.Collections;

[ExecuteInEditMode]
public class camScript : MonoBehaviour
{

    // Use this for initialization
    void Start()
    {
        this.GetComponent<Camera>().depthTextureMode = DepthTextureMode.DepthNormals;
    }
}