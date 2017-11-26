
Shader "Custom/SwimCycle" {

	Properties
	{
		_Color ("Color", Color) = (1,1,1,1)
		_MainTex("Albedo (RGB)", 2D) = "white" {}
		_Glossiness ("Smoothness", Range(0,1)) = 0.5
		_Metallic ("Metallic", Range(0,1)) = 0.0

		_SpeedX("SpeedX", Range(0, 10)) = 1
		_FrequencyX("FrequencyX", Range(0, 10)) = 1
		_AmplitudeX("AmplitudeX", Range(0, 0.2)) = 1

		_SpeedY("SpeedY", Range(0, 10)) = 1
		_FrequencyY("FrequencyY", Range(0, 10)) = 1
		_AmplitudeY("AmplitudeY", Range(0, 0.2)) = 1

		_SpeedZ("SpeedZ", Range(0, 10)) = 1
		_FrequencyZ("FrequencyZ", Range(0, 10)) = 1
		_AmplitudeZ("AmplitudeZ", Range(0,  2)) = 1

		_HeadLimit("HeadLimit", Range(-2,  2)) = 0.05
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque" }
		LOD 200
		//Cull off

		CGPROGRAM
		#pragma surface surf Standard fullforwardshadows vertex:vert addshadow
		#pragma target 3.0

		sampler2D _MainTex;

		struct Input 
		{
			float2 uv_MainTex;
		};

		half _Glossiness;
		half _Metallic;
		fixed4 _Color;

		// X AXIS

		float _SpeedX;
		float _FrequencyX;
		float _AmplitudeX;

		// Y AXIS

		float _SpeedY;
		float _FrequencyY;
		float _AmplitudeY;

		// Z AXIS

		float _SpeedZ;
		float _FrequencyZ;
		float _AmplitudeZ;

		// Head Limit (Head wont shake so much)

		float _HeadLimit;


		void vert( inout appdata_full v )
		{
			//Z AXIS

			v.vertex.z += sin((v.vertex.z + _Time.y * _SpeedX) * _FrequencyX)* _AmplitudeX;		

			//Y AXIS

			v.vertex.y += sin((v.vertex.z + _Time.y * _SpeedY) * _FrequencyY)* _AmplitudeY;

			//X AXIS

			if (v.vertex.z > _HeadLimit)
			{
				v.vertex.x += sin((0.05 + _Time.y * _SpeedZ) * _FrequencyZ)* _AmplitudeZ * _HeadLimit;
			}
			else
			{
				v.vertex.x += sin((v.vertex.z + _Time.y * _SpeedZ) * _FrequencyZ)* _AmplitudeZ * v.vertex.z;
			}
		}

		void surf (Input IN, inout SurfaceOutputStandard o) 
		{
			// Albedo comes from a texture tinted by color
			fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
			o.Albedo = c.rgb;
			// Metallic and smoothness come from slider variables
			o.Metallic = _Metallic;
			o.Smoothness = _Glossiness;
			o.Alpha = c.a;
		}

		ENDCG
		
	}
	FallBack "Diffuse"
}