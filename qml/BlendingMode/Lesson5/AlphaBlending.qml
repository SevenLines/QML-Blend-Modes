import QtQuick 2.0
import "../Utils"
import QtQuick.Controls 1.1

ImagesShaderComposition {
        
    title: "Alpha blend"
    
    currentIndex: 2

    onActiveImageChanged: {
        sliderAlpha.value = activeImage.opacity * 100
    }
    
    Component.onCompleted:  {
        sliderAlpha.value = 100
    }
    
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
    gl_FragColor = (activeImgFrag * vec4(image1Opacity)
             + inActiveImgFrag * vec4(image2Opacity) * (vec4(1.0)-vec4(image1Opacity)));
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

    Row {
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
    
        spacing: 30
        Slider {
            id: sliderAlpha
            width: 512
            height: 60
            maximumValue: 100
            minimumValue: 0
            onValueChanged: {
                activeImage.opacity = value / 100
            }
        }
        Text {
            width: 100
            text: (sliderAlpha.value | 0) + "%"
            color: "white"
            font.pixelSize: 60
            font.weight: Font.Bold
            anchors.verticalCenter: sliderAlpha.verticalCenter
        }
        
    }
}
