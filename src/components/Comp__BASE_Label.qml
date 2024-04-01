import QtQuick 2.0
import QtQuick.Controls 2.12

Label {

    property alias targetDevice: compBase.targetDevice
    font.pixelSize: 25
    Comp__BASE{
        id: compBase
    }

}
