 #version 430 core

uniform sampler2D tex;

in vec4 pass_texCoord;
in vec4 pass_normal;

out vec4 fragColor;

void main() {

    fragColor = texture(tex, pass_texCoord.xy);

}

