#version 430

const int MAX_LIGHTS = 10;

uniform vec4 sunPosition;
uniform vec4 sunColor;

uniform int numOfLights;

uniform struct Lights {
	int types[MAX_LIGHTS]; // 0=directional, 1=point, 2=spotlight

	vec3 lightPositions[MAX_LIGHTS];
	vec3 lightDirections[MAX_LIGHTS];
	vec3 lightAmbients[MAX_LIGHTS];
	vec3 lightDiffuses[MAX_LIGHTS];
	vec3 lightSpeculars[MAX_LIGHTS];

	float constant[MAX_LIGHTS];
	float linear[MAX_LIGHTS];
	float quadratic[MAX_LIGHTS];

	float innerCutoff[MAX_LIGHTS];
	float outerCutoff[MAX_LIGHTS];
} lights;

float computeDiffuse(vec3 fragToLight, vec4 normal) {
	float diffuse = dot(normalize(normal.xyz), fragToLight);
	diffuse = max(diffuse, 0.0);
	return diffuse;
}

float computeSpecular(vec3 fragToLight, vec4 fragPos, vec4 normal,
		vec4 cameraPos) {
	vec3 reflection = reflect(-fragToLight, normalize(normal.xyz));
	vec3 fragmentTocameraPos = normalize(cameraPos.xyz - fragPos.xyz);

	float specular = dot(reflection, fragmentTocameraPos);
	specular = max(specular, 0.0); //  0.0 ... 1.0

	specular = pow(specular, 16.0);

	return specular;
}

vec3 calculateLight(vec3 myColor, int index) {

	vec3 lightsource = lights.lightPositions[index];

	vec3 fragmentToLight = normalize(lightsource.xyz - fragPos.xyz);

	//  ambient ----------------------------------------------------------------
	vec3 ambient = lights.lightAmbients[index] * myColor;

	//  diffuse ----------------------------------------------------------------
	vec3 diffuse = computeDiffuse(fragmentToLight, normal)
			* lights.lightDiffuses[index] * myColor;

	//  specular ---------------------------------------------------------------
	vec3 specular = computeSpecular(fragmentToLight, fragPos, normal, cameraPos)
			* lights.lightSpeculars[index] * myColor;

	if (lights.types[index] == 1) {
		float distance = length(lightsource - fragPos.xyz);
		float attenation = 1.0
				/ (lights.constant[index] + lights.linear[index] * distance
						+ lights.quadratic[index] * (distance * distance));
		ambient *= attenation;
		diffuse *= attenation;
		specular *= attenation;

		return ambient + diffuse + specular;
	}

	if (lights.types[index] == 2) {
		vec3 lightDir = normalize(lightsource - fragPos.xyz);
		float theta = dot(lightDir, normalize(-lights.lightDirections[index]));

		float epsilon = lights.innerCutoff[index] - lights.outerCutoff[index];

		float intensity = clamp((theta - lights.outerCutoff[index]) / epsilon, 0.0, 1.0);

		diffuse *= intensity;
		specular *= intensity;
	}

	return ambient + diffuse + specular;

}

vec3 calculateSunLight(vec4 sunColorIn, vec4 lightsource) {
	vec4 lightPosition = lightsource;

	vec3 lightDir = normalize(-lightPosition.xyz);

	vec3 diffuseColor = computeDiffuse(lightDir, normal) * sunColorIn.xyz;

	vec3 specularColor = computeSpecular(lightDir, fragPos, normal, cameraPos)
			* sunColorIn.xyz;

	return (diffuseColor * 0.1) + (specularColor * 0.1);
}
