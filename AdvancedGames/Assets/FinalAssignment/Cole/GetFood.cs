using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GetFood : MonoBehaviour {

	// ------------------------------------------------------
	// VARIABLES --------------------------------------------
	// ------------------------------------------------------

    public Controller fishController;
    public GameObject BubbleBoost;

    private float tempSpeed;
    public bool goUp = false;
    private float refVal = 0.0f;


	// ------------------------------------------------------
	// BlendShapes:

	public GameObject fishGameObject;
	private SkinnedMeshRenderer fishSkinMesh;
	private float blendBite;


	// ------------------------------------------------------
	// Smooth Sine Transition:

	public Material swimCycleMat;
	private float SpeedZ;
	private float AmplitudeZ;
	private float HeadLimit;
	private float VertexZ;

	private float frequency = 4.0f;
	private float _frequency;
	private float phase = 0.0f;


	// ------------------------------------------------------
	void Start () 
	{
		_frequency = frequency;  

		// BlendShapes
		fishSkinMesh = fishGameObject.GetComponent<SkinnedMeshRenderer>();
		blendBite = 0.0f;

		// Shader Values
		SpeedZ = swimCycleMat.GetFloat ("_SpeedZ");
		AmplitudeZ = swimCycleMat.GetFloat ("_AmplitudeZ");
		HeadLimit = swimCycleMat.GetFloat ("_HeadLimit");
	}
		

	// ------------------------------------------------------
	// Coroutines:

    IEnumerator slowDown (float time)
    {
        yield return new WaitForSeconds(1);
        goUp = false;

        yield return new WaitForSeconds(3);
        Debug.Log("SLOW DOWN");
        BubbleBoost.SetActive(false);
        //fishController.movespeed = Mathf.Lerp(fishController.movespeed, 2, 2);
    }

	IEnumerator playBiteAnim (float time)
	{
		blendBite = 0;

		while (blendBite < 100) 
		{
			yield return new WaitForSeconds (0.0001f);
			blendBite += 1;
		}

		yield return null;
	}


	// ------------------------------------------------------
    private void Update()
	{
        //HOLD ON THERE BOI! SLOW DOWN
        if(fishController.movespeed > 4)
        {
            fishController.movespeed = 4;
        }
		// ------------------------------------------------------
		// BOOST SPEED:

		if (goUp) 
		{
			tempSpeed = Mathf.SmoothDamp (fishController.movespeed, 4, ref refVal, 1);
		} 
		else 
		{
            float refVal2 = 0.0f; 
			tempSpeed = Mathf.SmoothDamp (fishController.movespeed, 2, ref refVal2, 3);
		}

		fishController.movespeed = tempSpeed;


		// ------------------------------------------------------
		// FREQUENCY:

		if (fishController.speedReference == 0)
		{ 
			frequency = Mathf.SmoothDamp(swimCycleMat.GetFloat ("_FrequencyZ"), 2.0f, ref refVal, 0.5f);
			//frequency = Mathf.Lerp (swimCycleMat.GetFloat ("_FrequencyZ"), 2.0f, 0.5f);
		}
		else
		{
			if (goUp)
			{
				frequency = Mathf.SmoothDamp(swimCycleMat.GetFloat ("_FrequencyZ"), 8.0f, ref refVal, 0.5f);
				//frequency = Mathf.Lerp (swimCycleMat.GetFloat ("_FrequencyZ"), 8.0f, 0.5f);
			}
			else
			{
				frequency = Mathf.SmoothDamp(swimCycleMat.GetFloat ("_FrequencyZ"), 6.0f,ref refVal, 0.5f);
				//frequency = Mathf.Lerp (swimCycleMat.GetFloat ("_FrequencyZ"), 6.0f, 0.5f);
			}

		}

		// Update frequency
		if (frequency != _frequency)
		{
			CalcNewFreq();
		}

		// Set Values
		swimCycleMat.SetFloat ("_FrequencyZ", _frequency);
		swimCycleMat.SetFloat ("_Phase", phase);

		fishSkinMesh.SetBlendShapeWeight (4, blendBite);
    }


	// ------------------------------------------------------
	// Calculate Frequency ----------------------------------
	// ------------------------------------------------------

	void CalcNewFreq() 
	{
		float curr = (((0.05f + Time.time * SpeedZ) * _frequency) + phase) % (2.0f * Mathf.PI);
		float next = ((0.05f + Time.time * SpeedZ) * frequency) % (2.0f * Mathf.PI);
		phase = curr - next;
		_frequency = frequency;
	}


	// ------------------------------------------------------
	// Collider ---------------------------------------------
	// ------------------------------------------------------

	private void OnTriggerEnter(Collider other)
	{
		if (other.CompareTag("food"))
		{
            StopCoroutine(slowDown(0));
			//fishController.movespeed = Mathf.Lerp(fishController.movespeed, fishController.movespeed * 3, 1 * Time.deltaTime);
			goUp = true;
			BubbleBoost.SetActive(true);
			StartCoroutine(slowDown(1));
			StartCoroutine (playBiteAnim(1));
			//for(int i = 0; i < other.transform.childCount; i++)
			//{
			//    other.transform.GetChild(i).gameObject.SetActive(false);
			//}
			Destroy(other.gameObject);
		}
	}
}
