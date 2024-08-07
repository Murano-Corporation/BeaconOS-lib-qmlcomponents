import QtQuick 2.0
import QtQuick.Controls 2.12

Popup {
    id: popup_root
    property alias targetDevice: compBase.targetDevice
    property alias base: compBase
    property int compBaseRadius: 0
    required property string popupName

    enabled: !DisplayController.isBusy

    width: root.contentItem.width
    height: root.contentItem.height

    anchors{
        centerIn: Overlay.overlay
    }

    background: Rectangle{
        color: "#80000000"
        radius: compBaseRadius
    }
    Comp__BASE{
        id: compBase
    }


}

