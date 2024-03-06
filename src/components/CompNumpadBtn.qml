import QtQuick 2.12
import QtQuick.Controls 2.12
import QtGraphicalEffects 1.12

Comp__BASE {
    id: compNumpadBtnRoot

    property alias isPressed: btn.pressed

    height: 100
    width: 100
    
    signal clicked(string txt)

    property string text: 'Text'
    property real fontSize: 40
    property color textColor: 'White'
    property Text textComp: textComp

    opacity: isPressed ? 0.6 : 1.0

    RoundButton {
        id:btn
        text: parent.text
        anchors.fill:parent
        font.pointSize: 66
        radius: 0.5 * height

        onClicked: {
            parent.clicked(text)
        }

        onPressAndHold: {
            optionsPopup.open()
        }

        contentItem: Text {
            id: textComp
            anchors.centerIn: parent
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font.family: "Lato"
            text: compNumpadBtnRoot.text
            color: compNumpadBtnRoot.textColor
            bottomPadding: 15
            font{
                pointSize: compNumpadBtnRoot.fontSize
            }
        }

        background: Rectangle{
            id: bgImage
            anchors.fill: parent

            radius: (btn.pressed ? 0.40 * height : 0.5 * height)

            color: "#10FFFFFF"
        }
      
    }

    Popup {
        id: optionsPopup
        width: parent.width
        height: parent.height
        modal: true
        anchors.centerIn:  parent
        background: Item{}

        Item{
            id: popupContents

            anchors.fill: parent
        }
        Row {
            anchors.bottom: parent.top
            anchors.horizontalCenter: popupContents.horizontalCenter
            Repeater{
                model: compAlphaNumPinBtnRoot.listOfOptions.length

                Rectangle {
                    color: "#000000"

                    height: compNumpadBtnRoot.height
                    width: compNumpadBtnRoot.width
                    //border.width: 4

                    CompLabel {
                        text: compAlphaNumPinBtnRoot.listOfOptions[index]
                        anchors.centerIn: parent
                    }

                    MouseArea {
                        anchors.fill: parent

                        onClicked: {
                            //console.log("Clicked the mousearea to select the option")
                            var textOut = compAlphaNumPinBtnRoot.listOfOptions[index]
                            compAlphaNumPinBtnRoot.alphaNumPinClicked(textOut)
                            optionsPopup.close()
                        }
                    }

                }
            }
        }
    }
}
