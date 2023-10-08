// Transformation

#version 430 core

in vec4 fragPos;
in vec4 inColor;
in vec4 uvCoord;
in vec4 normal;

uniform vec4 colorID;

out vec4 fragColor;

void main() {
	fragColor = colorID;
}

