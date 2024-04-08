import QtQuick 2.0
import QtQuick.Controls 2.12

Popup {
    id: popup_root
    property alias targetDevice: compBase.targetDevice
    required property string popupName

    width: root.contentItem.width
    height: root.contentItem.height

    anchors{
        centerIn: Overlay.overlay
    }

    background: Rectangle{
        color: "#80000000"
    }
    Comp__BASE{
        id: compBase
    }


}

