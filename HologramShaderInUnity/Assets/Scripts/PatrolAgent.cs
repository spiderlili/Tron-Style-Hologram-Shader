using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.AI;

public class PatrolAgent : MonoBehaviour {

	public Transform[] waypoints;

	private NavMeshAgent agent;
	private int nextWayPoint;

	void Awake () 
	{
		agent = GetComponent<NavMeshAgent> ();	
	}
	
	// Update is called once per frame
	void Update () 
	{
		Patrol ();
	}

	void Patrol()
	{
		agent.destination = waypoints [nextWayPoint].position;
		agent.isStopped = false;

		if (agent.remainingDistance <= agent.stoppingDistance && !agent.pathPending) 
		{
			nextWayPoint = (nextWayPoint + 1) % waypoints.Length;
		}
	}
}