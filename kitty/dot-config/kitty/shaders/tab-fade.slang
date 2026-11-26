#language slang 2026
// Tab crossfade
// Blends the previous frame (t.persist) toward the current one inside the tab
// content area. Since the previous frame is itself the blended output, the old
// tab decays exponentially into the new one, which gives an ease-out fade.

import kitty_custom_shader_types;

// Fraction of the new tab blended in per frame, higher is faster.
static const float FADE_PER_FRAME = 0.3;

public float4
fragment_main(float4 color, KittyTextures t, KittyCustomShaderData d) {
    float4 ca = d.central_area;
    if (ca.z <= 0.0 || ca.w <= 0.0) return color;
    if (any(t.pos < ca.xy) || any(t.pos > ca.xy + ca.zw)) return color;
    if (t.animation_progress >= 1.0) return color;

    return lerp(t.persist.Sample(t.pos), color, FADE_PER_FRAME);
}
