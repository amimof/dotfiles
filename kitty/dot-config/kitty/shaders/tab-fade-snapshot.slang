#language slang 2026
// Copies the current frame into the persist texture for tab-fade.

import kitty_custom_shader_types;

public float4
fragment_main(float4 color, KittyTextures t, KittyCustomShaderData d) {
    return t.backbuffer.Sample(t.pos);
}
