import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15

Screen__BASE {
    id: root

    screenName: "Calculator"

    property int numKeyWidth: ((calculatorScreen.width * 0.23))
    property int numKeyHeight: calculatorScreen.height * 1.4
    property int numSpacing: root.width * 0.0223
    property string inputColor: "white"
    property string outputColor: "black"
    property string keyButtonsBgColor: "#065465"
    property string inputString: UtilityCalculator.sInputString
    property string answerString: UtilityCalculator.sAnswerString
    property var currentMenu: UtilityCalculator.sCurrentMenu



    Column {
        id: calculatorScreen

        anchors {
            fill: parent
            leftMargin: 0.01 * parent.width
            rightMargin: anchors.leftMargin
            topMargin: 0.01 * parent.height
        }

        Rectangle{
            id: outputScreen

            width: calculatorScreen.width
            height: root.height * 0.18
            color: outputColor
            radius: 10

            TextInput{
                id: inputText

                text: inputString
                color: "white"
                font.pixelSize: Math.min(root.height, root.width) * 0.07
                horizontalAlignment: Qt.AlignHCenter
                verticalAlignment: Qt.AlignTop
                maximumLength: 50 // Set maximum length of text input to one line
                wrapMode: TextInput.NoWrap
                selectByMouse: true
                cursorVisible: true

                onTextChanged:{
                    UtilityCalculator.sInputString = text
                }

                cursorDelegate: Rectangle {
                    id: cursorDelegate
                    color: "white"
                    width: 2
                    height: 30

                    Timer {
                        id: cursorTimer
                        interval: 500 // Adjust blinking speed (milliseconds)
                        repeat: true
                        running: true
                        onTriggered: {
                            cursorDelegate.visible = !cursorDelegate.visible; // Toggle cursor visibility
                        }
                    }
                }

                anchors {
                    fill: parent
                    top: parent.top
                    topMargin: parent.height * 0.05
                }


                //spaces split logic


                //on cursor position changed //addproperty backend // backend needs to know when cursor changes

                Connections {
                    target: UtilityCalculator
                    function onSignal_KeyPressed(key) {
                        inputText.insert(inputText.cursorPosition, key)
                    }
                    function onSignal_Clear() {
                        inputText.clear()
                        answerText.clear() //new
                    }
                    function onSignal_BackSpace() {
                        console.log(inputText.cursorPosition)
                        inputText.remove(inputText.cursorPosition - 1, inputText.cursorPosition)
                    }
                    function onSignal_Delete() {
                        console.log(inputText.cursorPosition)
                        inputText.remove(inputText.cursorPosition, inputText.cursorPosition + 1)
                    }
                    function onSignal_MoveCursorToLeft() {
                        inputText.cursorPosition--
                    }
                    function onSignal_MoveCursorToRight() {
                        inputText.cursorPosition++
                    }

                }

            }

            TextInput{
                id: answerText

                text: answerString
                enabled: false //new
                color: "red"
                font.pixelSize: Math.min(root.height, root.width) * 0.07
                horizontalAlignment: Qt.AlignHCenter
                verticalAlignment: Qt.AlignBottom

                onTextChanged:{
                    UtilityCalculator.sAnswerString = text
                }

                anchors {
                    fill: parent
                    bottom: parent.bottom
                    bottomMargin: parent.height * 0.05
                }
            }
        }

        Item{
            id: keyPad

            anchors {
                leftMargin: 0.05 * parent.width
                rightMargin: anchors.leftMargin
                bottom: parent.bottom
                bottomMargin: parent.height * 0.8
            }

            Grid{
                columns: 4
                columnSpacing: root.width * 0.02
                rowSpacing: root.height * 0.02

                Repeater{
                    model: 20

                    Button{
                        id: keyButtons

                        width: root.width * 0.23
                        height: root.height * 0.14

                        background: Rectangle {
                            id: keyButtonsBg
                            color: root.keyButtonsBgColor
                            radius: 20
                        }

                        CompLabel{
                            id: keyButtonText

                            text: root.currentMenu[index]
                            color: "white"
                            font.pixelSize: Math.min(root.height, root.width) * 0.05
                            anchors.centerIn: parent
                        }

                        onClicked:{
                            //actions[index]()
                            UtilityCalculator.calculate(index)
                        }
                    }
                }
            }
        }
    }
}

