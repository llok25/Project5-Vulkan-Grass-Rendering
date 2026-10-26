#version 450
#extension GL_ARB_separate_shader_objects : enable

layout(quads, equal_spacing, ccw) in;

layout(set = 0, binding = 0) uniform CameraBufferObject {
    mat4 view;
    mat4 proj;
} camera;

layout(location = 0) in vec4 inV0[];
layout(location = 1) in vec4 inV1[];
layout(location = 2) in vec4 inV2[];
layout(location = 3) in vec4 inUp[];

layout(location = 0) out vec3 fragWorldPos;
layout(location = 1) out vec3 fragNormal;
layout(location = 2) out vec3 fragColor;

void main() {
    float u = gl_TessCoord.x;
    float v = gl_TessCoord.y;

    vec3 base = inV0[0].xyz;
    vec3 guide = inV1[0].xyz;
    vec3 tip = inV2[0].xyz;
    vec3 up = normalize(inUp[0].xyz);
    vec3 bladeDir = normalize(tip - base);
    vec3 right = normalize(cross(bladeDir, up));
    if (length(right) < 0.0001) {
        right = vec3(1.0, 0.0, 0.0);
    }

    vec3 bend = mix(base, guide, u);
    vec3 tipPoint = mix(guide, tip, u);
    vec3 position = mix(bend, tipPoint, u);
    vec3 worldPos = position + right * ((v * 2.0 - 1.0) * inV2[0].w);
    vec3 normal = normalize(cross(right, bladeDir));

    gl_Position = camera.proj * camera.view * vec4(worldPos, 1.0);
    fragWorldPos = worldPos;
    fragNormal = normal;
    fragColor = mix(vec3(0.05, 0.45, 0.1), vec3(0.2, 0.85, 0.2), clamp((position.y - base.y) / max(inV1[0].w, 0.0001), 0.0, 1.0));
}
