import QtQuick 2.0

CompGlassRect {
    id: compRaptorNavMenuItemRoot

    property alias imageIcon: imgIcon
    property alias imgIconSrc: imgIcon.source
    property alias imgIconColor: imgIcon.color

    signal clicked()
    signal longPressed()


    height: 90
    width: 90

    anchors.fill: undefined


    CompImageIcon{
        id: imgIcon

        anchors.fill: parent
        anchors.margins: 10
    }

    MouseArea{
        anchors.fill: parent
        onClicked: parent.clicked()
        onPressAndHold: parent.longPressed()
    }
}
