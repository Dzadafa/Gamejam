shader_type canvas_item;
render_mode unshaded; // Remove if you want 2D lighting to affect the sprite

uniform vec4 outline_color : source_color = vec4(1.0);
uniform float width : hint_range(0, 10) = 1.0; 

void fragment() {
    // 1. Get the original untampered sprite color and alpha
    vec4 c = COLOR;

    // 2. Calculate outline thickness based on texture size
    vec2 size = TEXTURE_PIXEL_SIZE * width;
    float outline = 0.0;

    // 3. Hardcoded 8-way check for maximum performance
    outline += texture(TEXTURE, UV + vec2(-size.x, 0.0)).a;
    outline += texture(TEXTURE, UV + vec2(0.0, size.y)).a;
    outline += texture(TEXTURE, UV + vec2(size.x, 0.0)).a;
    outline += texture(TEXTURE, UV + vec2(0.0, -size.y)).a;
    outline += texture(TEXTURE, UV + vec2(-size.x, size.y)).a;
    outline += texture(TEXTURE, UV + vec2(size.x, size.y)).a;
    outline += texture(TEXTURE, UV + vec2(-size.x, -size.y)).a;
    outline += texture(TEXTURE, UV + vec2(size.x, -size.y)).a;

    // Cap the outline opacity at 1.0
    outline = min(outline, 1.0);
    
    // 4. Output the final mixed color without hue-shifting the original sprite
    COLOR = mix(c, outline_color, clamp(outline - c.a, 0.0, 1.0));
}
