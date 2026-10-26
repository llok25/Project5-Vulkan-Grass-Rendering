#version 450
#extension GL_ARB_separate_shader_objects : enable

layout(set = 0, binding = 0) uniform CameraBufferObject {
    mat4 view;
    mat4 proj;
} camera;

layout(location = 0) in vec3 fragWorldPos;
layout(location = 1) in vec3 fragNormal;
layout(location = 2) in vec3 fragColor;

layout(location = 0) out vec4 outColor;

void main() {
    vec3 normal = normalize(fragNormal);
    vec3 lightDir = normalize(vec3(-0.3, 1.0, 0.4));
    float diffuse = max(dot(normal, lightDir), 0.0);
    vec3 color = fragColor * (0.35 + diffuse * 0.9);
    outColor = vec4(color, 1.0);
}
