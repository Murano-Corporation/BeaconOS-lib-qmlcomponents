import QtQuick 2.12
import QtQuick.Controls 2.12

Item {
    id: btnBreadcrumb
    property alias text: lblContent.text
    property string screenTargetName: ''
    property alias fontPixelSize: lblContent.font.pixelSize
    property alias fontWeight: lblContent.font.weight
    property alias textColor: lblContent.color

    height: lblContent.implicitHeight
    width: lblContent.implicitWidth

    CompLabel {
        id: lblContent

        text: parent.text
        color: "White"
        font{
            pixelSize: 24
            weight: Font.ExtraBold
        }
    }

    MouseArea{
        anchors{
            fill: parent
        }

        onClicked: {
            if(SingletonScreenManager.currentScreenName === text)
                return

            SingletonScreenManager.slot_GoToBreadcrumbScreen(text)
        }
    }
}
