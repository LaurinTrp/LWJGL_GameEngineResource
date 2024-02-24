#version 430 core


uniform sampler2D tex;

//in vec4 fragPos;
in vec3 color;
in vec2 uvCoord;
//in vec4 normal;

out vec4 fragColor;

void main() {

    fragColor = texture(tex, uvCoord);
//	fragColor = vec4(1.0, 0.0, 0.0, 1.0);
//	fragColor = vec4(uvCoord.xy, 0.0, 1.0);

}

