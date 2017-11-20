﻿Shader "Custom/vignette"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_VigTex ("Vignette Texture", 2D) = "white" {}
		_Color ("Tint Color", Color) = (1,1,1,1)
		//_VigColor("Vignette Color", Color) = (1,1,1,1)
		_ColorIntensity("Color Intensity", float) = 1
		_VigIntensity("Vignette Intensity", float) = 1
		_Brightness("Brightness", float) = 1
	}

	SubShader
	{
		// No culling or depth
		Cull Off ZWrite Off ZTest Always

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"



			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
			};

			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv;
				return o;
			}
			
			sampler2D _MainTex;
			sampler2D _VigTex;
			fixed4 _Color;
			//fixed4 _VigColor;
			float _ColorIntensity;
			float _VigIntensity;
			float _Brightness;

			fixed4 frag (v2f i) : SV_Target
			{
				fixed4 col = tex2D(_MainTex, i.uv);
				// just invert the colors
				

				fixed4 vig = tex2D(_VigTex, i.uv);

				col *= (1 - vig.a * _VigIntensity);

				col *= (_Color * _ColorIntensity);


				return col * _Brightness;
			}
			ENDCG
		}
	}
}
