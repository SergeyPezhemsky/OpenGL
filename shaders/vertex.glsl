#version 330 core
layout(location = 0) in vec4 vertex;
layout(location = 1) in vec4 normal;
layout(location = 2) in vec2 texCoords;
layout(location = 3) in vec2 intsVar;
layout(location = 4) in vec3 tangent;
layout(location = 5) in vec3 bitangent;


out vec2 vTexCoords;
out vec3 vFragPosition;
out vec3 vNormal;
out vec3 skyBoxTex;
mat3 TBN;

uniform mat4 model;
uniform mat4 view;
uniform mat4 projection;
uniform int type;

void main()
{
  if (type == 1) {
        skyBoxTex = vec3(vertex[0], vertex[1], vertex[2]);
        vec4 pos = projection * view * vertex;
        gl_Position = pos.xyww;
  }
  else if (type == 0){
          gl_Position = projection * view * model * vertex;

          vTexCoords = texCoords;
          vFragPosition = vec3(model * vertex);
          vNormal = normalize(mat3(transpose(inverse(model))) * normal.xyz);

          vec3 T = normalize(vec3(model * vec4(tangent,   0.0)));
          vec3 B = normalize(vec3(model * vec4(bitangent, 0.0)));
          vec3 N = normalize(vec3(model * normal));
          mat3 TBN = mat3(T, B, N);
  }
  else if (type == 2){
         gl_Position = projection * view * model * vertex + vec4(intsVar, 0.0f, 0.0f);
         vTexCoords = texCoords;
         vNormal = normalize(mat3(transpose(inverse(model))) * normal.xyz);
         vFragPosition = vec3(model * vertex) + vec3(intsVar, 1.0f);

         mat3 normalMatrix = transpose(inverse(mat3(model)));
         vec3 T = normalize(normalMatrix * tangent);
         vec3 N = normalize(normalMatrix * vNormal);
         T = normalize(T - dot(T, N) * N);
         vec3 B = cross(N, T);
    
         TBN = transpose(mat3(T, B, N));    
  }
}