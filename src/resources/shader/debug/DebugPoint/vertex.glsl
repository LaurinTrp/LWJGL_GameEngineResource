#version 430 core

layout(location = 0) in vec4 position;
layout(location = 1) in vec4 aColor;

uniform mat4 viewMatrix;
uniform mat4 projectionMatrix;

out vec4 fragPos;
out vec4 color;

void main()
{
	gl_PointSize = 10.0;
    gl_Position = projectionMatrix * viewMatrix * position;
    color = aColor;

}
