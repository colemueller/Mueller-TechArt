// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'


//================== READ ME ======================
//
// This shader is busted. To see it's most recent 
// working version, comment out all of the
// "LIGHTING STUFF" lines and uncomment any lines
// that are marked as commented out because of lighting.
//
//=================================================


Shader "Custom/GrassGeometry" {
	Properties {
		//[HDR]_BackgroundColor("Background Color", Color) = (1,0,0,1)
		//[HDR]_ForegroundColor("Foreground Color", Color) = (0,0,1,1)
		_Tint ("Tint", Color) = (1,1,1,1)
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		//_Glossiness ("Smoothness", Range(0,1)) = 0.5
		//_Metallic ("Metallic", Range(0,1)) = 0.0
		//_Cutoff("cutoff", Range(0,1)) = 0.25

		//=========== Size Variables =================

		//_NoiseTex("Size Noise", 2D) = "white" {}
		//_HeightMin("Height Minimum", int) = 0
		//_HeightMax("Height Maximum", int) = 2
		_GrassHeight("Grass Height", Float) = 0.25

		//_WidthMin("Width Minimum", int) = 0
		//_WidthMax("Width Maximum", int) = 2
		_GrassWidth("Grass Width", Float) = 0.25

		//============================================


		_Cutoff("Alpha cutoff", Range(0,1)) = 0.1
		_WindSpeed("Wind Speed", Float) = 100
		_WindStrength("Wind Strength", Float) = 0.05
		_WindVariance("Wind Varience", Float) = 1
		//_DeformationMap("Deformation Map", 2D) = "green" {}

	}

	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200

		Pass
	{

		//CULL OFF

		Tags { "LightMode"="ForwardBase" }

		CGPROGRAM

		#pragma vertex vert
		#pragma fragment frag
		#pragma geometry geom

		#include "UnityCG.cginc"
		#include "UnityLightingCommon.cginc" // Lighting stuff

		// Use shader model 4.0 target, to get geometry support
		#pragma target 4.0

		sampler2D _MainTex;
		//sampler2D _NoiseTex;
		//sampler2D _DeformationMap;

		struct v2g
		{
			float4 pos : SV_POSITION;

			//LIGHTING STUFF
			float4 diff : COLOR0;
			//==============

			float3 norm : NORMAL;
			float2 uv : TEXCOORD0;
			float3 color : TEXCOORD1;
		};

		struct g2f
		{
			float4 pos : SV_POSITION;

			//LIGHTING STUFF
			float4 diff : COLOR0;
			//==============

			float3 norm : NORMAL;
			float2 uv : TEXCOORD0;
			float3 diffuseColor : TEXCOORD1;
		};

		//half _Glossiness;
		//half _Metallic;
		//fixed4 _BackgroundColor;
		//fixed4 _ForegroundColor;
		//half _HeightMin;
		//half _HeightMax;
		//half _WidthMin;
		//half _WidthMax;
		half _GrassHeight;
		half _GrassWidth;
		half _Cutoff;
		half _WindStrength;
		half _WindSpeed;
		half _WindVariance;
		fixed4 _Tint;

		v2g vert(appdata_full v)
		{
			float3 v0 = v.vertex.xyz;

			v2g OUT;
			OUT.pos = v.vertex;  //replaced by lighting stuff, uncomment for working grass
			//OUT.pos = UnityObjectToClipPos(v.vertex); //LIGHTING STUFF
			//================
			OUT.norm = v.normal;
			OUT.uv = v.texcoord;

			//LIGHTING STUFF
			half3 worldNormal = UnityObjectToWorldNormal(v.normal);
			half nl = max(0, dot(worldNormal, _WorldSpaceLightPos0.xyz));
			OUT.diff = nl * _LightColor0;
			//==============

			OUT.color = tex2Dlod(_MainTex, v.texcoord).rgb;
			return OUT;
		}

		//int Random (int numMin, int numMax, float2 uv)
		//{
		//	int cap = numMax - numMin;
		//	int randNum = tex2D(_NoiseTex, uv + _Time.x).r * cap + numMin;
		//	return randNum;
		//}

		void buildQuad(inout TriangleStream<g2f> triStream, float3 points[4], float3 color)
		{
			g2f OUT;
			float3 faceNormal = cross(points[1] - points[0], points[2] - points[0]);
			for(int i = 0; i < 4; ++i) 
			{
				OUT.pos = UnityObjectToClipPos(points[i]);
				OUT.norm = faceNormal;
				OUT.diffuseColor = color;
				OUT.uv = float2(i % 2, (int)i/2);

				//LIGHTING STUFF
				half3 worldNormal = UnityObjectToWorldNormal(points[i]);
				half nl = max(0, dot(worldNormal, _WorldSpaceLightPos0.xyz));
				OUT.diff = _LightColor0;
				//===============

				triStream.Append(OUT);
			}
			triStream.RestartStrip();
		}



		[maxvertexcount(24)]
		void geom(point v2g IN[1], inout TriangleStream<g2f> triStream)
		{
			float3 lightPosition = _WorldSpaceLightPos0;
			//float3 normal = tex2Dlod(_DeformationMap, IN[0].uv);


			float3 perpendicularAngle = float3(0,0,1);
			float3 faceNormal = cross(perpendicularAngle, IN[0].norm);

			float3 v0 = IN[0].pos.xyz;
			float3 v1 = IN[0].pos.xyz + IN[0].norm * _GrassHeight; // replaced IN[0].norm with normal
			//float3 v1 = IN[0].pos.xyz + IN[0].norm * Random(_HeightMin, _HeightMax, IN[0].uv);    // Random height in given range

			float3 wind = float3(sin(_Time.x * _WindSpeed + v0.x) + sin(_Time.x * _WindSpeed + v0.z * 2 * _WindVariance),
			0,
			cos(_Time.x * _WindSpeed + v0.x * 2 * _WindVariance) + cos(_Time.x * _WindSpeed + v0.z));
			v1 += wind * _WindStrength;

			float3 color = (IN[0].color);

			float sin30 = 0.5;
			float sin60 = 0.866;
			float cos30 = sin60;
			float cos60 = sin30;

			g2f OUT;

			//Quad 1
			
			float3 quad1[4] =  {
				//Random(_WidthMin, _WidthMax, IN[0].uv), _GrassWidth
				v0 + perpendicularAngle * 0.5 * _GrassWidth,
				v0 - perpendicularAngle * 0.5 * _GrassWidth,
				v1 + perpendicularAngle * 0.5 * _GrassWidth,
				v1 - perpendicularAngle * 0.5 * _GrassWidth
			};
			buildQuad(triStream, quad1, color);


			//Quad 2
			
			float3 quad2[4] =  {
				v0 + float3(sin60, 0, -cos60) * 0.5 * _GrassWidth,
				v0 - float3(sin60, 0, -cos60) * 0.5 * _GrassWidth,
				v1 + float3(sin60, 0, -cos60) * 0.5 * _GrassWidth,
				v1 - float3(sin60, 0, -cos60) * 0.5 * _GrassWidth
			};
			buildQuad(triStream, quad2, color);


			//Quad 3
			
			float3 quad3[4] =  {
				v0 + float3(sin60, 0, cos60) * 0.5 * _GrassWidth,
				v0 - float3(sin60, 0, cos60) * 0.5 * _GrassWidth,
				v1 + float3(sin60, 0, cos60) * 0.5 * _GrassWidth,
				v1 - float3(sin60, 0, cos60) * 0.5 * _GrassWidth
			};
			buildQuad(triStream, quad3, color);
			

		}

		half4 frag(g2f IN) : Color
		{
			fixed4 c = tex2D(_MainTex, IN.uv);
			clip(c.a - _Cutoff);


			c *= _Tint; //original return
			return c * IN.diff; //Lighting return -- was originally "return c * _Tint;"
			//return c;
			//return float4(IN.diffuseColor.rgb, 1.0);
		}

			ENDCG

		}
		
		}
	
}
