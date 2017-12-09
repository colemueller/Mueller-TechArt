using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Controller : MonoBehaviour {

    public float movespeed;
    public float turnAmount;
	public float verticalScale;
    public bool inverted = false;

	public GameObject fishGameObject;
	private SkinnedMeshRenderer fishSkinMesh;

	private float blendLeftTurn;
	private float blendRightTurn;
	private float blendLookUp;
	private float blendLookDown;
   
	public float speedReference;   

	private void Start()
	{
		fishSkinMesh = fishGameObject.GetComponent<SkinnedMeshRenderer>();

		blendLeftTurn = 0.0f;
		blendRightTurn = 0.0f;
		blendLookUp = 0.0f;
		blendLookDown = 0.0f;

		movespeed = 2f;
	}
	
	// Update is called once per frame
	void Update () 
	{
		// ------------------------------------------------------
		// Player Inputs:

        float h = Input.GetAxis("Horizontal");		// Side to side
        float v = Input.GetAxis("Vertical");		// Forward
        float b = Input.GetAxis("Bertical");		// Up and down
        //Debug.Log(v);


		// ------------------------------------------------------
		// Forward Speed:
        if (Input.GetKeyDown(KeyCode.LeftShift))
        {
            movespeed += 1f;
        }
        if (Input.GetKeyUp(KeyCode.LeftShift))
        {
            movespeed -= 1f;
        }


		// ------------------------------------------------------
		// Up and Down:
        if (inverted)
        {
            transform.Rotate(Vector3.right, (50 * b) * Time.deltaTime);
        }
        else
        {
            transform.Rotate(Vector3.right, (50 * -b) * Time.deltaTime);
        }

		verticalScale = (b * 50);
		if (verticalScale > 0)
		{
			blendLookDown = verticalScale;
		}
		else if (verticalScale < 0)
		{
			blendLookUp = Mathf.Abs(verticalScale);
		}
		else 
		{
			blendLookUp = 0;
			blendLookDown = 0;
		}

		fishSkinMesh.SetBlendShapeWeight (2, blendLookUp);
		fishSkinMesh.SetBlendShapeWeight (3, blendLookDown);


		// ------------------------------------------------------
		// Left and Right:

		turnAmount = (h * 50);
		if (turnAmount > 0)
		{
			blendRightTurn = turnAmount;
		}
		else if (turnAmount < 0)
		{
			blendLeftTurn = Mathf.Abs(turnAmount);
		}
		else 
		{
			blendLeftTurn = 0;
			blendRightTurn = 0;
		}
			
		fishSkinMesh.SetBlendShapeWeight (0, blendLeftTurn);
		fishSkinMesh.SetBlendShapeWeight (1, blendRightTurn);


		// ------------------------------------------------------
		// Move and Rotate:

        transform.RotateAround(Vector3.up, (h) * Time.deltaTime);
        transform.Translate((Vector3.forward * v) * movespeed * Time.deltaTime / 2);
		speedReference = v;
    }
}
