#version 450

in vec3 pos;

uniform mat4 mvp;

void main() {
	vec4 position = vec4(pos, 1.0);
	gl_Position = mvp * position;
}