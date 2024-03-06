import QtQuick 2.12
import QtQuick.Controls 2.12

Comp__BASE {
    id: btnCompIconRoot

    property alias mousearea: mouseArea
    property string iconUrl: "file:///usr/share/BeaconOS-lib-images/images/Img_Beacon.png"
    property color iconColor: "Black"
    property int iconHeight: height

    property alias imageIcon: compImgIconRoot
    signal clicked()

    width: height

    opacity: enabled ? 1.0 : 0.3

    
    CompImageIcon {
        id: compImgIconRoot
        anchors.fill: parent

        image.source: btnCompIconRoot.iconUrl
        color: btnCompIconRoot.iconColor
        height: btnCompIconRoot.iconHeight
        width: height


    }



    MouseArea {
        id: mouseArea
        anchors.centerIn: parent

        width: parent.width * 1.5
        height: parent.height * 1.5

        onClicked: {
            parent.clicked()
        }



    }

}
