using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class OldKelpSpawn : MonoBehaviour {
    SkinnedMeshRenderer rend;
    private float yVelocity = 0.0F;
    private float smoothTime = 1.0F;
    bool doDis = true;

    private void Start()
    {
        
        rend = GetComponent<SkinnedMeshRenderer>();
        rend.material.shader = Shader.Find("Custom/Dissolve Shader");
        //rend.material.shader = Shader.Find("Dissolve Shader");
        StartCoroutine(setZero(8));
    }

    // Use this for initialization
    void Update () {

        if (doDis)
        {
            float temp = rend.material.GetFloat("_DissolveAmount");

            float dissolve = Mathf.SmoothDamp(temp, -0.1F, ref yVelocity, smoothTime);

            //float dissolve = 0;
            rend.material.SetFloat("_DissolveAmount", dissolve);
            
        }
    }

    IEnumerator setZero(float time)
    {
        yield return new WaitForSeconds(time);
        doDis = false;
        rend.material.SetFloat("_DissolveAmount", 0);
        
    }
}
