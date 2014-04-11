import QtQuick 2.0

ImagesShaderComposition {
//    image2.source: "qrc:/lesson5/assets/Gradient.png"
    color: "#DDD"
    title: "Linear dodge"
    
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
    gl_FragColor = inActiveImgFrag + activeImgFrag;
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
