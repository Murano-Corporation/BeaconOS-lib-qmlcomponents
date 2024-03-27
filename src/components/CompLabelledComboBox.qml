import QtQuick 2.12
import QtQuick.Controls 2.15

Item{
    id: compLabelledComboBox

    property alias text: lbl.text
    property alias textFontPixelSize: lbl.font.pixelSize
    property real comboWidth: 450
    property alias rowSpacing: row.spacing
    property alias comboModel: combo.model
    property alias currentValue: combo.currentValue
    property alias currentText: combo.currentText
    property alias currentIndex: combo.currentIndex



    Row{
        id: row

        spacing: 26

        anchors{
            fill: parent
        }

        CompLabel{
            id: lbl

            width: row.width - row.spacing - combo.width
            height: parent.height
            text: "SetMe:"
            visible: text !== ""

            font.pixelSize: 28

            horizontalAlignment: Text.AlignRight
            verticalAlignment: Text.AlignVCenter


        }

        CompCombobox{
            id: combo

            height: parent.height
            width: compLabelledComboBox.comboWidth
        }


    }
}
