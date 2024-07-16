#version 430 core

layout(location = 0) in vec3 position;
layout(location = 1) in vec2 texCoord;
layout(location = 2) in vec3 aNormal;

uniform mat4 modelMatrix;
uniform mat4 viewMatrix;
uniform mat4 projectionMatrix;

out vec4 fragPos;
out vec4 uvCoord;
out vec4 normal;

void main()
{
    gl_Position = projectionMatrix * viewMatrix * modelMatrix * vec4(position, 1.0);
    fragPos = modelMatrix * vec4(position, 1.0);
    normal = mat4(transpose(inverse(modelMatrix))) * vec4(aNormal, 1.0);
    uvCoord = vec4(texCoord, 0.0, 1.0);
}
