import QtQuick 2.15
import QtQuick.Controls 2.15
Comp__BASE {

    property alias textSpeed: tlSpeed.text

    Button {
        id: tlSpeed
        height: 38
        width: 33
        font.pixelSize: 16
    }
}
