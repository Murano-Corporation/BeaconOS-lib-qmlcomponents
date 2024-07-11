import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15

Screen__BASE {
    id: root

    screenName: "Calculator"

    property int numKeyWidth: ((calculatorScreen.width * 0.23))
    property int numKeyHeight: calculatorScreen.height * 1.4
    property int numSpacing: root.width * 0.0223
    property int keyFontSize: Math.min(root.height, root.width) * 0.06
    property string inputColor: "white"
    property string outputColor: "black"
    property string keyButtonsBgColor: "#065465"
    property string inputString: UtilityCalculator.sInputString
    property string answerString: UtilityCalculator.sAnswerString
    property var currentMenu: UtilityCalculator.sCurrentMenu
    property var variables: UtilityCalculator.mVariables
    property bool varMenuOpen: false

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
            height: varMenuOpen ? root.height * 0.94 : root.height * 0.18
            color: outputColor
            // border.color: inputColor
            // border.width: 2
            radius: 10

            // Behavior on height{
            //     NumberAnimation{
            //         duration: 1000
            //     }
            // }


            TextInput{
                id: inputText

                visible: varMenuOpen ? false : true

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

                    visible: varMenuOpen ? false : true

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
                        if (answerText !== "") {
                            answerText.clear()
                        }

                        inputText.insert(inputText.cursorPosition, key)
                    }
                    function onSignal_Clear() {
                        inputText.clear()
                        answerText.clear() //new
                    }
                    function onSignal_BackSpace() {
                        if (answerText !== "") {
                            answerText.clear()
                        }
                        console.log(inputText.cursorPosition)
                        inputText.remove(inputText.cursorPosition - 1, inputText.cursorPosition)
                    }
                    function onSignal_Delete() {
                        if (answerText !== "") {
                            answerText.clear()
                        }
                        console.log(inputText.cursorPosition)
                        inputText.remove(inputText.cursorPosition, inputText.cursorPosition + 1)
                    }
                    function onSignal_MoveCursorToLeft() {
                        if (answerText !== "") {
                            answerText.clear()
                        }
                        inputText.cursorPosition--
                    }
                    function onSignal_MoveCursorToRight() {
                        if (answerText !== "") {
                            answerText.clear()
                        }
                        inputText.cursorPosition++
                    }
                    function onSignal_OpenVarMenu() {
                        varMenuOpen = true
                    }

                }

            }

            TextInput{
                id: answerText

                visible: varMenuOpen ? false : true

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

            visible: varMenuOpen ? false : true

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

                    CompBtnBreadcrumb{
                        id: keyButtons

                        visible: varMenuOpen ? false : true

                        width: root.width * 0.23
                        height: root.height * 0.14

                        text: root.currentMenu[index]
                        // color: "white"
                        font.pixelSize: keyFontSize
                        //font.pixelSize: Math.min(root.height, root.width) * 0.05
                        //anchors.centerIn: parent

                        // CompLabel{
                        //     id: keyButtonText


                        // }

                        onClicked:{
                            //actions[index]()
                            UtilityCalculator.calculate(index)
                        }
                    }
                }
            }
        }

        Item{
            id: variableList

            visible: varMenuOpen ? true : false

            x: outputScreen.width * 0.01
            y: outputScreen.height * 0.03

            ListView{

                width: outputScreen.width * 0.98
                height: outputScreen.height * 0.94
                spacing: outputScreen.height * 0.02

                model: ListModel {
                    id: myModel

                }

                Component.onCompleted: {
                    myModel.append({ "name": "Return"});
                    for (var key in root.variables) {
                        myModel.append({ "name": key, "value": root.variables[key]});
                    }
                    myModel.append({ "name": "New Variable"});
                }

                delegate: CompBtnBreadcrumb{
                    id: listButtons

                    visible: varMenuOpen ? true : false

                    width: outputScreen.width * 0.98
                    height: outputScreen.height * 0.1
                    text: {
                        if (index !== 0 && index !== myModel.count - 1) {
                            return model.name + " - " + model.value;
                        } else {
                            return model.name;
                        }
                    }

                    //root.currentMenu[index]
                    //color: "white"
                    font.pixelSize: Math.min(root.height, root.width) * 0.07
                    //font.pixelSize: Math.min(root.height, root.width) * 0.05

                    onClicked:{
                        //actions[index]()
                        UtilityCalculator.varMenu(index)
                        varMenuOpen = false
                        //set Menu to Main
                    }
                }
                ScrollBar.vertical: ScrollBar{
                    policy: ScrollBar.AlwaysOn
                    width: 8
                    //position: position + 4
                    //topInset: 51
                    topPadding: 10
                    bottomPadding: 10
                }
            }
        }

    }
}

