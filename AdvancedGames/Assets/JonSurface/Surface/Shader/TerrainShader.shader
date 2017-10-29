Shader "Custom/TerrainShader" 
{
	Properties 
	{
		_Texture01("Texture Map 01", 2D) = "white" {}
		_Texture02("Texture Map 02", 2D) = "white" {}
		_Texture03("Texture Map 03", 2D) = "white" {}

		_Normal01("Normal Map 01", 2D) = "bump" {}
		_Normal02("Normal Map 02", 2D) = "bump" {}
		_Normal03("Normal Map 03", 2D) = "bump" {}

		_NormalStrength("Normal Strength", Range(0.01, 3.0)) = 1

		_BlendHeight01("Blend Height", Range(-0.5, 0.5)) = 0
		_BlendAreaSize01("Blend Area Size", Range(0.0 ,1.0)) = 0

		_BlendHeight02("Blend Height 2", Range(-0.5, 0.5)) = 0
		_BlendAreaSize02("Blend Area Size 2", Range(0.0 ,1.0)) = 0
	}

	SubShader 
	{

		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		#pragma surface surf Lambert fullforwardshadows
		#pragma target 3.0


		struct Input 
		{
			float2 uv_Texture01;
			float2 uv_Texture02;
			float2 uv_Texture03;

			float2 uv_Normal01;
			float2 uv_Normal02;
			float2 uv_Normal03;

			float3 worldPos;
		};

		sampler2D _Texture01;
		sampler2D _Texture02;
		sampler2D _Texture03;

		sampler2D _Normal01;
		sampler2D _Normal02;
		sampler2D _Normal03;

		float _NormalStrength;

		float _BlendHeight01;
		float _BlendHeight02;

		float _BlendAreaSize01;
		float _BlendAreaSize02;

		void surf (Input IN, inout SurfaceOutput o) 
		{
			// Texture Inputs
			half4 Tex01 = tex2D(_Texture01, IN.uv_Texture01);
 			half4 Tex02 = tex2D(_Texture02, IN.uv_Texture02);
 			half4 Tex03 = tex2D(_Texture03, IN.uv_Texture03);

 			half4 Norm01 = tex2D(_Normal01, IN.uv_Texture01);
 			half4 Norm02 = tex2D(_Normal02, IN.uv_Texture02);
 			half4 Norm03 = tex2D(_Normal03, IN.uv_Texture03);

 			Norm01.z = Norm01.z / _NormalStrength;
 			Norm02.z = Norm02.z / _NormalStrength;
 			Norm03.z = Norm03.z / _NormalStrength;

			// Shader blends and final color

			// Texture 1 -> Texture 2
 			float blendFactor01 = clamp((IN.worldPos.y - _BlendHeight01 - (_BlendAreaSize01 * 0.5)) / _BlendAreaSize01, 0, 1);
 			float4 blendedTexture01 = lerp(Tex01,Tex02,blendFactor01);
 			float4 blendedNormal01 = lerp(Norm01, Norm02, blendFactor01);

 			// Texture 2 -> Texture 3
 			float blendFactor02 = clamp((IN.worldPos.y - _BlendHeight02 - (_BlendAreaSize02 * 0.5)) / _BlendAreaSize02, 0, 1);
 			float4 blendedTexture02 = lerp(Tex02,Tex03,blendFactor02);
 			float4 blendedNormal02 = lerp(Norm02, Norm03, blendFactor02);

 			float4 blendedTexture = blendedTexture01 * blendedTexture02;
 			float4 blendedNormal = blendedNormal01 * blendedNormal02;

 			o.Albedo = blendedTexture.rgb;
 			o.Normal = UnpackNormal(Norm01);
		}
		ENDCG
	}
	FallBack "Diffuse"
}