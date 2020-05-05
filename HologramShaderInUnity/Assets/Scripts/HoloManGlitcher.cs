using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class HoloManGlitcher : MonoBehaviour {


	public float glitchChance = 0.1f;

	private SkinnedMeshRenderer holoRenderer;
	private WaitForSeconds glitchLoopWait = new WaitForSeconds(.1f);
	private WaitForSeconds glitchDuration = new WaitForSeconds(.1f);

	void Awake()
	{
		holoRenderer = GetComponent<SkinnedMeshRenderer> ();
	}

    //turn start into a coroutine that is looping every 0.1 seconds - checks for a random number between 0 and 1
	IEnumerator Start () 
	{
		while (true) 
		{
			float glitchTest = Random.Range (0f, 1f);

			if (glitchTest <= glitchChance) //fire off the glitch effect
			{
				StartCoroutine (Glitch ());
			}
			yield return glitchLoopWait;
		}


	}

	IEnumerator Glitch()
	{
		glitchDuration = new WaitForSeconds(Random.Range(.05f,.25f));

        //addressing the properties of the shader - need to match exactly
		holoRenderer.material.SetFloat ("_Amount", 1f);
		holoRenderer.material.SetFloat ("_CutoutThresh", .29f);
		holoRenderer.material.SetFloat ("_Amplitude", Random.Range (100, 250));
		holoRenderer.material.SetFloat ("_Speed", Random.Range (1, 10));
		yield return glitchDuration;
		holoRenderer.material.SetFloat ("_Amount", 0f);
		holoRenderer.material.SetFloat ("_CutoutThresh", 0f);
	}

}
