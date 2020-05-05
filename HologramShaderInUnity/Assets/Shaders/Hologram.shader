Shader "Unlit/SpecialFX/Hologram"
{
	Properties
	{
		_MainTex ("Albedo Texture", 2D) = "white" {} 
		_TintColor("Tint Colour", Color) = (1,1,1,1)
		_Transparency("Transparency", Range(0.0,0.5)) = 0.25 //limit alpha to a range - ordering issues if too high 
        _CutoutThresh("Cutout Threshold", Range(0.0,1.0)) = 0.2
        _Distance("Distance", Float) = 1
        _Amplitude("Amplitude", Float) = 1
        _Speed ("Speed", Float) = 1
        _Amount("Amount", Range(0.0,1.0)) = 1
	}
	SubShader
	{
 		Tags { "Queue" = "Transparent" "RenderType"="Transparent" }
		LOD 100
		ZWrite Off //or semi-transparent effects, don't render to the depth buffer 
		Blend SrcAlpha OneMinusSrcAlpha //blend things using the alpha channel 

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc" //preprocessor directives - helper functions for rendering

			//objects which contain 2 variables each
			//pass in info about vertices - they are going to be passed in a packed array(contains 4 floating point numbers xyzw)
			struct appdata
			{
				float4 vertex : POSITION; //semantic binding to tell the shader how this is going to be used in rendering
				//pass in the vertices in its own coordinate space or relative in its local space
				float2 uv : TEXCOORD0; //texture coordinates - pass in the uvs for the model, bind these 2 texture coordinates0
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION; //screen space position
			};

			sampler2D _MainTex;
			float4 _MainTex_ST; //necessary helper to use TRANSFORM_TEX
			float4 _TintColor;
            float _Transparency;
            float _CutoutThresh;
            float _Distance;
            float _Amplitude;
            float _Speed;
            float _Amount;
			
			//glitch effect where the vertices are moving
			//converts from object space to clip space relative to the camera
			//pass in appdata into vert function 
			v2f vert (appdata v)
			{
				v2f o; //vert to frag returns struct from the vertex function and pass it into the fragment function
				v.vertex.y += sin(_Time.y * _Speed + v.vertex.y * _Amplitude) * _Distance * _Amount;
				o.vertex = UnityObjectToClipPos(v.vertex); //the vertex in the model's local object space - convert to screen space coordinates useful for pixels on a flat screen
				//taking the uv data from the model's main texture, transform the uv texture(offset and tiling)
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				return o;
			}
			
			//take in a v2f struct and bound to a render target output(frame buffer for the screen) 
			fixed4 frag (v2f i) : SV_Target
			{
				// sample the texture's rgba colour channel - read in the colour from the main texture and the uvs from the v2f struct 
				fixed4 col = tex2D(_MainTex, i.uv) + _TintColor; //additive neon colour effect. For non-additive tint, use multiply or divide
				col.a = _Transparency; //set the alpha of colour to be the value from the public transparency slider
				clip(col.r - _CutoutThresh);
				return col;
			}
			ENDCG
		}
	}
}
