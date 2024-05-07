import QtQuick 2.0

Comp__BASE{
    id: popup_Settings_Camera

    property real controlWidth: 600

    CompLabel{
        id: lblTitle

        text: "Camera"

        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignBottom

        height: 40
        width: parent.width
        font.pixelSize: isDelta ? 25 : 60
    }

    CompPopupBG{
        anchors.fill: parent
        anchors.topMargin: isDelta ? 0 : 65

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
