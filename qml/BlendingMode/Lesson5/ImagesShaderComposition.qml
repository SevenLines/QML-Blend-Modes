import QtQuick 2.0
import QtQuick.Controls 1.1
import "../Presentation"

Slide {
    anchors.fill: parent

    Rectangle {
        id: bgRect;
        anchors.fill: parent
        color:"black"
        z: -100
    }
    
    property alias currentIndex: listImages.currentIndex
    
    ListModel {
        id: imagesModel
        
        ListElement {
            image: "qrc:/lesson5/assets/Gradient.png"
        }
        
        ListElement {
            image: "qrc:/lesson5/assets/Flower.png"
        }
        
        ListElement {
            image: "qrc:/lesson5/assets/Sparkling.jpg"     
        }
    }
    
    ListView {
        id: listImages
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.topMargin: 4
        anchors.rightMargin: 4
        model: imagesModel
        width: parent.width
        height: 80
        orientation: Qt.Horizontal
        layoutDirection: Qt.RightToLeft
        focus: true
        spacing: 4
        
        delegate: Component {   
            Rectangle {      
                id:rect
                property alias source: img.source

                border.color: "#FFF"
                border.width: 2
                width:60
                height: listImages.height
                radius: 8
                opacity: 0.25
                clip: true
                
                transitions: [
                    Transition {
                        NumberAnimation { properties: "opacity"; duration: 250 }
                    }
                ]
                
                states: [
                    State {
                        name: "hovered"
                        when: mouseArea.containsMouse && !rect.ListView.isCurrentItem 
                        PropertyChanges { target: rect; opacity: 0.75 }
                    },
                    State {
                        name: "selected"
                        when: rect.ListView.isCurrentItem 
                        PropertyChanges { target: rect; opacity: 1 }
                    }
                ]
                
                Image {
                    anchors.margins: 4
                    anchors.fill: parent
                    id: img
                    source: image
                    
                    fillMode: Image.PreserveAspectCrop
                    clip: true      
    
                    MouseArea {
                        id: mouseArea
                        hoverEnabled: true
                        anchors.fill: parent
                        onPressed: {
                            listImages.currentIndex = index
                        }
                    }   
                }
            }
        }
    }
    
    Text {
        id: txtHeader
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: 10
        text: "SlideName"
        font.pixelSize: 60
        font.bold: true
        style: Text.Outline
        color: "white"
    }

    property alias title: txtHeader.text
    property alias image1: image1
    property alias image2: image2
    property alias color: bgRect.color
    property Image activeImage: imagesRow.activeImage
    property Image inActiveImage: imagesRow.inActiveImage
    
    property string shaderMainFunc: "
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
    float outAlpha = image1Opacity + image2Opacity*(1.0 -image1Opacity );
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
    
    
    ShaderEffect {
        id: shader
        width: imagesRow.width
        height: imagesRow.height
        anchors.centerIn: imagesRow
        
        property variant image1: ShaderEffectSource {
            sourceItem: activeImage
            hideSource: true
        }
        property variant image2: ShaderEffectSource {
            sourceItem: inActiveImage
            hideSource: true
        }
        
        property real image1X: activeImage.x / imagesRow.width
        property real image1Y: activeImage.y / imagesRow.height
        property real image1Width: activeImage.width / imagesRow.width
        property real image1Height: activeImage.height / imagesRow.height
        
        property real image1Opacity: activeImage.opacity
        
        property real image2X: inActiveImage.x / imagesRow.width
        property real image2Y: inActiveImage.y / imagesRow.height
        property real image2Width: inActiveImage.width / imagesRow.width
        property real image2Height: inActiveImage.height / imagesRow.height
        
        property real image2Opacity: inActiveImage.opacity
        
        fragmentShader: "
varying highp vec2 qt_TexCoord0;

uniform sampler2D image1;

uniform float image1X;
uniform float image1Y;
uniform float image1Width;
uniform float image1Height;
uniform float image1Opacity;

uniform sampler2D image2;

uniform float image2X;
uniform float image2Y;
uniform float image2Width;
uniform float image2Height;
uniform float image2Opacity;

void main() {"
        + shaderMainFunc + 
    "}"
    }
    
    Row {
        id: imagesRow
        anchors.centerIn: parent
        spacing: 10
        
        property variant activeImage: image1.z > image2.z? image1: image2
        property variant inActiveImage: image2.z > image1.z? image1: image2

        Image {
            id: image1
            
            source: "qrc:/lesson5/assets/Flower.png"
            MouseArea {
                anchors.fill: parent
                property int startX
                property int startY
                drag.target: parent
                drag.axis: Drag.XAxis
                drag.minimumX: 0
                drag.maximumX: imagesRow.width - width
                onPressed: {
                    image1.z = 1
                    image2.z = 0
                }
            }  
            z: 0
        }
        
        Image {
            id: image2
            source: listImages.currentItem.source
            MouseArea {
                anchors.fill: parent
                property int startX
                property int startY
                drag.target: parent
                drag.axis: Drag.XAxis
                drag.minimumX: 0
                drag.maximumX: imagesRow.width - width
                onPressedChanged:  {
                    image1.z = 0
                    image2.z = 1
                }
            }
            z: 1
        }      
    }
}
