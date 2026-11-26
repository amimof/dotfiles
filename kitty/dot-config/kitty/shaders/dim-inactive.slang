#language slang 2026
// Dim inactive windows the way wezterm's inactive_pane_hsb does.
// Every pixel in the tab content area outside the active window has its hue,
// saturation and brightness multiplied by the factors below. The conversion to
// HSB is done in sRGB, like wezterm, since kitty hands us linear RGB.

import kitty_custom_shader_types;

// Multipliers applied to inactive windows, 1.0 leaves the component unchanged.
static const float HUE = 1.0;
static const float SATURATION = 0.9;
static const float BRIGHTNESS = 0.75;

float3
linear_to_srgb(float3 c) {
    return select(c <= 0.0031308, c * 12.92, 1.055 * pow(c, float3(1.0 / 2.4)) - 0.055);
}

float3
srgb_to_linear(float3 c) {
    return select(c <= 0.04045, c / 12.92, pow((c + 0.055) / 1.055, float3(2.4)));
}

float3
rgb_to_hsv(float3 c) {
    float4 K = float4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
    float4 p = c.g < c.b ? float4(c.bg, K.wz) : float4(c.gb, K.xy);
    float4 q = c.r < p.x ? float4(p.xyw, c.r) : float4(c.r, p.yzx);
    float delta = q.x - min(q.w, q.y);
    float e = 1.0e-10;
    return float3(abs(q.z + (q.w - q.y) / (6.0 * delta + e)), delta / (q.x + e), q.x);
}

float3
hsv_to_rgb(float3 c) {
    float3 p = abs(fract(c.xxx + float3(1.0, 2.0 / 3.0, 1.0 / 3.0)) * 6.0 - 3.0);
    return c.z * lerp(float3(1.0), clamp(p - 1.0, 0.0, 1.0), c.y);
}

public float4
fragment_main(float4 color, KittyTextures t, KittyCustomShaderData d) {
    // Leave the tab bar alone
    float4 area = d.central_area;
    if (any(t.pos < area.xy) || any(t.pos > area.xy + area.zw)) return color;
    float4 g = d.active_window_geometry;
    if (g.z <= 0.0 || g.w <= 0.0) return color;
    // Treat the active window's title bar, margin, border and padding as part of it
    g.xy -= d.active_window_padding.xy;
    g.zw += d.active_window_padding.xy + d.active_window_padding.zw;
    if (all(t.pos >= g.xy) && all(t.pos <= g.xy + g.zw)) return color;

    float3 hsv = rgb_to_hsv(linear_to_srgb(clamp(color.rgb, 0.0, 1.0)));
    hsv = float3(fract(hsv.x * HUE), saturate(hsv.y * SATURATION), hsv.z * BRIGHTNESS);
    return float4(srgb_to_linear(hsv_to_rgb(hsv)), color.a);
}
