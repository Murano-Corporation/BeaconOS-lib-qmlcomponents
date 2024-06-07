import QtQuick 2.15
import QtQuick.Controls 2.15
import QtGraphicalEffects 1.15

Comp__BASE {
    id: iconImageRoot
    
    property alias colorOverlay: colorOverlayComp
    property alias color: colorOverlayComp.color
    property alias verticalAlignment: compImageIcon.verticalAlignment
    property real iconHeight: height
    property real iconWidth: width
    property alias image: compImageIcon
    property alias source: compImageIcon.source

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

        id: colorOverlayComp
        anchors.fill: compImageIcon
        antialiasing: true
        smooth: true
        source: compImageIcon

    }
}



