Shader "Custom/Dissolve Shader" {
	Properties {
		_MainTex ("Texture (RGB)", 2D) = "white" {}
		_Color ("Color", Color) = (1,1,1,1)
		_DissolveMap ("Dissolve Map (RGB)", 2D) = "white" {}
		_DissolveAmount ("Dissolve Amount", Range(0.0, 1.0)) = 0.5
		_EmissionSize ("Emissive Edge Size", Range(0.0, 1.0)) = 0.15
		_EmissionRamp ("Emissive Edge Ramp", 2D) = "white" {}
		_Cutoff ("Alpha Cutoff", Range(0,1)) = 0.5
		//_CutTex ("Cutout (A)", 2D) = "white" {}
	}

	SubShader {
		Tags { "RenderType" = "Opaque"}
		Cull Off

		CGPROGRAM
		#pragma surface surf Lambert alphatest:_Cutoff addshadow
		#pragma target 2.0
		#pragma glsl

		sampler2D _MainTex;
		sampler2D _DissolveMap;
		sampler2D _EmissionRamp;
		fixed4 _Color;
		float _DissolveAmount;
		float _EmissionSize;
		//sampler2D _CutTex;
		//float _Cutoff;

		struct Input {
			float2 uv_MainTex;
			float2 uv_DissolveMap;
			//float _DissolveAmount;
		};

		void surf (Input IN, inout SurfaceOutput o){
			clip(tex2D(_DissolveMap, IN.uv_DissolveMap).rgb - _DissolveAmount);
			fixed4 mainTex = tex2D(_MainTex, IN.uv_MainTex);
			//float ca = tex2D(_CutTex, IN.uv_MainTex).a;
			o.Albedo = mainTex.rgb * _Color.rgb;
			o.Alpha = mainTex.a * _Color.a;
	
			half test = tex2D(_DissolveMap, IN.uv_MainTex).rgb - _DissolveAmount;
			if (test < _EmissionSize && _DissolveAmount > 0 && _DissolveAmount < 1){
				float2 EmissionUVs = float2(test * (1 / _EmissionSize), 0);
				o.Emission = tex2D(_EmissionRamp, EmissionUVs);
				o.Albedo *= o.Emission;
			}

			/*if (ca > _Cutoff){
				o.Alpha = c.a;
			}
			else{
				o.Alpha = 0;
			}*/
			
		}
		ENDCG
	
	}
	FallBack "Diffuse"
}
