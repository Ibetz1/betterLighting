// essentials
uniform Image occluders;
uniform Image normalMap;
uniform Image spectralMap;

uniform float radius, w, h;
uniform vec3 position;
uniform float zMax = 5;
uniform vec2 resolution;


// light properties
uniform float smoothing = 1.5;
uniform vec2 glow = vec2(1, 1);

#define pi radians(180)

vec4 effect( vec4 color, Image tex, vec2 texture_coords, vec2 screen_coords ) {

    // get distance to pixel
    float r = length(screen_coords - radius);
    vec2 screenPos = (position.xy - radius + screen_coords);

    vec4 Normal = Texel(normalMap, screenPos / resolution);
    vec4 Spectral = Texel(spectralMap, screenPos / resolution);
    vec4 occluder = Texel(occluders, screenPos / resolution);
    

    // light gradient
    {
        float att = clamp((1.0 - r / radius) / smoothing, 0.0, 1.0);
        color = vec4(clamp(color.rgb * pow(att, smoothing) + pow(smoothstep(glow.x, 1.0, att), smoothing) * glow.y, 0.0, 1.0), 1);
    }

    // occlusion
    {
        // get angle to pixel
        float theta = atan( (screen_coords.y - radius), (screen_coords.x - radius) ) + pi;
    
        if (r < radius) {
            float depth = 0;
            float zLength = sqrt(pow(r, 2) + pow(position.z, 2));

            // cast ray out to pixel
            for (float s = r; s > 0; s--) {

                // check if light ray sees anything
                vec2 pos = (position.xy + vec2(-cos(theta) * s, -sin(theta) * s));

                vec4 occluder = Texel(occluders, pos / vec2(w, h));

                // calculate zdepth
                float disZ = 1 - clamp(position.z - (occluder.z), -1, 1);
                float zdepth = length(vec2(s / radius, disZ));

                // calculate occlusion depth
                depth += zdepth * occluder.r;
            }
            color = vec4(color.rgb, 1 - depth / zLength);
        }
    }

    // normal and spectral mapping
    {
        // calculate surface normal
        if (Normal.a != 0) {
	        vec3 LightDir = vec3( position.xy - screenPos.xy, (zMax - position.z) / zMax );
            
            // Normalize the normal map
            vec3 N = normalize(Normal.rgb * 2.0 - 1.0);

            // Normalize the light direction
            vec3 L = normalize(LightDir);

            float scalar = 1 - length((screenPos.xy - position.xy) / resolution);

            color.rgb *= ((dot(N, L)) * (occluder.r)) + (length(Spectral.rgb) * scalar);
        }
	}

    // light blocking
    {
        // if (position.z < occluder.z) return vec4(0);
    }

    return color;
}