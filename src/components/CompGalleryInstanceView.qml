import QtQuick 2.12

import QtQuick.Controls 2.12
import Qt.labs.qmlmodels 1.0
import CONSTANTS 1.0

Comp__BASE{
    id: galleryInstanceViewRoot

    property int imageIndex: -1
    property int maxImageIndex: 1
    property string stringIndex: (imageIndex >= 0 ? (imageIndex <= 8 ? ('0' + (imageIndex+1)) : ((imageIndex+1))) : '')
    property string imageIdName: imageIndex !== -1 ? (qsTr("IMG ") + stringIndex) : 'null'
    property string imageSource: ""
    property string timestampLong: ""
    property string timestampShort: ""
    property string gpsCoords: ""
    property var inference
    property string breadcrumbName:  imageIdName !== 'null' ? (imageIdName + " - " + timestampShort) : 'null'
    property string modelConfidence: ""
    property string modelAccuracy: ""


    signal indexChanged(int newIndex)

    onImageIndexChanged: {
        if(imageIndex === -1)
        {

            return;
        }

        var modelIndex = TableModelCameraGallery.index(imageIndex, 0)

        imageSource = TableModelCameraGallery.data(modelIndex, Constants.DataRole_ImgPath)
        timestampLong = TableModelCameraGallery.data(modelIndex, Constants.DataRole_Timestamp_Long)
        timestampShort = TableModelCameraGallery.data(modelIndex, Constants.DataRole_Timestamp_Short)
        gpsCoords = TableModelCameraGallery.data(modelIndex, Constants.DataRole_GpsCoords)
        inference = TableModelCameraGallery.data(modelIndex, Constants.DataRole_Inference)

    }

    anchors {
    }

    clip: true

    Image{
        id: imgProcessed

        anchors{
            top: parent.top
            left: parent.left
            bottom: parent.bottom
            right: navControls.left
            rightMargin: 74
        }


        fillMode: Image.PreserveAspectFit
        source: galleryInstanceViewRoot.imageSource !== "" ? "file://" + galleryInstanceViewRoot.imageSource : ""
        sourceSize: Qt.size(width, height)

    }

    Item {
        id: navControls

        anchors{
            top: imgProcessed.top
            right: parent.right
            rightMargin: 74
        }

        width: 643
        height: 38

        CompIconBtn{
            id: btnLeft

            enabled: galleryInstanceViewRoot.imageIndex > 0

            anchors{
                top: parent.top
                left: parent.left
                leftMargin: 54
                bottom: parent.bottom
            }

            width: height
            iconUrl: "file:///usr/share/BeaconOS-lib-images/images/LeftArrow.svg"
            iconColor: "White"
            iconHeight: height

            onClicked: galleryInstanceViewRoot.indexChanged(galleryInstanceViewRoot.imageIndex - 1)
        }

        CompLabel {
            id: lblImageName

            anchors{
                left: btnLeft.right
                top: parent.top
                right: btnRight.left
                bottom: parent.bottom
            }

            text: galleryInstanceViewRoot.imageIdName
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            font{
                pixelSize: 40
                weight: Font.Light
            }
            color: "White"
        }

        CompIconBtn{
            id: btnRight

            enabled: galleryInstanceViewRoot.imageIndex < (galleryInstanceViewRoot.maxImageIndex-1)

            anchors{
                top: parent.top
                right: parent.right
                rightMargin: 54
                bottom: parent.bottom
            }

            width: height
            iconUrl: "file:///usr/share/BeaconOS-lib-images/images/RightArrow.svg"
            iconColor: "White"

            onClicked: galleryInstanceViewRoot.indexChanged(galleryInstanceViewRoot.imageIndex + 1)
        }
    }

    CompCVResults{
        id: rectContents

        timestamp: galleryInstanceViewRoot.timestampLong
        gpsCoords: galleryInstanceViewRoot.gpsCoords
        inference: galleryInstanceViewRoot.inference

        anchors{
            top: navControls.bottom
            topMargin: 34
            right: navControls.right
            left: navControls.left
            bottom: parent.bottom
        }
    }


}

/*##^##
Designer {
    D{i:0;autoSize:true;formeditorZoom:0.5;height:480;width:640}
}
##^##*/
