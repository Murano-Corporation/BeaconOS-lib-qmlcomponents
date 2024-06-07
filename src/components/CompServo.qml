import QtQuick 2.15
import QtQuick.Controls 2.15

Comp__BASE {
    id: root

    height: 95
    width: 815

    property color fontColor1: "black"
    //property color fontColor2: "white"
    property color bgColor: "#000068"
    property color boxColor1: "#065465"
    property color boxColor2: "white"

    property string buttonText1: "1"
    property string buttonText2: "2"
    property string buttonText3: "3"
    property string buttonText4: "Toggle"
    property string inputText1: "txt1"
    property string inputText2: "txt2"
    property string inputText3: "text3"

    property int levelButtonHeight: 60
    property int levelButtonWidth: 75
    property int longButtonWidth: 140
    property int minMaxHeight: 50
    property int mixMaxWidth: 95
    property int spacing: 15
    property int pixelSize: 32
    property int levelNum: 0

    property bool toggle

    Rectangle {
        anchors.fill: root
        color: root.bgColor
        radius: 10
    }

    Row {
        id: row

        spacing: root.spacing

        anchors {
            horizontalCenter: root.horizontalCenter
            verticalCenter: root.verticalCenter
        }

        CompButton{
            id: s1

            height: root.levelButtonHeight
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
            id: s2

            height: root.levelButtonHeight
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
            id: s3

            height: root.levelButtonHeight
            width: root.levelButtonWidth
            backgroundColor: levelNum === 3 ? "darkGreen" : root.boxColor1
            text: root.buttonText3
            fontColor: root.fontColor1
            textObject.font.pixelSize: root.pixelSize
            anchors.verticalCenter: parent.verticalCenter
            backgroundRect.radius: 10

            onPressed: {
                opacity = 0.8
            }

            onReleased: {
                opacity = 1
                levelNum = 3
            }
        }

        CompButton{
            id: sToggle

            height: root.levelButtonHeight
            width: root.longButtonWidth
            backgroundColor: root.toggle ? "darkGreen" : root.boxColor1
            text: root.buttonText4
            fontColor: root.fontColor1
            textObject.font.pixelSize: root.pixelSize
            anchors.verticalCenter: parent.verticalCenter
            backgroundRect.radius: 10

            onPressed: {
                opacity = 0.8
            }

            onReleased: {
                opacity = 1
                root.toggle = !root.toggle
            }
        }

        Rectangle {
            id: sText

            height: root.levelButtonHeight
            width: root.longButtonWidth
            color: root.boxColor2
            anchors.verticalCenter: parent.verticalCenter
            radius: 10

            TextInput {
                text: root.inputText1
                color: root.fontColor1
                font.pixelSize: root.pixelSize
                horizontalAlignment: TextInput.AlignHCenter

                anchors{
                    verticalCenter: parent.verticalCenter
                    left: parent.left
                    right: parent.right
                }
            }
        }

        Rectangle {
            id: sText2

            height: root.minMaxHeight
            width: root.mixMaxWidth
            color: root.boxColor2
            anchors.verticalCenter: parent.verticalCenter
            radius: 10

            TextInput {

                text: root.inputText2
                color: root.fontColor1
                font.pixelSize: root.pixelSize
                horizontalAlignment: TextInput.AlignHCenter

                anchors{
                    verticalCenter: parent.verticalCenter
                    left: parent.left
                    right: parent.right
                }
            }
        }
        Rectangle {
            id: sText3

            height: root.minMaxHeight
            width: root.mixMaxWidth
            color: root.boxColor2
            anchors.verticalCenter: parent.verticalCenter
            radius: 10

            TextInput {
                text: root.inputText3
                color: root.fontColor1
                font.pixelSize: root.pixelSize
                horizontalAlignment: TextInput.AlignHCenter

                anchors{
                    verticalCenter: parent.verticalCenter
                    left: parent.left
                    right: parent.right
                }
            }
        }
    }
}
