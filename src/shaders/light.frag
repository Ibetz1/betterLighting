// essentials
uniform Image occluders;
uniform float radius, w, h;
uniform vec3 position;


// light properties
uniform float smoothing = 1.5;
uniform vec2 glow = vec2(1, 1);

#define pi radians(180)

vec4 effect( vec4 color, Image tex, vec2 texture_coords, vec2 screen_coords ) {

    // get distance to pixel
    float r = length(screen_coords - radius);
    // float z = position.z - (r / radius);


    // lighting, normals and spectral
    {
        float att = clamp((1.0 - r / radius) / smoothing, 0.0, 1.0);
        color = vec4(clamp(color.rgb * pow(att, smoothing) + pow(smoothstep(glow.x, 1.0, att), smoothing) * glow.y, 0.0, 1.0), 1);
    }

    // occlusion
    {
        // get angle to pixel
        float theta = atan( (screen_coords.y - radius), (screen_coords.x - radius) ) + pi;
    
        if (r < radius) {
            float blur = 1;

            // cast ray out to pixel
            for (float s = r; s > 0; s--) {

                // check if light ray sees anything
                vec2 pos = (position.xy + vec2(-cos(theta) * s, -sin(theta) * s));

                vec4 occluder = Texel(occluders, pos / vec2(w, h));
                float dz = occluder.z - position.z;

                // calculate shadow with transparency
                if (occluder.a > 0) {
                    color = vec4(color.rgb, (r / s) * (1 - occluder.a) - (dz));
                    break;
                }
            }
        }
    }

    return color;
}