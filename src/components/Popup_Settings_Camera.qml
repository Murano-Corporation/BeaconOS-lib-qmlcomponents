import QtQuick 2.0

Item{
    id: popup_Settings_Camera

    property real controlWidth: 600

    CompPopupBG{
        anchors.fill: parent

        CompToggle{
            id: switchCameraFlipped
            width: popup_Settings_Camera.controlWidth
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
