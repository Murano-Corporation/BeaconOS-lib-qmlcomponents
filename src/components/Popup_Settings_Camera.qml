import QtQuick 2.0

Popup_Settings_View__BASE{
    id: popup_Settings_Camera

    viewName: "Camera Settings"

    Column{
        anchors.fill: contents
        anchors.margins: 20

        CompToggle{
            id: switchCameraFlipped
            width: parent.width
            text: "Flip View:"

            Component.onCompleted: {
                isOn = Settings.cameraRotationOffset === 180
            }

            onIsOnChanged: {
                Settings.cameraRotationOffset = (isOn ? 180 : 0)
            }
        }

    }


}
