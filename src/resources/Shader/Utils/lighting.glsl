#version 430

vec3 calculateLight(vec3 myColor) {
	//  ---------------------------

	//  vector light to fragment
	vec3 fragmentToLight = normalize(lightsource.xyz - fragPos.xyz);

	//  ambient ----------------------------------------------------------------
	vec3 ambientColor = myColor;

	//  diffuse ----------------------------------------------------------------
	float diffuse = dot(normalize(normal.xyz), fragmentToLight);

	diffuse = max(diffuse, 0.0);
	vec3 diffuseColor = myColor * diffuse;

	//  specular ---------------------------------------------------------------
	vec3 reflection = reflect(-fragmentToLight, normalize(normal.xyz));
	vec3 fragmentTocameraPos = normalize(cameraPos.xyz - fragPos.xyz);

	float specular = dot(reflection, fragmentTocameraPos);
	specular = max(specular, 0.0);//  0.0 ... 1.0

	specular = pow(specular, 16.0);

	vec3 specularColor = myColor * specular;

	return (ambientColor * a) + (diffuseColor * d) + (specularColor * s);
}

vec3 calculateSunLight(vec4 sunColorIn) {
	//  vector light to fragment
	vec3 fragmentToLight = normalize(lightsource.xyz);

	//  ambient ----------------------------------------------------------------
	vec3 ambientColor = sunColorIn.rgb;

	//  diffuse ----------------------------------------------------------------
	float diffuse = dot(normalize(normal.xyz), fragmentToLight);

	diffuse = max(diffuse, 0.0f);
	vec3 diffuseColor = sunColorIn.rgb * diffuse;

	//  specular ---------------------------------------------------------------
	vec3 reflection = reflect(-fragmentToLight, normalize(normal.xyz));
	vec3 fragmentTocameraPos = normalize(cameraPos.xyz - fragPos.xyz);

	float specular = dot(reflection, fragmentTocameraPos);
	specular = max(specular, 0.0f); //  0.0 ... 1.0

	specular = pow(specular, 16.0f);

	vec3 specularColor = sunColorIn.rgb * specular;

	return (ambientColor * 0.1) + (diffuseColor * 0.1) + (specularColor * 0.1);
}
