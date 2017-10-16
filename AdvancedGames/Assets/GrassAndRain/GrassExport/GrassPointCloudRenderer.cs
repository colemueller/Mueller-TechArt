using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]

public class GrassPointCloudRenderer : MonoBehaviour {

    //public Mesh grassMesh;
    //public Material material;

    private Mesh mesh;
    public MeshFilter filter; 

    public int seed;
    public Vector2 size;

    [Range(1, 60000)]
    public int grassNumber;

    public float startHeight = 1000;
    public float grassOffset = 0.0f;

    public float UvScalar = 1000;

    private Vector3 lastPosition;
    private List<Matrix4x4> materices;

    

    void Update()
    {
        if (lastPosition != this.transform.position)
        { 
            //Consider putting in start
            Random.InitState(seed);
            //materices = new List<Matrix4x4>(grassNumber);

            List<Vector3> VertexPositions = new List<Vector3>(grassNumber);
            //Debug.Log(grassNumber);
            int[] indicies = new int[grassNumber];
            List<Color> colors = new List<Color>(grassNumber);
            List<Vector3> normals = new List<Vector3>(grassNumber);
            //List<Vector3> uvs = new List<Vector3>(grassNumber);

            for (int i = 0; i < grassNumber; ++i)
            {
                Vector3 origin = transform.position;
                origin.y = startHeight;
                origin.x += size.x * Random.Range(-0.5f, 0.5f);
                origin.z += size.y * Random.Range(-0.5f, 0.5f);
                Ray ray = new Ray(origin, Vector3.down);
                RaycastHit hit;
                if (Physics.Raycast(ray, out hit))
                {
                    origin = hit.point;
                    origin.y += grassOffset;

                    //materices.Add(Matrix4x4.TRS(origin, Quaternion.identity, Vector3.one));

                    VertexPositions.Add(origin);
                    //Debug.Log("Is hit");
                    indicies[i] = i; 
                    colors.Add(new Color(Random.Range(0.0f, 1.0f), Random.Range(0.0f, 1.0f), Random.Range(0.0f, 1.0f), 1));
                    normals.Add(hit.normal);
                    //var uv = (origin - this.transform.position) / UvScalar;
                    //uvs.Add(new Vector2(uv.x, uv.z));
                }

            }
            //creates mesh
            mesh = new Mesh();
            mesh.SetVertices(VertexPositions);
            mesh.SetIndices(indicies, MeshTopology.Points, 0);
            mesh.SetColors(colors);
            mesh.SetNormals(normals);
            //mesh.SetUVs(0, uvs);
            filter.mesh = mesh;

            lastPosition = this.transform.position;
        }

        //Graphics.DrawMeshInstanced(grassMesh, 0, material, materices);

       


    }


}
