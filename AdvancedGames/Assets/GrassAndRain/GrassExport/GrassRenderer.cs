using System.Collections;
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
    public float grassHeight = 1;
    public float grassWidth = 1;

	//public float _WindSpeed;
	//public float _WindStrength;
	//public float _WindVariance;



	void Update () {
		
		//Consider putting in start
		//Random.InitState(seed);
		List<Matrix4x4> materices = new List<Matrix4x4> (grassNumber);

		for (int i = 0; i < grassNumber; ++i) 
		{
			Vector3 origin = transform.position;
			origin.y = GeneratorStartHeight;
            origin.x += size.x;// * Random.Range (-0.5f, 0.5f);
            origin.z += size.y;// * Random.Range (-0.5f, 0.5f);
			Ray ray = new Ray (origin, Vector3.down);
			RaycastHit hit;
			if (Physics.Raycast (ray, out hit)) 
			{
                origin = hit.point + new Vector3(0, grassOffset, 0); ;

                                                    //Quaternion.identity
                materices.Add (Matrix4x4.TRS(origin, this.transform.rotation, new Vector3(1 * grassWidth, 1 * grassHeight, 1 * grassWidth)));
			}
				
		}


		//WIND
		//List<Vector3> list = new List<Vector3>();

		//for(int i=0; i < grassMesh.vertices.Length; i++)
		//{
		//	Vector3 v0 = grassMesh.vertices [i];


		//	if (i == 2 || i == 3 || i == 6 || i == 7 || i == 10 || i == 11 || i == 14 || i == 15 || i == 18 || i == 19 || i == 22 || i == 23)
		//	{

				//Vector3 wind = new Vector3 (1,0,1);
				//v0 = wind * _WindStrength;

		//	}

		//	list.Add (v0);
		//	i++;
		//}
		//grassMesh.SetVertices (list);
		//grassMesh.vertices = list;


		Graphics.DrawMeshInstanced (grassMesh, 0, material, materices);
	}
}
