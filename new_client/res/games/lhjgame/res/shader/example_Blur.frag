#ifdef GL_ES  
precision lowp float;  
#endif  
  
varying vec4 v_fragmentColor;  
varying vec2 v_texCoord;  
uniform vec2 v_ins;  
uniform int i_num ;  
uniform float f_weight;  
  
void main()  
{  
    vec2 v = v_texCoord;  
    vec4 c = texture2D(CC_Texture0, v) * f_weight;  
      
    for (int i = 0; i < i_num; ++i)  
    {  
        v += v_ins;  
        c += texture2D(CC_Texture0, v) * f_weight;  
    }  
    gl_FragColor = c;  
}  
