using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Waypoints : MonoBehaviour {

	public Transform[] waypoints;
	public float speed;
	public float rotation_damping;

	private int current;

	private void Update()
	{
		if (transform.position != waypoints[current].position)
		{
			Vector3 pos = Vector3.MoveTowards (transform.position, waypoints [current].position, speed * Time.deltaTime);
			LookAtTarget (waypoints [current].position);
			GetComponent<Rigidbody> ().MovePosition (pos);
		}
		else
		{
			current = (current + 1) % waypoints.Length;
		}
	}

	void LookAtTarget(Vector3 target_position)
	{
		Vector3 direction = target_position - transform.position;
		var rotation = Quaternion.LookRotation(direction);
		transform.rotation = Quaternion.Slerp(transform.rotation, rotation, Time.deltaTime * rotation_damping);
	}
}
