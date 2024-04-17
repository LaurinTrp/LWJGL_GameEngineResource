#version 430

struct Light {
	vec3 position;
	vec3 direction;

	vec3 ambient;
	vec3 diffuse;
	vec3 specular;
};

vec3 computeDiffuse(vec3 fragToLight, vec4 normal, vec3 fragColor) {
	float diffuse = dot(normalize(normal.xyz), fragToLight);
	diffuse = max(diffuse, 0.0);
	return fragColor * diffuse;
}

vec3 computeSpecular(vec3 fragToLight, vec4 fragPos, vec4 normal, vec4 cameraPos, vec3 fragColor){
	vec3 reflection = reflect(-fragToLight, normalize(normal.xyz));
	vec3 fragmentTocameraPos = normalize(cameraPos.xyz - fragPos.xyz);

	float specular = dot(reflection, fragmentTocameraPos);
	specular = max(specular, 0.0);//  0.0 ... 1.0

	specular = pow(specular, 16.0);

	return fragColor * specular;
}

vec3 calculateLight(vec3 myColor) {

	vec3 fragmentToLight = normalize(lightsource.xyz - fragPos.xyz);

	//  ambient ----------------------------------------------------------------
	vec3 ambientColor = myColor;

	//  diffuse ----------------------------------------------------------------
	vec3 diffuseColor = computeDiffuse(fragmentToLight, normal, myColor);

	//  specular ---------------------------------------------------------------
	vec3 specularColor = computeSpecular(fragmentToLight, fragPos, normal, cameraPos, myColor);

	return (ambientColor * a) + (diffuseColor * d) + (specularColor * s);
}

vec3 calculateSunLight(vec4 sunColorIn) {

	vec3 lightDir = normalize(-lightsource.xyz);

	vec3 diffuseColor = computeDiffuse(lightDir, normal, sunColorIn.xyz);

	vec3 specularColor = computeSpecular(lightDir, fragPos, normal, cameraPos, sunColorIn.xyz);

	return (diffuseColor * 0.1) + (specularColor * 0.1);
}
