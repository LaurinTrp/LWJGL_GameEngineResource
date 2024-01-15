// Transformation

#version 430 core

in vec4 fragPos;
in vec4 inColor;
in vec4 uvCoord;
in vec4 normal;

uniform vec3 colorID;

out vec4 fragColor;

void main() {
	fragColor = vec4(colorID.rgb, 1.0);
}

