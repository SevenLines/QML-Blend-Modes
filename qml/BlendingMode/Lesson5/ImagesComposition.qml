import QtQuick 2.0
import QtQuick.Controls 1.1
import "../Presentation"

Slide {
    id: slide
    anchors.fill: parent
    
    property alias image1: image1
    property alias image2: image2
    property Image activeImage: imagesRow.activeImage
    property Image inActiveImage: imagesRow.inActiveImage
    
    
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
            source: "qrc:/lesson5/assets/Sparkling.jpg"
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
