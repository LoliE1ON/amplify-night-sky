// Made with Amplify Shader Editor
Shader "E1ON/nightsky"
{
	Properties
	{
		[Gamma]_TintColor("Tint Color", Color) = (0.5,0.5,0.5,1)
		[HDR][Gamma]_Starcolor("Star color", Color) = (0.5,0.5,0.5,1)
		_Exposure("Exposure", Range( 0 , 8)) = 1
		[NoScaleOffset]_Tex("Cubemap (HDR)", CUBE) = "black" {}
		[NoScaleOffset]_Tex1("Cubemap (HDR)", 2D) = "black" {}
		[HideInInspector]_Tex_HDR("DecodeInstructions", Vector) = (0,0,0,0)
		_Fogspeed("Fog speed", Vector) = (0.1,0,0,0)
		_Staropacityspeed("Star opacity speed", Vector) = (0.1,0,0,0)
		_Starcontrast("Star contrast", Float) = 15
		_Startemissionspeed("Start emission speed", Float) = 15
		_TextureSample0("Texture Sample 0", 2D) = "white" {}
		[HideInInspector] _tex3coord( "", 2D ) = "white" {}
	}
	
	SubShader
	{
		
		
		Tags { "RenderType"="Opaque" }
		LOD 100

		CGINCLUDE
		#pragma target 3.0
		ENDCG
		Blend Off
		Cull Back
		ColorMask RGBA
		ZWrite On
		ZTest LEqual
		Offset 0 , 0
		
		
		
		Pass
		{
			Name "Unlit"
			Tags { "LightMode"="ForwardBase" }
			CGPROGRAM

			

			#ifndef UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX
			//only defining to not throw compilation error over Unity 5.5
			#define UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(input)
			#endif
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_instancing
			#include "UnityCG.cginc"
			#include "UnityShaderVariables.cginc"


			struct appdata
			{
				float4 vertex : POSITION;
				float4 color : COLOR;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				float4 ase_texcoord : TEXCOORD0;
			};
			
			struct v2f
			{
				float4 vertex : SV_POSITION;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
				float4 ase_texcoord : TEXCOORD0;
			};

			uniform half4 _Tex_HDR;
			uniform sampler2D _TextureSample0;
			uniform float2 _Fogspeed;
			uniform samplerCUBE _Tex;
			uniform half4 _TintColor;
			uniform half _Exposure;
			uniform sampler2D _Tex1;
			uniform float2 _Staropacityspeed;
			uniform float _Starcontrast;
			uniform half4 _Starcolor;
			uniform float _Startemissionspeed;
			inline half3 DecodeHDR1189( half4 Data )
			{
				return DecodeHDR(Data, _Tex_HDR);
			}
			
			
			v2f vert ( appdata v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				UNITY_TRANSFER_INSTANCE_ID(v, o);

				o.ase_texcoord.xyz = v.ase_texcoord.xyz;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord.w = 0;
				float3 vertexValue = float3(0, 0, 0);
				#if ASE_ABSOLUTE_VERTEX_POS
				vertexValue = v.vertex.xyz;
				#endif
				vertexValue = vertexValue;
				#if ASE_ABSOLUTE_VERTEX_POS
				v.vertex.xyz = vertexValue;
				#else
				v.vertex.xyz += vertexValue;
				#endif
				o.vertex = UnityObjectToClipPos(v.vertex);
				return o;
			}
			
			fixed4 frag (v2f i ) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID(i);
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(i);
				fixed4 finalColor;
				float2 uv01294 = i.ase_texcoord.xyz * float2( 1,1 ) + float2( 0,0 );
				float2 panner1295 = ( 1.0 * _Time.y * _Fogspeed + uv01294);
				float3 uv_Tex413 = i.ase_texcoord.xyz;
				float4 texCUBENode41 = texCUBE( _Tex, uv_Tex413 );
				half4 Data1189 = texCUBENode41;
				half3 localDecodeHDR1189 = DecodeHDR1189( Data1189 );
				float2 uv01305 = i.ase_texcoord.xyz.xy * float2( 1,1 ) + float2( 0,0 );
				float2 panner1307 = ( 1.0 * _Time.y * _Staropacityspeed + uv01305);
				float4 temp_cast_3 = (texCUBENode41.r).xxxx;
				float div1218=256.0/float((int)_Starcontrast);
				float4 posterize1218 = ( floor( temp_cast_3 * div1218 ) / div1218 );
				
				
				finalColor = ( ( tex2D( _TextureSample0, panner1295 ).a * ( float4( localDecodeHDR1189 , 0.0 ) * unity_ColorSpaceDouble * _TintColor * _Exposure ) ) + ( ( tex2D( _Tex1, panner1307 ) * ( posterize1218 * _Starcolor ) ) * ( _SinTime.w + _Startemissionspeed ) ) );
				return finalColor;
			}
			ENDCG
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=17101
0;73;1407;937;-669.2197;-729.8682;2.823603;True;False
Node;AmplifyShaderEditor.SamplerNode;41;2222.675,1522.849;Inherit;True;Property;_Tex;Cubemap (HDR);3;1;[NoScaleOffset];Create;False;0;0;False;0;ed43ce351a868434e83012212f99cc6a;ed43ce351a868434e83012212f99cc6a;True;0;False;black;LockedToCube;False;Object;-1;Auto;Cube;6;0;SAMPLER2D;;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;1306;2342.568,2474.778;Float;False;Property;_Staropacityspeed;Star opacity speed;7;0;Create;True;0;0;False;0;0.1,0;0.01,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TextureCoordinatesNode;1305;2334.224,2355.258;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;1219;2349.885,2744.738;Inherit;False;Property;_Starcontrast;Star contrast;8;0;Create;True;0;0;False;0;15;15;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PosterizeNode;1218;2509.466,2725.985;Inherit;False;10;2;1;COLOR;0,0,0,0;False;0;INT;10;False;1;COLOR;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;1294;2524.866,1123.635;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;1293;2525.411,1244.454;Float;False;Property;_Fogspeed;Fog speed;6;0;Create;True;0;0;False;0;0.1,0;0.1,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.PannerNode;1307;2593.979,2460.067;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ColorNode;1267;2468.927,2826.971;Half;False;Property;_Starcolor;Star color;1;2;[HDR];[Gamma];Create;True;0;0;False;0;0.5,0.5,0.5,1;1.8857,2.599208,4.867145,1;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;1299;2829.342,3043.674;Inherit;False;Property;_Startemissionspeed;Start emission speed;9;0;Create;True;0;0;False;0;15;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1177;2527.315,1960.403;Half;False;Property;_Exposure;Exposure;2;0;Create;True;0;0;False;0;1;1;0;8;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1303;2786.312,2434.676;Inherit;True;Property;_Tex1;Cubemap (HDR);4;1;[NoScaleOffset];Create;False;0;0;False;0;ed43ce351a868434e83012212f99cc6a;5630ff821797439439dde57035a507a6;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;1295;2814.52,1328.541;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ColorNode;1173;2527.315,1784.403;Half;False;Property;_TintColor;Tint Color;0;1;[Gamma];Create;True;0;0;False;0;0.5,0.5,0.5,1;0.5,0.5,0.5,1;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1268;2690.789,2726.621;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SinTimeNode;1302;2916.514,2890.452;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorSpaceDouble;1175;2527.315,1608.403;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CustomExpressionNode;1189;2528.436,1528.403;Half;False;DecodeHDR(Data, _Tex_HDR);3;False;1;True;Data;FLOAT4;0,0,0,0;In;;Float;False;DecodeHDR;True;False;0;1;0;FLOAT4;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;1286;2998.933,1426.637;Inherit;True;Property;_TextureSample0;Texture Sample 0;10;0;Create;True;0;0;False;0;None;1b07974db2a3edc45be1ad5bd6426759;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1174;3004.016,1837.771;Inherit;False;4;4;0;FLOAT3;0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1304;3136.158,2708.032;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;1285;3124.47,2855.06;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;2.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1291;3331.878,1698.479;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1283;3311.155,2710.386;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.Vector4Node;1190;2143.315,1784.403;Half;False;Property;_Tex_HDR;DecodeInstructions;5;1;[HideInInspector];Create;False;0;0;True;0;0,0,0,0;1,1,0,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;1275;3476.431,1842.374;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;1272;3683.557,1840.883;Float;False;True;2;ASEMaterialInspector;0;1;SkyTest;0770190933193b94aaa3065e307002fa;True;Unlit;0;0;Unlit;2;True;0;1;False;-1;0;False;-1;0;1;False;-1;0;False;-1;True;0;False;-1;0;False;-1;True;False;True;0;False;-1;True;True;True;True;True;0;False;-1;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;True;1;False;-1;True;3;False;-1;True;True;0;False;-1;0;False;-1;True;1;RenderType=Opaque=RenderType;True;2;0;False;False;False;False;False;False;False;False;False;True;1;LightMode=ForwardBase;False;0;;0;0;Standard;1;Vertex Position,InvertActionOnDeselection;1;0;1;True;False;0
WireConnection;1218;1;41;1
WireConnection;1218;0;1219;0
WireConnection;1307;0;1305;0
WireConnection;1307;2;1306;0
WireConnection;1303;1;1307;0
WireConnection;1295;0;1294;0
WireConnection;1295;2;1293;0
WireConnection;1268;0;1218;0
WireConnection;1268;1;1267;0
WireConnection;1189;0;41;0
WireConnection;1286;1;1295;0
WireConnection;1174;0;1189;0
WireConnection;1174;1;1175;0
WireConnection;1174;2;1173;0
WireConnection;1174;3;1177;0
WireConnection;1304;0;1303;0
WireConnection;1304;1;1268;0
WireConnection;1285;0;1302;4
WireConnection;1285;1;1299;0
WireConnection;1291;0;1286;4
WireConnection;1291;1;1174;0
WireConnection;1283;0;1304;0
WireConnection;1283;1;1285;0
WireConnection;1275;0;1291;0
WireConnection;1275;1;1283;0
WireConnection;1272;0;1275;0
ASEEND*/
//CHKSM=5876E99AD32C9DA393203553D97A35B3FD6252D1
