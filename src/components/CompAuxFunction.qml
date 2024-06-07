import QtQuick 2.15

Comp__BASE {
    id: root

    height: 95
    width: 815

    property color fontColor1: "black"
    //property color fontColor2: "white"
    property color bgColor: "#000068"
    property color boxColor1: "#065465"
    property string buttonText1: "1"
    property string buttonText2: "2"
    property string buttonText3: "3"

    property int buttonHeight: 60
    property int levelButtonWidth: 75
    property int dropDownWidth: 335
    property int spacing: 15
    property int pixelSize: 32
    property int levelNum: 0

    Rectangle {
        anchors.fill: root
        color: root.bgColor
        radius: 10
    }

    Row {
        spacing: root.spacing

        anchors {
            verticalCenter: root.verticalCenter
            horizontalCenter: root.horizontalCenter
            left: root.left
            leftMargin: root.spacing
        }

        Comp__BASE_ComboBox {
            id: afDropDown

            height: root.buttonHeight
            width: root.dropDownWidth
        }

        CompButton{
            id: af1

            height: root.buttonHeight
            width: root.levelButtonWidth
            backgroundColor: levelNum === 1 ? "darkGreen" : root.boxColor1
            text: root.buttonText1
            fontColor: root.fontColor1
            textObject.font.pixelSize: root.pixelSize
            anchors.verticalCenter: parent.verticalCenter
            backgroundRect.radius: 10

            onPressed: {
                opacity = 0.8
            }

            onReleased: {
                opacity = 1
                levelNum = 1
            }
        }

        CompButton{
            id: af2

            height: root.buttonHeight
            width: root.levelButtonWidth
            backgroundColor: levelNum === 2 ? "darkGreen" : root.boxColor1
            text: root.buttonText2
            fontColor: root.fontColor1
            textObject.font.pixelSize: root.pixelSize
            anchors.verticalCenter: parent.verticalCenter
            backgroundRect.radius: 10

            onPressed: {
                opacity = 0.8
            }

            onReleased: {
                opacity = 1
                levelNum = 2
            }
        }

        CompButton{
            id: af3

            height: root.buttonHeight
            width: root.levelButtonWidth
            backgroundColor: levelNum === 3 ? "darkGreen" : root.boxColor1
            text: root.buttonText3
            fontColor: root.fontColor1
            textObject.font.pixelSize: root.pixelSize
            backgroundRect.radius: 10

            onPressed: {
                opacity = 0.8
            }

            onReleased: {
                opacity = 1
                levelNum = 3
            }
        }
    }
}
