shader_type canvas_item;
render_mode unshaded;

// --- Pengaturan Outline (Kode Milikmu) ---
uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;
uniform vec4 outline_color : source_color = vec4(1.0);
uniform float width : hint_range(0, 100) = 1.0;
uniform int sample_count : hint_range(4, 64) = 16;

// --- Pengaturan Hit Flash (Dari Video YouTube) ---
uniform vec4 hit_flash_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform bool hit_flash_on = false;

void fragment() {
    // 1. Membaca piksel asli menggunakan screen_texture
    vec4 c = textureLod(screen_texture, SCREEN_UV, 0.0);

    // Mencegah artefak gelap di tepi (pre-multiplied alpha fix)
    if (c.a > 0.0001) {
        c.rgb /= c.a;
    }

    // 2. Logika Hit Flash (Disisipkan di sini)
    // Jika hit_flash_on diaktifkan melalui script/animasi, timpa warna asli dengan warna flash
    if (hit_flash_on) {
        c.rgb = hit_flash_color.rgb;
    }

    // 3. Kalkulasi Outline (Kode Milikmu)
    vec2 tex_pixel_size = 1.0 / vec2(textureSize(screen_texture, 0));
    vec2 size = tex_pixel_size * width;
    float outline = 0.0;

    for (int i = 0; i < sample_count; i++) {
        float angle = float(i) * (6.28318530718 / float(sample_count));
        vec2 offset = vec2(cos(angle), sin(angle)) * size;

        vec4 sample_c = textureLod(screen_texture, SCREEN_UV + offset, 0.0);
        outline += sample_c.a;
    }

    // Memastikan nilai opasitas outline tidak melebihi batas 1.0
    outline = min(outline, 1.0);
    
    // 4. Gabungkan sprite (yang sudah terkena efek flash atau normal) dengan warna outline
    vec4 final_color = mix(c, outline_color, clamp(outline - c.a, 0.0, 1.0));

    COLOR *= final_color;
}