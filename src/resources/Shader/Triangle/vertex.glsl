#version 430 core

layout(location = 0) in vec3 position;

void main()
{
    //gl_Position = vec4(position_cs.x, position_cs.y, position_cs.z, position_cs.w);
    gl_Position = vec4(position, 1.0);
}
