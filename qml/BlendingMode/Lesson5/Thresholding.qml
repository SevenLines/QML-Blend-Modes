import QtQuick 2.0
import QtQuick.Controls 1.1
import "../Presentation"

Slide {
    anchors.fill: parent

    Rectangle {
        id: bgRect;
        anchors.fill: parent
        color:"white"
        z: -100
        
        Image {
            anchors.fill: parent
            source: "qrc:/lesson5/assets/thresholding.jpg"
            fillMode: Image.PreserveAspectFit 
        }
    }
    
    ShaderEffect {
        anchors.fill: parent
        property variant src: ShaderEffectSource {
            sourceItem: bgRect
            hideSource: true
        }
        property real offset: slider.value
        property bool black: chkBlackAndWhite.checked
        
        fragmentShader: "
uniform sampler2D src;
uniform float offset;
uniform bool black;
varying highp vec2 qt_TexCoord0;

void main() {
    vec4 clr = texture2D(src, qt_TexCoord0);

    float v = (0.21*clr.r + 0.71*clr.g + 0.08*clr.b);
    if (v == 0.0) {
        gl_FragColor = vec4(v);
        return;
    }
    if (v >= offset) {
        clr = vec4(1.0);
    } else if (black) {
        clr = vec4(0.0);
    }
    gl_FragColor = clr;
}
"
    }
    
    Item {
        anchors.right: parent.right
        width: 60
        height: parent.height
        MouseArea {
            anchors.fill: parent;
        }
        Column {
            anchors.fill: parent
            spacing: 30
            anchors.bottomMargin: 20
            anchors.topMargin: 20
            Slider {
                id: slider
                orientation: Qt.Vertical
                height: parent.height - 50

                minimumValue: 0
                maximumValue: 1.0
                value: 0.999
            }
            CheckBox {
               id:chkBlackAndWhite 
            }
        }

    }
    
}
