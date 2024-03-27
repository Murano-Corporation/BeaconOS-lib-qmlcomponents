import QtQuick 2.12
import QtQuick.Controls 2.15

Item{
    id: compTextField

    property alias radius: rectBG.radius
    property alias spacing: row.spacing
    property alias lblText: lbl.text
    property alias lblFontPixelSize: lbl.font.pixelSize
    property alias textEditWidth: rectBG.width
    property alias textEditHeight: rectBG.height
    property alias text: edt.text
    property alias placeholderText: edt.placeholderText
    property alias edtEchoMode: edt.echoMode

    width: 514
    height: 80

    Row{
        id: row
        spacing: 24

        height: parent.height
        width: parent.width

        CompLabel{
            id: lbl

            text: "SetMe"
            visible: text !== ""

            height: parent.height
            width: compTextField.width - rectBG.width - row.spacing
            font.pixelSize: 28

            horizontalAlignment: Text.AlignRight
            verticalAlignment: Text.AlignVCenter
        }

        Rectangle{
            id: rectBG
            width: 450
            height: parent.height

            anchors{
                verticalCenter: row.verticalCenter
            }

            border{
                color: "#4DE9E9E9"
            }
            radius: height * 0.5

            color: "transparent"

            TextField {
                id: edt

                anchors{
                    fill: parent
                    leftMargin: rectBG.radius
                    rightMargin: rectBG.radius
                    topMargin: 10
                    bottomMargin: 10
                }


                color: "White"
                placeholderTextColor: "Grey"

                placeholderText: qsTr("Enter SSID...")

                verticalAlignment: "AlignVCenter"
                font.pixelSize: 20
                font.family: "Lato"
                font.weight: Font.Normal

                background: Item {}

            }
        }



    }




}
