#version 460 core

precision highp float;

#include <flutter/runtime_effect.glsl>

uniform vec2 uResolution;
uniform sampler2D uTexture;
uniform float uK1;         // Distortion coefficient 1 (e.g., 0.2)
uniform float uK2;         // Distortion coefficient 2 (e.g., 0.1)
uniform float uIPDOffset;  // Horizontal offset for IPD (e.g., 0.05)
uniform float uColorClamp; // Max white level (e.g., 0.9 for #E0E0E0)

out vec4 fragColor;

void main() {
    vec2 uv = FlutterFragCoord().xy / uResolution;
    
    // Determine eye (0 = Left, 1 = Right)
    float eye = step(0.5, uv.x);
    
    // Normalized coordinates per eye (0.0 to 1.0)
    // Left eye: x goes 0.0 -> 0.5, mapped to 0.0 -> 1.0
    // Right eye: x goes 0.5 -> 1.0, mapped to 0.0 -> 1.0
    float x_eye = (uv.x - 0.5 * eye) * 2.0;
    vec2 uv_eye = vec2(x_eye, uv.y);
    
    // Shift center for IPD (Stereo Convergence)
    // Shift lens center inward:
    // Left eye center shifts right (+), Right eye center shifts left (-)
    float x_center = 0.5 + (eye == 0.0 ? uIPDOffset : -uIPDOffset);
    vec2 center = vec2(x_center, 0.5);
    
    // Vector from center to current pixel
    vec2 distVec = uv_eye - center;
    
    // Aspect ratio correction for radial distortion (assuming landscape phone ~2:1, per eye ~1:1)
    // Ideally we pass aspect ratio, but here we assume square-ish per eye or compensate.
    // For a phone in landscape, uResolution.x / uResolution.y approx 2.0.
    // Per eye aspect is (Width/2) / Height approx 1.0. 
    // So distinct aspect correction might not be needed if render target is per-eye square.
    // However, to be safe, let's normalize r calculations.
    
    float r2 = dot(distVec, distVec); // r squared
    float r4 = r2 * r2;               // r to the 4th
    
    // Barrel distortion formula: new_pos = center + vec * (1 + k1*r^2 + k2*r^4)
    // But we are doing INVERSE mapping (finding source pixel for destination pixel).
    // So strictly we should use the inverse, but typical simple implementations 
    // use the polynomial to map destination -> source for lookup.
    
    float distortion = 1.0 + uK1 * r2 + uK2 * r4;
    
    // Simple chromatic aberration (optional but requested "Color Science")
    // We can sample R, G, B at slightly different distortion factors.
    // For now, let's stick to geometric correctness first, then clamp.
    
    vec2 sourceUV = center + distVec * distortion;
    
    // Check bounds (0.0 to 1.0 in eye space)
    if (sourceUV.x < 0.0 || sourceUV.x > 1.0 || sourceUV.y < 0.0 || sourceUV.y > 1.0) {
        fragColor = vec4(0.0, 0.0, 0.0, 1.0); // Black vignette
        return;
    }
    
    // Map back to global texture coordinates
    vec2 globalUV;
    globalUV.x = sourceUV.x * 0.5 + 0.5 * eye;
    globalUV.y = sourceUV.y;
    
    // Sample texture
    vec4 color = texture(uTexture, globalUV);
    
    // Color Clamp (God Rays reduction)
    // Clamp individual channels to uColorClamp
    color.rgb = min(color.rgb, vec3(uColorClamp));
    
    fragColor = color;
}
