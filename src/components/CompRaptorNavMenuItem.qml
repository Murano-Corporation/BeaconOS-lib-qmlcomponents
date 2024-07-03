import QtQuick 2.0

CompGlassRect {
    id: compRaptorNavMenuItemRoot

    height: 90
    width: 90

    anchors.fill: undefined

    property alias imgIconSrc: imgIcon.source
    property alias imgIconColor: imgIcon.color
    signal clicked()

    CompImageIcon{
        id: imgIcon

        anchors.fill: parent
        anchors.margins: 10
    }

    MouseArea{
        anchors.fill: parent
        onClicked: compRaptorNavMenuItemRoot.clicked()
    }
}
