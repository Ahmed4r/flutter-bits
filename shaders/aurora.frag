#version 460 core
#include <flutter/runtime_effect.glsl>

// Maps directly to your layout's shader.setFloat parameters
uniform vec2 uSize;       // index 0, 1
uniform vec2 uMouse;      // index 2, 3
uniform float uTime;      // index 4

out vec4 fragColor;

// Balanced pseudo-random hash generator
float hash(vec2 p) {
    return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453123);
}

// 2D Value Noise Engine
float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    vec2 u = f * f * (3.0 - 2.0 * f);
    
    return mix(mix(hash(i + vec2(0.0, 0.0)), hash(i + vec2(1.0, 0.0)), u.x),
               mix(hash(i + vec2(0.0, 1.0)), hash(i + vec2(1.0, 1.0)), u.x), u.y);
}

// Fractal Brownian Motion (fBm) structure for deep smoke/fluid pooling
float fbm(vec2 p) {
    float value = 0.0;
    float amplitude = 0.5;
    float frequency = 1.0;
    for (int i = 0; i < 3; i++) {
        value += amplitude * noise(p * frequency);
        frequency *= 2.0;
        amplitude *= 0.5;
    }
    return value;
}

void main() {
    // Standardize canvas dimensions
    vec2 uv = FlutterFragCoord().xy / uSize;
    vec2 aspectCorrectedUV = uv;
    aspectCorrectedUV.x *= uSize.x / uSize.y;

    // Track mouse influence vector mapping
    vec2 mouseUV = uMouse / uSize;
    mouseUV.x *= uSize.x / uSize.y;
    
    float mouseDistance = length(aspectCorrectedUV - mouseUV);
    // Creates a soft reactive push-pull effect within a 400px radius
    float mouseForce = smoothstep(0.4, 0.0, mouseDistance) * 0.25;
    vec2 mouseOffset = normalize(aspectCorrectedUV - mouseUV + vec2(0.001)) * mouseForce;

    // Domain Warping Math (Inject loops to skew coordinates dynamically over time)
    vec2 warpA = vec2(
        fbm(aspectCorrectedUV * 1.5 + vec2(uTime * 0.15, uTime * 0.08) + mouseOffset),
        fbm(aspectCorrectedUV * 1.5 + vec2(uTime * 0.05, uTime * 0.12) - mouseOffset)
    );
    
    vec2 warpB = vec2(
        fbm(aspectCorrectedUV * 2.0 + 4.0 * warpA + vec2(uTime * 0.1)),
        fbm(aspectCorrectedUV * 2.0 + 4.0 * warpA + vec2(uTime * -0.05))
    );

    float fluidDensity = fbm(aspectCorrectedUV * 1.2 + 3.5 * warpB);

    // Color definitions (React Bits palette styling)
    vec3 spaceBg = vec3(0.02, 0.005, 0.04);       // Deep violet canvas floor
    vec3 coreAurora = vec3(0.66, 0.33, 1.0);     // Radiant signature purple
    vec3 accentGlow = vec3(0.12, 0.53, 0.95);    // Fluid edge neon blue cyan

    // Mix base canvas states using calculated fluid warp matrices
    vec3 mixedColor = mix(spaceBg, coreAurora, clamp(fluidDensity * 1.8, 0.0, 1.0));
    mixedColor = mix(mixedColor, accentGlow, clamp(length(warpA) * 0.6, 0.0, 1.0));
    mixedColor += vec3(0.9, 0.8, 1.0) * pow(fluidDensity, 4.0) * 0.35; // Bright highlights

    // Smoothstep top boundary vignette (Emulates the website's fadeTop control)
    float canvasVignette = smoothstep(1.0, 0.25, uv.y);
    vec3 finalOutput = mixedColor * canvasVignette;

    fragColor = vec4(finalOutput, 1.0);
}
