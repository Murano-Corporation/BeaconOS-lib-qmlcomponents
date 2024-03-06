import QtQuick 2.12
import QtQuick.Controls 2.12
import QtGraphicalEffects 1.12

Comp__BASE {
    id: iconImageRoot
    
    property alias color: colorOverlay.color
    property alias verticalAlignment: compImageIcon.verticalAlignment
    property real iconHeight: height
    property real iconWidth: width
    property alias image: compImageIcon
    property alias source: compImageIcon.source
    property alias colorOverlay: colorOverlay

    Image {
        id: compImageIcon

        height: parent.iconHeight
        width: parent.iconWidth

        source: "file:///usr/share/BeaconOS-lib-images/images/HelpFill.svg"
        sourceSize: Qt.size(height, width)
        fillMode: Image.PreserveAspectFit
        anchors.centerIn: parent
        antialiasing: true
        smooth: true
        visible: false





    }

    ColorOverlay {

        id: colorOverlay
        anchors.fill: compImageIcon
        antialiasing: true
        smooth: true
        source: compImageIcon

    }
}


/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*/
