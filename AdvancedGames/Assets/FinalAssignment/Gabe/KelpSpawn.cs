using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class KelpSpawn : MonoBehaviour {
    SkinnedMeshRenderer rend;
    float maxValue = 1;
    float myValue = 1;
    float minValue = 0;
    float changePerSecond;
    float timeToChange = 3;

    private void Start()
    {
        rend = GetComponent<SkinnedMeshRenderer>();
        rend.material.shader = Shader.Find("Custom/Dissolve Shader");
        changePerSecond = (minValue - maxValue) / timeToChange;
    }

    // Use this for initialization
    void Update ()
    {
        myValue = Mathf.Clamp(myValue + changePerSecond * Time.deltaTime, minValue, maxValue);
        rend.material.SetFloat("_DissolveAmount", myValue);
    } 
}
