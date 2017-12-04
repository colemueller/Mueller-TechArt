using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class KelpMove : MonoBehaviour
{
    //public Transform target;
    public float smoothTime = 4F;
    private float yVelocity = 0.0F;
    private static bool Direction = false; //up = true, down = false

    // Update is called once per frame
    void Update()
    {
        float curAcc = transform.GetComponent<Cloth>().externalAcceleration.x;

        if (Direction == true)
        {
            float newPosition = Mathf.SmoothDamp(curAcc, 0.4F, ref yVelocity, smoothTime);
            transform.GetComponent<Cloth>().externalAcceleration = new Vector3(newPosition, 0, (newPosition*-1));

            if (curAcc >= 0.38F)
            {
                Direction = false;
            }
        }

        if (Direction == false)
        {
            float newPosition = Mathf.SmoothDamp(curAcc, -0.4F, ref yVelocity, smoothTime);
            transform.GetComponent<Cloth>().externalAcceleration = new Vector3(newPosition, 0, (newPosition*-1));

            if (curAcc <= -0.38F)
            {
                Direction = true;
            }
        }

       
    }
}
