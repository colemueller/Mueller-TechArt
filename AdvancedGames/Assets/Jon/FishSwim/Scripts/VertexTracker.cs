using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class VertexTracker : MonoBehaviour {

	public GameObject parentGO;

	private Transform fishBody;
	private Cloth fishCloth;
	[SerializeField]private int closestVertexIndex = -1;

	void Start () 
	{
		fishBody = parentGO.transform;
		fishCloth = fishBody.GetComponent<Cloth> ();
	}
	

	void Update () 
	{
		GetClosestVertex ();
	}

	void GetClosestVertex()
	{
		Debug.Log ("BLAH");
		for (int i = 0; i < fishCloth.vertices.Length; i++)
		{
			// No vertex assigned yet
			if (closestVertexIndex == -1)
			{
				closestVertexIndex = i;
			}

			float distance = Vector3.Distance (fishCloth.vertices [i], transform.position);
			float closestDistance = Vector3.Distance (fishCloth.vertices [closestVertexIndex], transform.position);

			if(distance < closestDistance)
			{
				closestVertexIndex = i;
			}
		}

		transform.localPosition = new Vector3 (
			transform.localPosition.x,
			fishCloth.vertices[closestVertexIndex].y,
			transform.localPosition.z
		);
	}
}
