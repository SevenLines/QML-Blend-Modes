import QtQuick 2.0

ImagesShaderComposition {
//    image2.source: "qrc:/lesson5/assets/Gradient.png"
    color: "#DDD"
    title: "Color"
    
    shaderMainFunc: "
float x;
bool above1 = false, above2 = false;
vec4 activeImgFrag = vec4(0), inActiveImgFrag = vec4(0);
x = qt_TexCoord0.x - image1X;
x /= image1Width;
if (x > 0.0 && x <= 1.0)  {
    above1 = true;
    activeImgFrag = texture2D(image1, vec2(x, qt_TexCoord0.y));
}
x = qt_TexCoord0.x - image2X;
x /= image2Width;
if (x > 0.0 && x <= 1.0)  {
    above2 = true;
    inActiveImgFrag = texture2D(image2, vec2(x, qt_TexCoord0.y));
}
if (above1 && above2) {
    vec3 inActiveImgHsv = rgb2hsv(inActiveImgFrag.rgb);
    vec3 activeImgHsv = rgb2hsv(activeImgFrag.rgb);
    inActiveImgHsv.r = activeImgHsv.r; // set hue
    inActiveImgHsv.g = activeImgHsv.g; // set saturation
    gl_FragColor = vec4(hsv2rgb(inActiveImgHsv),1.0);
    return;
}
if (above1) {
    gl_FragColor = activeImgFrag * vec4(image1Opacity);
    return;
}
if (above2) {
    gl_FragColor = inActiveImgFrag * vec4(image2Opacity);
    return; 
}
gl_FragColor = vec4(0);
"
 
}
