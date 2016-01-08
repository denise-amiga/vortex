Strict

Const STD_VERTEX_SHADER:String = "#ifdef GL_ES~nprecision highp int;~nprecision mediump float;~n#endif~n~n#define MAX_LIGHTS 8~n~nuniform mat4 mvp;~nuniform mat4 modelView;~nuniform mat4 normalMatrix;~nuniform bool lightingEnabled;~nuniform bool lightEnabled[MAX_LIGHTS];~nuniform vec4 lightPos[MAX_LIGHTS]; // In viewer space !!!~nuniform vec3 lightColor[MAX_LIGHTS];~nuniform float lightAttenuation[MAX_LIGHTS];~nuniform vec4 baseColor;~nuniform vec3 ambient;~nuniform int shininess;~nuniform bool fogEnabled;~nuniform vec2 fogDist;~nattribute vec3 vpos;~nattribute vec3 vnormal;~nattribute vec4 vcolor;~nattribute vec2 vtex;~nvarying vec4 fcolor;~nvarying vec2 ftex;~nvarying vec3 combinedSpecular;~nvarying float fogFactor;~n~nvoid main() {~n // Vertex position (projection and view spaces)~n gl_Position = mvp * vec4(vpos, 1.0);~n vec3 V;~n if ( lightingEnabled || fogEnabled ) V = vec3(modelView * vec4(vpos, 1.0));~n~n // Fragment color~n fcolor = baseColor * vcolor;~n~n // Fragment texture coords~n ftex = vtex;~n~n // Lighting~n combinedSpecular = vec3(0.0, 0.0, 0.0);~n if ( lightingEnabled ) {~n  // Color that combines diffuse component of all lights~n  vec4 combinedColor = vec4(ambient, 1.0);~n~n  // Calculate vertex normal~n  vec3 NV = normalize(V);~n~n  // Calculate normal in viewer space~n  vec3 N = normalize(vec3(normalMatrix * vec4(vnormal, 0.0)));~n~n  // Compute all lights~n  for ( int i = 0; i < MAX_LIGHTS; i++ ) {~n   if ( lightEnabled[i] ) {~n    vec3 L = vec3(lightPos[i]);~n    float att = 1.0;~n~n    // Point light~n    if ( lightPos[i].w == 1.0 ) {~n     L -= V;~n     att = 1.0 / (1.0 + lightAttenuation[i]*length(L));~n    }~n~n    L = normalize(L);~n    float NdotL = max(dot(N, L), 0.0);~n~n    // Diffuse~n    combinedColor += NdotL * vec4(lightColor[i], 1.0) * att;~n~n    // Specular~n    if ( shininess > 0 && NdotL > 0.0 ) {~n     vec3 H = normalize(L - NV);~n     float NdotH = max(dot(N, H), 0.0);~n     combinedSpecular += pow(NdotH, float(shininess)) * att;~n    }~n   }~n  }~n~n  fcolor *= combinedColor;~n }~n ~n // Fog~n if ( fogEnabled ) fogFactor = clamp((fogDist[1] - abs(V.z)) / (fogDist[1] - fogDist[0]), 0.0, 1.0);~n}"
Const STD_FRAGMENT_SHADER:String = "#ifdef GL_ES~nprecision highp int;~nprecision mediump float;~n#endif~n~nuniform int baseTexMode;~nuniform sampler2D baseTexSampler;~nuniform bool fogEnabled;~nuniform vec3 fogColor;~nvarying vec4 fcolor;~nvarying vec2 ftex;~nvarying vec3 combinedSpecular;~nvarying float fogFactor;~n~nvoid main() {~n // Base color / lighting~n gl_FragColor = fcolor;~n~n // Base texture~n#ifdef UV_TOPLEFT~n if ( baseTexMode == 1 ) gl_FragColor *= texture2D(baseTexSampler, vec2(ftex.x, ftex.y));~n#else~n if ( baseTexMode == 1 ) gl_FragColor *= texture2D(baseTexSampler, vec2(ftex.x, -ftex.y));~n#endif~n~n // Reject fragment with low alpha~n if ( gl_FragColor.a <= 0.004 ) discard;~n~n // Add specular~n gl_FragColor += vec4(combinedSpecular, 0.0);~n ~n // Add fog~n if ( fogEnabled ) gl_FragColor = vec4(mix(fogColor, vec3(gl_FragColor), fogFactor), gl_FragColor.a);~n}~n"
Const _2D_VERTEX_SHADER:String = "#ifdef GL_ES~nprecision highp int;~nprecision mediump float;~n#endif~n~nuniform mat4 mvp;~nattribute vec3 vpos;~nattribute vec2 vtex;~nvarying vec2 ftex;~n~nvoid main() {~n gl_Position = mvp * vec4(vpos, 1.0);~n    ftex = vtex;~n}"
Const _2D_FRAGMENT_SHADER:String = "#ifdef GL_ES~nprecision highp int;~nprecision mediump float;~n#endif~n~nuniform int baseTexMode;~nuniform sampler2D baseTexSampler;~nuniform vec4 baseColor;~nvarying vec2 ftex;~n~nvoid main() {~n // Base color~n gl_FragColor = baseColor;~n~n // Base texture~n#ifdef UV_TOPLEFT~n if ( baseTexMode == 1 ) gl_FragColor *= texture2D(baseTexSampler, vec2(ftex.x, ftex.y));~n#else~n if ( baseTexMode == 1 ) gl_FragColor *= texture2D(baseTexSampler, vec2(ftex.x, -ftex.y));~n#endif~n}"
