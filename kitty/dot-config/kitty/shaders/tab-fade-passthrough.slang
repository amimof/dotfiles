#language slang 2026
// Final no-op group for tab-fade, the last group must write the default output.

import kitty_custom_shader_types;

public float4
fragment_main(float4 color, KittyTextures t, KittyCustomShaderData d) {
    return color;
}
