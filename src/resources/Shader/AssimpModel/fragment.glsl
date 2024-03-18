#version 430 core

uniform sampler2D tex;

uniform vec4 cameraPos;

in vec4 fragPos;
in vec4 uvCoord;
in vec4 normal;

const int MAX_LIGHTS = 10;
uniform int numOfLights;
uniform vec4 lightsources[MAX_LIGHTS];
vec4 lightsource = vec4(1.0);

uniform bool selected;

uniform vec4 sunPosition;
uniform vec4 sunColor;

out vec4 fragColor;

float a = 0.1, d = 0.1, s = 0.1;

#include <Utils/lighting.glsl>

void main() {
	if (selected) {
		fragColor = vec4(1.0, 0.0, 0.0, 1.0);
		return;
	}

	lightsource = vec4(0.0, 10.0, 10.0, 1.0);

	vec3 texColor = texture(tex, uvCoord.st).rgb * 0.4;

	fragColor = vec4(texColor, 1.0);

	lightsource = sunPosition;
	texColor += calculateSunLight(sunColor);

	if (numOfLights == 0) {
		fragColor = vec4(texColor, 1.0);
	} else {
		vec4 colorWithLight = vec4(texColor, 1.0);
		for (int i = 0; i < numOfLights; i++) {
			lightsource = lightsources[i];
			colorWithLight += vec4(calculateLight(texColor), 1.0);
		}

		fragColor = colorWithLight;
	}
}

