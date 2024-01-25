import QtQuick 2.12
import QtQuick.Controls 2.12
import QtGraphicalEffects 1.12

RoundButton {
    id: btnRoot

    icon.color: "White"
    icon.height: 90
    icon.width: 90
    radius: height * 0.5

    opacity: (btnRoot.enabled) ? 1.0 : 0.15

    //icon.height: 90
    contentItem: Item{}

    Image {
        id: imgIcon
        visible: false
        source: btnRoot.icon.source
        //color: btnRoot.icon.color
        sourceSize:  Qt.size(width, height)
        fillMode: Image.PreserveAspectFit
        anchors.centerIn: parent
        height: btnRoot.icon.height
        width: btnRoot.icon.width

    }

    ColorOverlay {
        source: imgIcon
        anchors.fill: imgIcon
        color: "White"
    }



    background: Image{
        source: "file:///usr/share/BeaconOS-lib-images/images/imgHomeNavBtnBg.png"
        height: parent.height
        width: parent.width
        anchors.centerIn: parent
    }
}
