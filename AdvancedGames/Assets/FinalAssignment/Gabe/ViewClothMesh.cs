using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ViewClothMesh : MonoBehaviour {

    Cloth cloth;
    int[] tris;
    private void Start()
    {
        cloth = GetComponent<Cloth>();
        Mesh mesh = GetComponent<SkinnedMeshRenderer>().sharedMesh;
        tris = mesh.triangles;
    }

    // Update is called once per frame
    void Update () {
        var verts = cloth.vertices;
        for (int i = 0; i < tris.Length; i+=3)
        {
            var v1 = transform.TransformPoint(verts[tris[i]]);
            var v2 = transform.TransformPoint(verts[tris[i+1]]);
            var v3 = transform.TransformPoint(verts[tris[i+2]]);
            Debug.DrawLine(v1, v2);
            Debug.DrawLine(v2, v3);
            Debug.DrawLine(v3, v1);
        }
	}
}
