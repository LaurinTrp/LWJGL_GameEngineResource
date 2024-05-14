#version 430 core

uniform sampler2D tex;

uniform vec4 cameraPos;

in vec4 fragPos;
in vec4 uvCoord;
in vec4 normal;

uniform int bufferID; // 0 = pickbuffer, 1 = framebuffer

uniform vec3 colorID;

uniform bool selected;

uniform vec4 sunPosition;
uniform vec4 sunColor;

out vec4 fragColor;

float a = 0.1, d = 0.1, s = 0.1;
vec4 lightsource;

#include <Utils/lighting.glsl>

void main() {
	switch(bufferID){
	case 0:
		fragColor = vec4(colorID.rgb, 1.0);
		break;
	case 1:
		if (selected) {
			fragColor = vec4(1.0, 0.0, 0.0, 1.0);
			return;
		}

		vec3 texColor = texture(tex, uvCoord.st).rgb * 0.4;

		fragColor = vec4(texColor, 1.0);

		lightsource = sunPosition;
		texColor += calculateSunLight(sunColor, lightsource);

		if (numOfLights == 0) {
			fragColor = vec4(texColor, 1.0);
		} else {
			vec4 colorWithLight = vec4(texColor, 1.0);
			for (int i = 0; i < numOfLights; i++) {
				lightsource = vec4(lights[i].position, 1.0);
				colorWithLight += vec4(calculateLight(texColor, lightsource), 1.0);
			}

			fragColor = colorWithLight;
		}
		break;
	default:
		discard;
	}

}

