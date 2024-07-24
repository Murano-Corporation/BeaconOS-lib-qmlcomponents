import QtQuick 2.12
import QtQuick.Controls 2.15

Comp__BASE{
    id: compTextField

    property alias radius: rectBG.radius
    property alias spacing: row.spacing
    property alias lblText: lbl.text
    property alias lblWidth: lbl.width
    property alias lblFontPixelSize: lbl.font.pixelSize
    property alias textEditWidth: focusEdt.width
    property alias textEditHeight: focusEdt.height
    property alias text: edt.text
    property alias placeholderText: edt.placeholderText
    property alias edtEchoMode: edt.echoMode
    property alias edtFontPixelSize: edt.font.pixelSize
    property alias backgroundRect: rectBG
    property string dataTypeName: "QString"

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
            opacity: enabled ? 1.0 : 0.3
            anchors{
                verticalCenter: row.verticalCenter
            }

            border{
                color: "#4DE9E9E9"
            }
            radius: height * 0.5

            color: "transparent"

            FocusScope{
                id: focusEdt
                anchors{
                    fill: parent
                    leftMargin: rectBG.radius
                    rightMargin: rectBG.radius
                    topMargin: 10
                    bottomMargin: 10
                }

                onFocusChanged: {
                    if(!focus)
                    {
                        return;
                    }
                    if(compTextField.isPopupComponent === true)
                    {
                        InputHandler.slot_OnPopupFocusChanged(popupName, focus)
                    } else {
                        InputHandler.slot_OnFocusChanged(this, mapToGlobal(0,0), Qt.size(edt.width, edt.height))

                    }
                }

                TextField {
                    id: edt

                    anchors{
                        fill: parent
                    }


                    color: "White"
                    placeholderTextColor: "Grey"

                    placeholderText: qsTr("Enter SSID...")

                    verticalAlignment: "AlignVCenter"
                    font.pixelSize: 20
                    font.family: "Lato"
                    font.weight: Font.Normal

                    background: Item {}

                    onReleased: {
                        edt.selectAll()
                    }

                    onActiveFocusChanged: {
                        if(edt.activeFocus)
                            edt.selectAll()
                    }
                    // onFocusChanged: {
                    // selectAllText()
                    // }
                }

            }



        }
    }
}
