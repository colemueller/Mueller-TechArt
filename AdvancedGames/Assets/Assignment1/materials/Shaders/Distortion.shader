Shader "Custom/GrabPassInvert"
{
	Properties
	{
		_NoiseTex("Texture", 2D) = "white" {}
		_DistortMod("Distortion Modifier", Float) = 50
	}
    SubShader
    {
        // Draw ourselves after all opaque geometry
        Tags { "Queue" = "Transparent" }

        // Grab the screen behind the object into _BackgroundTexture
        GrabPass
        {
            "_BackgroundTexture"
        }

        // Render the object with the texture generated above, and invert the colors
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            struct v2f
            {

                float4 grabPos : TEXCOORD0;
                float4 pos : SV_POSITION;
				float3 worldNormal : TEXCOORD1;
            };

            v2f vert(appdata_base v, float3 normal : NORMAL){
                v2f o;
                // use UnityObjectToClipPos from UnityCG.cginc to calculate 
                // the clip-space of the vertex
                o.pos = UnityObjectToClipPos(v.vertex);
                // use ComputeGrabScreenPos function from UnityCG.cginc
                // to get the correct texture coordinate
                o.grabPos = ComputeGrabScreenPos(o.pos);
				o.worldNormal = UnityObjectToWorldNormal(normal);

				
                return o;
            }

            sampler2D _BackgroundTexture;
			sampler2D _NoiseTex;
			float _DistortMod;

            float4 frag(v2f i) : SV_Target
            {
				float offset = float (tex2D(_NoiseTex, float2(i.pos.x / _DistortMod,i.pos.y/ _DistortMod) ).r);
				float4 bgcolor = tex2Dproj(_BackgroundTexture, i.grabPos + (i.worldNormal.x * .5 + .5)+ offset)+ i.worldNormal.x;
				
                return bgcolor;
            }
            ENDCG
        }

    }
}