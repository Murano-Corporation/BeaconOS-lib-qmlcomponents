import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import CONSTANTS 1.0

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
    property string streamString: UtilityCalculator.sStream
    property var currentMenu: UtilityCalculator.sCurrentMenu
    property var variables: UtilityCalculator.mVariables
    property bool varMenuOpen: false
    //property bool streamMenuOpen: false
    property bool streamingText: UtilityCalculator.bStreamingText

    Timer {
        id: fadeTimer
        interval: 8000 //
        repeat: false // Run only once
        running: false // Not running initially

        onTriggered: {
            console.log("Timer triggered after 8 seconds")
            UtilityCalculator.sAnswerString = ""
            fadeTimer.running = false
        }
    }

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

            clip: true

            width: calculatorScreen.width
            height: (varMenuOpen) ? root.height * 0.94 : root.height * 0.18
            color: outputColor
            // border.color: inputColor
            // border.width: 2
            radius: 10

            // Behavior on height{
            //     NumberAnimation{
            //         duration: 1000
            //         // onStarted {
            //         //     //all the true things become false
            //         // }

            //         // onCompleted {
            //         //     //all the false things become true
            //         // }
            //     }
            // }


            TextInput{
                id: inputText

                visible: (varMenuOpen || streamingText) ? false : true

                text: inputString
                color: "white"
                font.pixelSize: Math.min(root.height, root.width) * 0.05
                horizontalAlignment: Qt.AlignHCenter
                verticalAlignment: Qt.AlignTop
                maximumLength: 60 // Set maximum length of text input to one line
                wrapMode: TextInput.NoWrap
                selectByMouse: true
                cursorVisible: true

                onTextChanged:{
                    UtilityCalculator.sInputString = text
                }

                cursorDelegate: Rectangle {
                    id: cursorDelegate

                    visible: (varMenuOpen || streamingText) ? false : true

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
                        answerText.clear()
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
                    function onSignal_OpenVarMenu() {
                        varMenuOpen = true
                    }
                    function onSignal_CloseVarMenu() {
                        varMenuOpen = false
                    }

                    // function onSignal_OpenStreamMenu() {
                    //     //streamMenuOpen = true
                    //     streamingText = false
                    // }
                    // function onSignal_CloseStreamMenu() {
                    //     //streamMenuOpen = false
                    // }
                }

            }

            TextInput{
                id: answerText

                visible: (varMenuOpen || streamingText) ? false : true

                text: answerString
                enabled: false //new
                color: "red"
                font.pixelSize: Math.min(root.height, root.width) * 0.05
                horizontalAlignment: Qt.AlignHCenter
                verticalAlignment: Qt.AlignBottom

                onTextChanged:{
                    UtilityCalculator.sAnswerString = text
                    fadeTimer.running = true
                }

                anchors {
                    fill: parent
                    bottom: parent.bottom
                    bottomMargin: parent.height * 0.05
                }
            }

            CompLabel{
                id: streamText

                visible: (streamingText) ? true : false

                // Rectangle {
                //     anchors.fill: parent
                //     border.color: "green"
                //     color: "transparent"
                // }

                text: streamString

                color: "white"
                font.pixelSize: Math.min(root.height, root.width) * 0.07
                horizontalAlignment: Text.AlignHCenter
                //verticalAlignment: streamMenuOpen ? Text.Align : Text.AlignVCenter
                anchors.verticalCenter: parent.verticalCenter

                // anchors {
                //     fill: parent
                //     top: parent.top
                //     topMargin: streamMenuOpen ? parent.height * 0.1 : parent.height * 0.3

                // }

                transform: Translate {
                    //reset on destroyed
                    id: scrollTranslate

                    x: outputScreen.width

                    Behavior on x {
                        id: behaveScroll
                        NumberAnimation {
                            duration: 1000
                        }
                    }

                }

                Timer {
                    id: scrollTimer

                    property int xTranslateIncrement: -400
                    property int endOfText: scrollTranslate.x + streamText.width

                    interval: 1000
                    repeat: true

                    onTriggered: {
                        if(endOfText < 0) {
                            behaveScroll.enabled = false
                            scrollTranslate.x = outputScreen.width
                            behaveScroll.enabled = true
                        }
                        scrollTranslate.x += xTranslateIncrement
                        //console.log(endOfText)

                    }

                }

                Component.onCompleted: {
                    scrollTimer.start()
                }
            }

            // TextInput{
            //     id: streamText

            //     visible: (streamingText) ? true : false //!streamMenuOpen

            //     text: streamString
            //     enabled: false //new
            //     color: "blue"
            //     font.pixelSize: Math.min(root.height, root.width) * 0.07
            //     horizontalAlignment: Qt.AlignLeft
            //     verticalAlignment: Qt.AlignVCenter

            //     anchors {
            //         fill: parent
            //         bottom: parent.bottom
            //         bottomMargin: parent.height * 0.05
            //     }
            // }



            ListView{
                id: listViewVariables

                visible: (varMenuOpen ? true : false)

                x: outputScreen.width * 0.01
                y: outputScreen.height * 0.03

                property int indexOfExpanded: -1

                width: outputScreen.width * 0.98
                height: outputScreen.height * 0.94
                spacing: outputScreen.height * 0.02

                model: ListModel {
                    id: myModel
                }

                Component.onCompleted: {
                    listViewVariables.updateList();
                }

                Connections{
                    target: UtilityCalculator
                    function onSignal_VariablesChanged() {
                        listViewVariables.updateList();
                    }
                }

                function updateList() {
                    myModel.clear();
                    myModel.append({"name": "Return"});
                    for (var key in root.variables) {
                        myModel.append({
                                           "name": key
                                       });
                    }
                    myModel.append({"name": "New Variable"});
                }

                delegate: CompBtnBreadcrumb{
                    id: listButtons

                    property bool isExpanded: index === listViewVariables.indexOfExpanded

                    visible: varMenuOpen ? true : false
                    property bool isStoredVar: (index !== 0 && index !== myModel.count - 1)
                    property string the_value: isStoredVar ? UtilityCalculator.getVariableValue(model.name) : "";
                    width: outputScreen.width * 0.98
                    height: outputScreen.height * 0.1 * (isExpanded ? 2.1 : 1.0)
                    text: {
                        if (isStoredVar) {
                            return model.name + " - " + the_value;
                        } else {
                            return model.name;
                        }
                    }
                    textObject {
                        verticalAlignment: listButtons.isExpanded ? Text.AlignTop : Text.AlignVCenter
                        anchors.verticalCenter: listButtons.isExpanded ? undefined : iconImage.verticalCenter
                    }

                    //root.currentMenu[index]
                    //color: "white"
                    font.pixelSize: Math.min(root.height, root.width) * 0.07
                    //font.pixelSize: Math.min(root.height, root.width) * 0.05

                    onClicked:{

                        listViewVariables.indexOfExpanded = -1

                        UtilityCalculator.varMenu(index)
                        varMenuOpen = false

                        if (index === myModel.count - 1) {
                            console.log("before focus")
                            inputText.forceActiveFocus() //opens keyboard automatically
                        }
                    }

                    onPressAndHold: {
                        if (isStoredVar) {
                            listViewVariables.indexOfExpanded = index
                        }
                    }

                    Row {
                        id: varHoldOptions

                        visible: isExpanded

                        spacing: useVarOption.width * 0.1

                        y: parent.height * 0.4

                        anchors {
                            horizontalCenter: parent.horizontalCenter
                        }

                        CompBtnBreadcrumb {
                            id: useVarOption

                            height: listButtons.height * 0.52
                            width: listButtons.width * 0.28

                            text: "Use Variable"
                            font.pixelSize: Math.min(root.height, root.width) * 0.07

                            onClicked:{

                                listViewVariables.indexOfExpanded = -1

                                console.log("use")
                                UtilityCalculator.varMenu(index)
                                varMenuOpen = false
                            }

                        }
                        CompBtnBreadcrumb {
                            id: changeValOption

                            height: useVarOption.height
                            width: useVarOption.width

                            text: "Change Value"
                            font.pixelSize: useVarOption.font.pixelSize

                            onClicked:{

                                listViewVariables.indexOfExpanded = -1

                                console.log("change")
                                UtilityCalculator.changeVariable(index)
                                varMenuOpen = false
                            }

                        }
                        CompBtnBreadcrumb {
                            id: deleteVarOption

                            height: useVarOption.height
                            width: useVarOption.width

                            text: "Delete Variable"
                            font.pixelSize: useVarOption.font.pixelSize

                            onClicked:{

                                listViewVariables.indexOfExpanded = -1

                                console.log("delete")
                                UtilityCalculator.deleteVariable(index)
                            }

                        }
                    }
                }
                ScrollBar.vertical: ScrollBar{
                    policy: ScrollBar.AsNeeded
                    width: 8
                    topPadding: 10
                    bottomPadding: 10
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
                columns: 7
                columnSpacing: root.width * 0.01
                rowSpacing: root.height * 0.01

                Repeater{
                    model: 35

                    CompBtnBreadcrumb{
                        id: keyButtons

                        visible: (varMenuOpen) ? false : true

                        width: root.width * 0.1 //root.width * 0.131
                        height: root.height * 0.148

                        text: root.currentMenu[index]
                        // color: "white"
                        font.pixelSize: keyFontSize
                        //font.pixelSize: Math.min(root.height, root.width) * 0.05
                        //anchors.centerIn: parent

                        onClicked:{
                            //actions[index]()
                            UtilityCalculator.main(index)
                        }
                    }
                }
            }
        }
    }

    Column {
        id: itemStreamMenu

        //height: root.height * 0.7
        //width: root.width * 0.2

        spacing: 70

        visible: varMenuOpen === false

        anchors {
            fill: parent
            topMargin: parent.height * 0.21
            rightMargin: parent.width * 0.01
            bottomMargin: parent.height * 0.013
            leftMargin: parent.width * 0.78
        }

        CompCombobox{
            id: comboBeaconID

            // MouseArea {
            //     anchors.fill: parent
            //     onClicked: {
            //         console.log("heifjaeofj")
            //     }
            // }

            height: itemStreamMenu.height * 0.08
            width: itemStreamMenu.width

            unselectedText: "Select Beacon ID"
            textRole: "Beacon_ID"
            model: TableModelAssetDashboardGridView

            valueFontSize: Math.min(root.height, root.width) * 0.04

            onCurrentIndexChanged: {
                console.log("Current Index Changed to: " + currentIndex)
            }
            onCurrentTextChanged: {
                console.log("Current text changed to: " + currentText)
            }

            delegate: ItemDelegate{
                width: comboBeaconID.width
                height: comboBeaconID.optionItemHeight

                background: Rectangle {
                    width: parent.width
                    height: parent.height
                    color: "#9287ED"
                    anchors.bottom: parent.bottom
                }

                contentItem: CompLabel{
                    text: model.Beacon_ID
                    verticalAlignment: Text.AlignVCenter
                    elide: Text.ElideRight
                    color: comboBeaconID.currentTextColor
                    font.pixelSize: Math.min(root.height, root.width) * 0.04
                    MouseArea{
                        anchors.fill: parent

                        onClicked: {
                            console.log("clicked")
                            comboBeaconID.currentIndex = index
                            comboBeaconID.popup.close()
                            SystemController.targetBeaconID = model.Beacon_ID
                        }
                    }
                }

                highlighted: comboBeaconID.highlightedIndex === index
            }

        }

        ListView {
            id: listviewParams

            visible: comboBeaconID.currentIndex !== -1
            spacing: 8

            height: itemStreamMenu.height * 0.73
            width: itemStreamMenu.width

            // Rectangle {
            //     visible: varMenuOpen === false
            //     anchors.fill: listviewParams
            //     color: "green"
            //     radius: 20
            //     opacity: 0.3
            // }

            // Rectangle {
            //     anchors.fill: parent
            //     color: "yellow"
            // }

            model: TableModelHealthDashboard
            delegate: CompBtnBreadcrumb {
                id: listViewParamsDelegate
                height: root.height * 0.059
                width: listviewParams.width

                Row {
                    property bool isSelected: model.is_selected

                    CompLabel {
                        text: "  " + model.ParamName
                        elide: Text.ElideRight
                        width: root.width * 0.12
                        height: listViewParamsDelegate.height
                        font.pixelSize: Math.min(root.height, root.width) * 0.02
                        verticalAlignment: Text.AlignVCenter
                    }

                    CompLabel{
                        text: "     " + model.value + " " + model.unit
                        width: root.width * 0.08
                        height: listViewParamsDelegate.height
                        font.pixelSize: Math.min(root.height, root.width) * 0.02
                        horizontalAlignment: Text.AlignRight
                        verticalAlignment: Text.AlignVCenter

                    }
                }

                MouseArea{
                    anchors.fill: parent
                    onClicked: {

                        var isSelectedNow = model.is_selected
                        //console.log("Is Selected Now: " + isSelectedNow)
                        isSelectedNow = !isSelectedNow
                        console.log("...Is Selected Now: " + isSelectedNow)
                        UtilityCalculator.setParamNameTracked(model.ParamName, isSelectedNow);
                        listviewParams.model.setData(listviewParams.model.indexOfData(Constants.DataRole_ParamName,model.ParamName), isSelectedNow, Constants.DataRole_IsSelected)
                        console.log("isSelected: " + model.is_selected)
                    }

                    onPressAndHold: {
                        console.log("press and hold")
                        var newParamName = (model.ParamName).replace(/\s/g, "")
                        console.log(newParamName)
                        inputText.insert(inputText.cursorPosition, "@" + newParamName)
                        // inputText.insert(inputText.cursorPosition, "@[" + newParamName + "]")

                        newParamName = ""
                    }
                }

                Rectangle{
                    anchors.fill: parent

                    color: "transparent"//index % 2 ? "#80ff00ff" : "#8000ff00"
                    border.color: model.is_selected ? "blue" : "white"
                    radius: 20
                }
            }


        }
    }


    // Row {
    //     id: rowOptions

    //     //visible: isExpanded

    //     height: itemStreamMenu.height * 0.1
    //     width: (streamOption.width * 2) + rowOptions.spacing

    //     spacing: streamOption.width * 1.2

    //     anchors {
    //         bottom: itemStreamMenu.bottom
    //         bottomMargin: 60
    //         horizontalCenter: parent.horizontalCenter
    //     }

    //     // CompBtnBreadcrumb {
    //     //     id: streamOption

    //     //     height: rowOptions.height
    //     //     width: itemStreamMenu.width * 0.28

    //     //     text: "Stream"
    //     //     font.pixelSize: Math.min(root.height, root.width) * 0.07

    //     //     onClicked:{
    //     //         streamMenuOpen = false
    //     //         streamingText = true
    //     //     }

    //     // }
    //     // CompBtnBreadcrumb {
    //     //     id: cancelOption

    //     //     height: streamOption.height
    //     //     width: streamOption.width

    //     //     text: "Cancel"
    //     //     font.pixelSize: streamOption.font.pixelSize

    //     //     onClicked:{
    //     //         streamMenuOpen = false
    //     //         streamingText = false
    //     //     }

    //     // }
    // }
}

