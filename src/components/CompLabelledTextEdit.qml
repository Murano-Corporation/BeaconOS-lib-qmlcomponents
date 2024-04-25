import QtQuick 2.0

Item{
    id: compLabelledTextEdit

    property bool isReadonly: true
    property bool showDevRects: false
    property alias label: lbl
    property alias textEdit: edt
    property alias text: lbl.text
    property alias value: edt.text
    property alias spacing: row.spacing
    property alias row: row

    property real labelWidthPercentage: 0.5
    property real editWidthPercentage: 0.5

    property real __controlWidthActual: width - spacing
    property real __labelWidthActual: __controlWidthActual * labelWidthPercentage
    property real __editWidthActual: __controlWidthActual * editWidthPercentage

    height: 60
    width: 600

    Loader{
        active: compLabelledTextEdit.showDevRects
        anchors.fill: parent

        sourceComponent:     Rectangle{
            id: rectDEV

            color: "#8000ff00"
        }
    }


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
            width: compLabelledTextEdit.__labelWidthActual

            Loader {
                active: compLabelledTextEdit.showDevRects
                anchors.fill: parent
                sourceComponent: Rectangle{

                    color: "#80ffffff"
                }
            }


        }

        TextInput{
            id: edt

            readOnly: compLabelledTextEdit.isReadonly

            height: parent.height
            width: compLabelledTextEdit.__editWidthActual

            horizontalAlignment: Text.AlignRight
            verticalAlignment: Text.AlignVCenter

            font{
                pixelSize: lbl.font.pixelSize
                weight: lbl.font.weight
                family: lbl.font.family
            }

            color: "#80ffffff"

            Loader {
                active: compLabelledTextEdit.showDevRects
                anchors.fill: parent
                sourceComponent: Rectangle{

                    color: "#80000000"
                }
            }
        }
    }


}
