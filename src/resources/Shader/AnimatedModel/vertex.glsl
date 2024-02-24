#version 430 core

const int MAX_JOINTS = 50;
const int MAX_WEIGHTS = 3;

layout(location = 0) in vec4 in_position;
layout(location = 1) in vec4 in_texCoord;
layout(location = 2) in vec4 in_normal;
layout(location = 3) in ivec3 in_jointIndices;
layout(location = 4) in vec3 in_weights;

out vec4 pass_texCoord;
out vec4 pass_normal;

uniform mat4 jointTransforms[MAX_JOINTS];
uniform mat4 projectionMatrix;
uniform mat4 viewMatrix;
uniform mat4 modelMatrix;

void main()
{
	gl_Position = projectionMatrix * viewMatrix * modelMatrix * in_position;

	pass_normal = in_normal;
	pass_texCoord = in_texCoord;

//	vec4 totalLocalPos = vec4(0.0);
//	vec4 totalNormal = vec4(0.0);
//
//	for(int i = 0; i < MAX_WEIGHTS; i++){
//		mat4 jointTransform = jointTransforms[in_jointIndices[i]];
//		vec4 posePosition = jointTransform * in_position;
//		totalLocalPos += posePosition * in_weights[i];
//
//		vec4 worldNormal = jointTransform * in_normal;
//		totalNormal += worldNormal * in_weights[i];
//	}
//
//	gl_Position = projectionMatrix * viewMatrix * totalLocalPos;
//	pass_normal = totalNormal;
//	pass_texCoord = in_texCoord;
}
