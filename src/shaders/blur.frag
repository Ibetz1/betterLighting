uniform int blurRes = 15;
uniform int blurRadius = 4;
uniform int blurStep = 1;
uniform vec2 imageSize;
uniform float lightRadius;

#define pi radians(180)

vec4 effect( vec4 color, Image tex, vec2 texture_coords, vec2 screen_coords ) {
    vec4 sum = vec4(0, 0, 0, 1);
    vec4 imageColor = Texel(tex, texture_coords);
    
    if (length(screen_coords - lightRadius) > lightRadius) return imageColor;

    // blur radius
    for (float i = 0; i <= blurRes; i++) {
        float theta = (i / blurRes) * (2 * pi);
        
        for (float r = 0; r < blurRadius / blurStep; r++) {
            vec2 offset = vec2(
                cos(theta) * r * blurStep, sin(theta) * r * blurStep
            ) / imageSize;

            vec4 radialColor = Texel(tex, texture_coords + offset);

            sum += radialColor;
        }
    }

    sum /= blurRes * (blurRadius / blurStep);

    return vec4(sum.rgb, 1);
}