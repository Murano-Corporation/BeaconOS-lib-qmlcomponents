import QtQuick 2.12
import QtQuick.Controls 2.15

Item{
    id: compToggle

    property alias text: lbl.text
    property alias isOn: compSwitch.isOn
    property alias colorOn: compSwitch.colorOn
    property alias colorOff: compSwitch.colorOff
    property alias font: lbl.font
    property alias labelWidth: lbl.width
    property alias labelSpacing: row.spacing

    height: 60

    Row{
        id: row
        anchors{
            top: parent.top
            bottom: parent.bottom
            left: parent.left
        }
        spacing: 20
        CompLabel{
            id: lbl

            text: ""
            font.pixelSize: 28
            visible: text !== ""
            horizontalAlignment: Text.AlignRight
            verticalAlignment: Text.AlignVCenter
            height: parent.height
            width: compToggle.width - parent.spacing - compSwitch.width
        }

        CompSwitch {
            id: compSwitch

            height: parent.height
        }
    }

}
