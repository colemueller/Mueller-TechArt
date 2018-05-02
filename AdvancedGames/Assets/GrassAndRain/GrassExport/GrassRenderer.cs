﻿using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]

public class GrassRenderer : MonoBehaviour {
	public Mesh grassMesh;
	public Material material;


	public int seed;
	public Vector2 size;

	[Range(1,1000)]
	public int grassNumber;

	public float GeneratorStartHeight = 1000;
    public float grassOffset;
    public Vector2 grassWidthRange;
    public Vector2 grassHeightRange;
    public bool RegenerateGrass = false;

    private List<Matrix4x4> materices;

    void Start () {

        GenerateGrass();

	}

    void GenerateGrass()
    {
        Random.InitState(seed);
        materices = new List<Matrix4x4>(grassNumber);

        for (int i = 0; i < grassNumber; ++i)
        {
            Vector3 origin = transform.position;
            origin.y = GeneratorStartHeight;
            origin.x += size.x * Random.Range(-0.5f, 0.5f);
            origin.z += size.y * Random.Range(-0.5f, 0.5f);
            Ray ray = new Ray(origin, Vector3.down);
            RaycastHit hit;
            if (Physics.Raycast(ray, out hit))
            {
                origin = hit.point + new Vector3(0, grassOffset, 0); ;

                float grassWidth = Random.Range(grassWidthRange.x, grassWidthRange.y);
                float grassHeight = Random.Range(grassHeightRange.x, grassHeightRange.y);
                float randRotation = Random.Range(0, 180);
                //Quaternion rotation = Quaternion.Euler(0, randRotation, 0);
                //Quaternion.identity
                materices.Add(Matrix4x4.TRS(origin, this.transform.rotation, new Vector3(1 * grassWidth, 1 * grassHeight, 1 * grassWidth)));
            }

        }
    }

    private void Update()
    {
        Graphics.DrawMeshInstanced(grassMesh, 0, material, materices);

        if (RegenerateGrass)
        {
            GenerateGrass();
            RegenerateGrass = false;
        }
    }
}
