using UnityEngine;
using System.Collections;

public class SinePhase : MonoBehaviour {

	public float amplitude = 2.0f;
	public float frequency = 0.5f;
	private float _frequency;
	private float phase = 0.0f;
	private Transform trans;

	void Start () {
		_frequency = frequency;    
		trans = transform;
	}

	void Update () {
		if (frequency != _frequency) 
			CalcNewFreq();

		Vector3 v3 = trans.position;

		Debug.Log (Time.time * _frequency + phase);

		v3.x = Mathf.Sin (Time.time * _frequency + phase) * amplitude;
		trans.position = v3;
	}

	void CalcNewFreq() {
		float curr = (Time.time * _frequency + phase) % (2.0f * Mathf.PI);
		float next = (Time.time * frequency) % (2.0f * Mathf.PI);
		phase = curr - next;
		_frequency = frequency;
	}
}