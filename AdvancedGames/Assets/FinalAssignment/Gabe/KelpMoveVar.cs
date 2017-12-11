using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class KelpMoveVar : MonoBehaviour
{
    //public Transform target;
    float smoothTime = 4.5F;
    float xVelocity = 0.3F;
    float yVelocity = 0.0F;
    bool Direction = false; //up = true, down = false

    // Update is called once per frame
    void Update()
    {
        float curAcc = transform.GetComponent<Cloth>().externalAcceleration.x;

        if (Direction == true)
        {
            float newPosition = Mathf.SmoothDamp(curAcc, (xVelocity), ref yVelocity, smoothTime);
            transform.GetComponent<Cloth>().externalAcceleration = new Vector3(newPosition, 0, (newPosition*-1));

            if (curAcc >= (xVelocity - 0.02F))
            {
                Direction = false;
            }
        }

        if (Direction == false)
        {
            float newPosition = Mathf.SmoothDamp(curAcc, (xVelocity*-1), ref yVelocity, smoothTime);
            transform.GetComponent<Cloth>().externalAcceleration = new Vector3(newPosition, 0, (newPosition*-1));

            if (curAcc <= ((xVelocity - 0.02F) * -1))
            {
                Direction = true;
            }
        }

       
    }
}
