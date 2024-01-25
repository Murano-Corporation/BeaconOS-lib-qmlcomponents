import QtQuick 2.12
import QtQuick.Controls 2.12

Item {
    id: btnCaptureLeft


    property bool isPressed: false
    property string imgSrcIdle: "file:///usr/share/BeaconOS-lib-images/images/BtnCameraCapture_Idle.png"
    property string imgSrcPressed: "file:///usr/share/BeaconOS-lib-images/images/BtnCameraCapture_Pressed.png"
    property string imgSrcCurrent: isPressed ? imgSrcPressed : imgSrcIdle

    signal clicked()
    signal longPressed()

    opacity: enabled ? 1.0 : 0.3

    height: 75
    width: 75


    Image{
        anchors{
            fill: parent
        }

        source: btnCaptureLeft.imgSrcCurrent
        sourceSize: Qt.size(width, height)
        antialiasing: true
    }


    MouseArea{
        anchors.fill: parent

        onClicked: parent.clicked()
        onPressAndHold: parent.longPressed()
        onPressed: parent.isPressed = true
        onReleased: parent.isPressed = false
    }

}

/*##^##
Designer {
    D{i:0;formeditorColor:"#4c4e50"}
}
##^##*/
