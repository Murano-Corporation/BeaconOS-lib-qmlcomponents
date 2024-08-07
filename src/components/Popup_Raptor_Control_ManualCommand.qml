import QtQuick 2.15
import QtQuick.Controls 2.15

Comp__BASE_Popup{
    id: popupRaptorControlManualCommand

    compBaseRadius: 20

    property int editHeight: 60
    property var commandStructSelected: comboCommandId.displayText === "" ? undefined : DroneController.getCommandDefinition(comboCommandId.displayText)
    property string commandDescription: commandStructSelected === undefined ? "" : commandStructSelected.description
    property int commandID: commandStructSelected === undefined ? "" : commandStructSelected.cmdId
    property var commandPropertyList: commandStructSelected === undefined ? undefined : commandStructSelected.listParamInfo
    property var listUserValues: [0,0,0,0,0,0,0]
    property bool awaitingAck: false

    popupName: "Raptor.Control: Manual Command"
    height: 800
    width: 700

    Connections{
        target: DroneController

        function onSignal_CmdAckReceived(cmd_id, i_result){
            awaitingAck = false

            tooltipAck.cmd = cmd_id
            tooltipAck.result = i_result
            tooltipAck.open(5000)
        }
    }

    function onSubmit(){
        var cmd = popupRaptorControlManualCommand.commandID
        var conf = edtConfirmation.value
        var p0 = popupRaptorControlManualCommand.listUserValues[0]
        var p1 = popupRaptorControlManualCommand.listUserValues[1]
        var p2 = popupRaptorControlManualCommand.listUserValues[2]
        var p3 = popupRaptorControlManualCommand.listUserValues[3]
        var p4 = popupRaptorControlManualCommand.listUserValues[4]
        var p5 = popupRaptorControlManualCommand.listUserValues[5]
        var p6 = popupRaptorControlManualCommand.listUserValues[6]
        var p7 = popupRaptorControlManualCommand.listUserValues[7]

        DroneController.sendCommand_Execute(cmd, conf, p0, p1, p2, p3, p4, p5, p6, p7);
    }

    function onReset(){

        edtCmdId.value = "0"
        edtConfirmation.value = "0"

        popupRaptorControlManualCommand.listUserValues = [0,0,0,0,0,0,0]
    }

    ToolTip{
        id: tooltipAck

        property string cmd: ""
        property string result: ""
        property string message: "COMMAND ACK RECVD\n\nCMD: " + cmd + "\nResult: " + result

        text: message
        timeout: 5000
    }

    CompPopupBG{
        id: bg
        FocusScope{
            anchors.fill: parent

            onFocusChanged: {
                InputHandler.slot_OnPopupFocusChanged(popupName, focus)

            }

            Column {
                anchors.fill: parent
                anchors.margins: bg.radiusBG

                spacing: 10

                CompLabel {
                    id: lblManualCommands

                    text: "Manual Command"
                }

                CompCombobox{
                    id: comboCommandId
                    width: parent.width

                    model: DroneController.listCommandNames
                    textRole: undefined

                    delegate: ItemDelegate{
                        width: comboCommandId.width
                        height: comboCommandId.optionItemHeight

                        background: Rectangle {
                            width: parent.width
                            height: parent.height
                            color: "#9287ED"
                            anchors.bottom: parent.bottom
                        }

                        contentItem: CompLabel{
                            text: modelData
                            verticalAlignment: Text.AlignVCenter
                            elide: Text.ElideRight
                            color: comboCommandId.currentTextColor
                            //font.pixelSize: 40
                            MouseArea{
                                anchors.fill: parent

                                onClicked: {
                                    comboCommandId.currentIndex = index
                                    comboCommandId.displayText = parent.text
                                    comboCommandId.popup.close()
                                }
                            }
                        }

                        highlighted: comboCommandId.highlightedIndex === index
                    }

                }

                ScrollView{
                    height: 100
                    width: parent.width
                    clip: true
                    CompLabel{
                        id: lblDescription

                        width: comboCommandId.width
                        wrapMode: Text.WordWrap

                        text: "DESCRIPTION:\n" + popupRaptorControlManualCommand.commandDescription
                    }
                }

                CompLabelledTextEdit {
                    id: edtConfirmation

                    text: "CONFIRMATION:"
                    textEdit.inputMethodHints: Qt.ImhDigitsOnly
                    value: '0'
                    isReadonly: false
                    width: parent.width
                    height: popupRaptorControlManualCommand.editHeight
                }

                Column{
                    width: parent.width

                    Repeater{
                        model: commandPropertyList

                        delegate: CompLabelledTextEdit {
                            id: edtParam0
                            property var propertyInfo: popupRaptorControlManualCommand.commandStructSelected.getParamInfo(index)

                            enabled: propertyInfo.label !== "Empty" && propertyInfo.label !== "Reserved"

                            text:  propertyInfo.label + ":"
                            textEdit.inputMethodHints: Qt.ImhDigitsOnly
                            value: '0'
                            isReadonly: false
                            width: parent.width
                            height: popupRaptorControlManualCommand.editHeight

                            onValueChanged: {
                                popupRaptorControlManualCommand.listUserValues[index] = value
                            }

                            onPressedLabel: {
                                var sRet = ""

                                sRet += "DESCRIPTION: " + propertyInfo.description
                                sRet += "\n\n"

                                sRet += "VALUES: " + propertyInfo.values
                                sRet += "\n\n"

                                sRet += "UNITS: " + propertyInfo.units
                                sRet += "\n"

                                tooltip.show(sRet, 3000)
                            }
                            ToolTip{
                                id: tooltip

                            }

                        }
                    }

                }

                CompBtnBreadcrumb{
                    text: "RESET"
                    width: parent.width
                    height: 90
                    onClicked: popupRaptorControlManualCommand.onReset()
                }

                CompBtnBreadcrumb{
                    text: "EXECUTE"

                    enabled: !popupRaptorControlManualCommand.awaitingAck

                    width: parent.width
                    height: 90
                    onClicked: popupRaptorControlManualCommand.onSubmit()
                }
            }

        }
    }
}
