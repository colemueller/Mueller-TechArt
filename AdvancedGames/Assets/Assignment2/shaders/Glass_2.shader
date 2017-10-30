Shader "Custom/Glass 2" {

	Properties {

		_MainTex ("Albedo (RGB)", 2D) = "white" {}

		// Color is used only to set influence of alpha
		_Color ("Color", Color) = (1,1,1,1)

		// Reflection Map
		_Cube ("Reflection Cubemap", Cube) = "" {}

		// Reflection Tint - leave as white to display reflection texture exactly as cubemap
		_ReflectColor ("Reflection Color", Color) = (1,1,1,0.5)

		_ReflectBrightness ("Reflection Brightness", Float) = 1.0

		_SpecularMap ("Sepcular Map", 2D) = "white" {}
		
		_RimColor ("Rim Color", Color) = (1,1,1,0)

		_BumpMap ("Normal Map", 2D) = "white" {}
		_BumpIntensity ("Normal Map Intensity", Range(-100,100)) = 1.0

	}

	SubShader {

		Tags {
			"Queue" = "Transparent"
			"IgnoreProjector" = "True"
			"RenderType" = " Transparent" 
		}

		Cull Back
		
		CGPROGRAM
		#pragma surface surf Standard fullforwardshadows alpha
		#pragma target 3.0

		// Input is basically the easier version of the vert function in shaders
		struct Input {
			float2 uv_BumpMap;
			float2 uv_MainTex;
			float3 worldRefl;
			float3 viewDir;
			float3 worldNormal;
    		INTERNAL_DATA
		};

		sampler2D _MainTex;
		sampler2D _BumpMap;
		sampler2D _SpecularMap;
		samplerCUBE _Cube;
		fixed4 _ReflectColor;
		fixed4 _Color;
		fixed4 _RimColor;
		fixed _ReflectBrightness;
		half _BumpIntensity;

		/* IS THIS IMPORTANT? WHAT IS IT?
		// Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
		// See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
		// #pragma instancing_options assumeuniformscaling
		UNITY_INSTANCING_CBUFFER_START(Props)
			// put more per-instance properties here
		UNITY_INSTANCING_CBUFFER_ENDm
		*/

		/*
		Surf is the simpler version of the v2f function
		*/

		void surf (Input IN, inout SurfaceOutputStandard o) 
		{
			//Diffuse Texture
			fixed4 c = tex2D (_MainTex, IN.uv_MainTex);
			o.Albedo = c.rgb;
			
			//Color is transparancy (how transparent the surface is)
			o.Alpha = _Color.a * c.a;

			//Normal Map
			o.Normal = UnpackNormal (tex2D (_BumpMap, IN.uv_BumpMap) * _BumpIntensity);
			float3 worldNormal = WorldNormalVector (IN, o.Normal);

			//Specular Map
			fixed specular = tex2D(_SpecularMap, IN.uv_MainTex).r;
			o.Metallic = specular;

			//Reflection Cube
			fixed4 reflcol = texCUBE (_Cube, IN.worldRefl);
			//reflcol *= c.a;
			o.Emission = reflcol.rgb * _ReflectColor.rgb * _ReflectBrightness;
			o.Alpha = o.Alpha * _ReflectColor.a;

			//Rim Lighting
			fixed intensity = 1.0 - saturate(dot (normalize(IN.viewDir), o.Normal));
			o.Emission += intensity * _RimColor.rgb * _ReflectBrightness;

			//o.Metallic = _Metallic;
			//o.Smoothness = _Glossiness;
		}

		ENDCG
	}
	FallBack "Diffuse"
}