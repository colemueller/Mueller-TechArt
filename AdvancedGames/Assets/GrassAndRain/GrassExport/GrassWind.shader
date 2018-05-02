
Shader "Grass/GrassWind" {

	Properties
	{
		_Color ("Color", Color) = (1,1,1,1)
		_MainTex("Albedo (RGB)", 2D) = "white" {}
		_Cutoff("Alpha cutoff", Range(0,1)) = 0.1
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

		_Phase("Phase", Range(-10, 10)) = 0
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
		half _Cutoff;
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

		float _Phase;
		float _HeadLimit;


		void vert( inout appdata_full v )
		{
			//Y AXIS

			// If the vertices are beyond the HeadLimit
			if (v.vertex.y > _HeadLimit)
			{
				// y(t)    += sin(              ωt                           + θ    ) * A           * _HeadLimit
				v.vertex.y += sin(((0.05 + _Time.y * _SpeedY) * _FrequencyY) + _Phase) * _AmplitudeY * _HeadLimit;
			}
			// If the vertices are within the HeadLimit
			else
			{
				v.vertex.y += sin(((v.vertex.z + _Time.y * _SpeedY) * _FrequencyY) + _Phase) * _AmplitudeY * v.vertex.y;
			}

			//Z AXIS

			// If the vertices are beyond the HeadLimit
			if (v.vertex.y > _HeadLimit)
			{
				// y(t)    += sin(              ωt                           + θ    ) * A           * _HeadLimit
				v.vertex.z += sin(((0.05 + _Time.y * _SpeedZ) * _FrequencyZ) + _Phase) * _AmplitudeZ * _HeadLimit;
			}
			// If the vertices are within the HeadLimit
			else
			{
				v.vertex.z += sin(((v.vertex.z + _Time.y * _SpeedZ) * _FrequencyZ) + _Phase) * _AmplitudeZ * v.vertex.y;
			}

			//X Axis
			// If the vertices are beyond the HeadLimit
			if (v.vertex.y > _HeadLimit)
			{
				// y(t)    += sin(              ωt                           + θ    ) * A           * _HeadLimit
				v.vertex.x += sin(((0.05 + _Time.y * _SpeedX) * _FrequencyX) + _Phase) * _AmplitudeX * _HeadLimit;
			}
			// If the vertices are within the HeadLimit
			else
			{
				v.vertex.x += sin(((v.vertex.z + _Time.y * _SpeedX) * _FrequencyX) + _Phase) * _AmplitudeX * v.vertex.y;
			}


		}

		void surf (Input IN, inout SurfaceOutputStandard o) 
		{
			// Albedo comes from a texture tinted by color
			fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
			clip(c.a - _Cutoff);
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