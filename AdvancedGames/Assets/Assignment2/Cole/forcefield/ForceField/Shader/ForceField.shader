
Shader "chenjd/ForceField"
{
Properties
{
	_Color("Color", Color) = (0,0,0,0)
	_NoiseColor("Noise Color", Color) = (0,0,0,0)
	_NoiseTex("NoiseTexture", 2D) = "white" {}
	_RippleSpeed("Ripple Speed", float) = 1
	_RippleScale("Ripple Scale", float) = 1
	_RippleFrequency("Ripple Frequency", float) = 1
	_DistortStrength("DistortStrength", Range(0,1)) = 0.2
	_DistortTimeFactor("DistortTimeFactor", Range(0,1)) = 0.2
	_RimStrength("RimStrength",Range(0, 10)) = 2
	_IntersectPower("IntersectPower", Range(0, 3)) = 2
	_LightAmount("Light Amount", float) = 1
}

SubShader
{
	ZWrite Off
	Cull Off
	Blend SrcAlpha OneMinusSrcAlpha

	Tags
	{
		"RenderType" = "Transparent"
		"Queue" = "Transparent"
		"LightMode" = "ForwardBase"
	}

	GrabPass
	{
		"_GrabTempTex"
	}

Pass
{
	CGPROGRAM
#pragma target 3.0
#pragma vertex vert
#pragma fragment frag
#include "UnityCG.cginc"
#include "UnityLightingCommon.cginc"



	struct appdata
{
	float4 vertex : POSITION;
	float2 uv : TEXCOORD0;
	float3 normal : NORMAL;
};

struct v2f
{
	float4 vertex : SV_POSITION;
	float2 uv : TEXCOORD0;
	float4 screenPos : TEXCOORD1;
	float4 grabPos : TEXCOORD2;
	float3 normal : NORMAL;
	float3 viewDir : TEXCOORD3;
	float4 diff : COLOR0;
};

sampler2D _GrabTempTex;
float4 _GrabTempTex_ST;
sampler2D _NoiseTex;
float4 _NoiseTex_ST;
float _DistortStrength;
float _DistortTimeFactor;
float _RimStrength;
float _IntersectPower;
float _RippleSpeed;
float _RippleScale;
float _RippleFrequency;
float _LightAmount;

sampler2D _CameraDepthTexture;

v2f vert(appdata v)
{
	v2f o;
	o.vertex = UnityObjectToClipPos(v.vertex);

	//waves
	half offsetvert = o.vertex.x;
	half value = _RippleScale * sin(_Time.x * _RippleSpeed + offsetvert * _RippleFrequency);
	o.vertex.y += value;

	o.grabPos = ComputeGrabScreenPos(o.vertex);

	o.uv = TRANSFORM_TEX(v.uv, _NoiseTex);

	o.screenPos = ComputeScreenPos(o.vertex);

	COMPUTE_EYEDEPTH(o.screenPos.z);

	o.normal = UnityObjectToWorldNormal(v.normal);
	half3 worldNormal = UnityObjectToWorldNormal(v.normal);
	half nl = max(0, dot(worldNormal, _WorldSpaceLightPos0.xyz));
	o.diff = nl * _LightColor0;

	o.viewDir = normalize(UnityWorldSpaceViewDir(mul(unity_ObjectToWorld, v.vertex)));

	return o;
}

fixed4 _Color;
fixed4 _NoiseColor;


fixed4 frag(v2f i) : SV_Target
{
	
	float sceneZ = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE_PROJ(_CameraDepthTexture, UNITY_PROJ_COORD(i.screenPos)));
	float partZ = i.screenPos.z;

	float diff = sceneZ - partZ;
	float intersect = (1 - diff) * _IntersectPower;

	
	float3 viewDir = normalize(UnityWorldSpaceViewDir(mul(unity_ObjectToWorld, i.vertex)));
	float rim = 1 - abs(dot(i.normal, normalize(i.viewDir))) * _RimStrength;
	float glow = max(intersect, rim);

	
	float4 offset = tex2D(_NoiseTex, i.uv - _Time.xy * _DistortTimeFactor);
	float4 waterTex = offset * _NoiseColor;

	fixed4 col = _Color * glow + waterTex;
	col *= i.diff + _LightAmount;
	return col;

}

ENDCG
}
}
}