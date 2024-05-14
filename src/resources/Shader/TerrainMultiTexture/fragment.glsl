// Multitexture Terrain

#version 430 core

//uniform sampler2D blendMap;
//uniform sampler2D backgroundTexture;
//uniform sampler2D rTexture;
//uniform sampler2D gTexture;
//uniform sampler2D bTexture;

uniform sampler2D heightMap;
uniform float size;

uniform vec4 cameraPos;

in vec4 fragPos;
in vec4 inColor;
in vec4 uvCoord;
in vec4 normal;

vec4 lightsource = vec4(1.0);

uniform vec4 sunPosition;
uniform vec4 sunColor;

out vec4 fragColor;

float a = 0.2, d = 0.2, s = 0.1;

#include <Utils/lighting.glsl>

void main() {

	lightsource = vec4(0.0, 10.0, 10.0, 1.0);

	vec3 texColor = texture(heightMap, uvCoord.st).rrr * 0.2;

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
}

