using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GetFood : MonoBehaviour {

    public Controller fishController;
    public GameObject BubbleBoost;
    float tempSpeed;
    bool goUp = false;
    float refVal = 0.0f;

    private void OnTriggerEnter(Collider other)
    {
        if (other.CompareTag("food"))
        {
            //fishController.movespeed = Mathf.Lerp(fishController.movespeed, fishController.movespeed * 3, 1 * Time.deltaTime);
            goUp = true;
            BubbleBoost.SetActive(true);
            StartCoroutine(slowDown(1));
            //for(int i = 0; i < other.transform.childCount; i++)
            //{
            //    other.transform.GetChild(i).gameObject.SetActive(false);
            //}
            Destroy(other.gameObject);
        }
    }

    IEnumerator slowDown (float time)
    {
        
        yield return new WaitForSeconds(1);
        goUp = false;

        yield return new WaitForSeconds(3);
        Debug.Log("SLOW DOWN");
        BubbleBoost.SetActive(false);
        //fishController.movespeed = Mathf.Lerp(fishController.movespeed, 2, 2);
        
    }

    private void Update()
    {
        if (goUp)
        {
            tempSpeed = Mathf.SmoothDamp(fishController.movespeed, 4, ref refVal, 0.5f);
        }
        else
        {
            tempSpeed = Mathf.SmoothDamp(fishController.movespeed, 2, ref refVal, 3);
        }
        fishController.movespeed = tempSpeed;
    }
}
