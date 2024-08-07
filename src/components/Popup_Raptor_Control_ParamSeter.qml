import QtQuick 2.15
import QtQuick.Controls 2.15

Comp__BASE_Popup{
    id: popupRaptorControlParamSeter

    compBaseRadius: 20

    property int editHeight: 60
    property string paramName: edtParamId.displayText
    property var structMavlinkParamSelected: {
        if(edtParamId.currentIndex !== -1 && paramName !== "")
        {
            return DroneController.getParameterDefinition(paramName)
        }
        else{
            return undefined
        }
    }

    property string paramDescription: structMavlinkParamSelected === undefined ? "" : structMavlinkParamSelected.description
    property string paramNotes: structMavlinkParamSelected === undefined ? "" : structMavlinkParamSelected.notes
    property string paramValues: structMavlinkParamSelected === undefined ? "" : structMavlinkParamSelected.valuesString
    property string paramBitMask: structMavlinkParamSelected === undefined ? "" : structMavlinkParamSelected.bitmaskValuesString
    property string paramRange: structMavlinkParamSelected === undefined ? "" : structMavlinkParamSelected.rangeString
    property string paramUnits: structMavlinkParamSelected === undefined ? "" : structMavlinkParamSelected.units
    property string paramIncrements: structMavlinkParamSelected === undefined ? "" : structMavlinkParamSelected.incrementString
    popupName: "Raptor.Control: Parameter Set"
    height: 800
    width: 700

    function onSubmit(){
        var param = edtParamId.displayText
        var param_value = edtParamValue.value

        DroneController.sendCommand_SetParam(param, param_value);
    }

    function onReset(){

        edtParamId.displayText = ''
        edtParamValue.value = '0'
    }

    CompPopupBG {
        id: bgPopupRaptorDroneSetParams

        FocusScope{
            anchors.fill: parent

            onFocusChanged: {
                InputHandler.slot_OnPopupFocusChanged(popupName, focus)

            }

            Column {
                spacing: 10
                anchors{
                    fill: parent
                    margins: bgPopupRaptorDroneSetParams.radiusBG
                }

                CompLabel{
                    id: lblSetParams

                    text: "Set Drone Parameters"
                }

                CompCombobox {
                    id: edtParamId

                    textRole: undefined

                    model: DroneController.listParameterNames
                    width: parent.width
                    delegate: ItemDelegate{
                        width: edtParamId.width
                        height: edtParamId.optionItemHeight

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
                            color: edtParamId.currentTextColor
                            //font.pixelSize: 40
                            MouseArea{
                                anchors.fill: parent

                                onClicked: {
                                    edtParamId.currentIndex = index
                                    edtParamId.displayText = parent.text
                                    edtParamId.popup.close()
                                }
                            }
                        }

                        highlighted: edtParamId.highlightedIndex === index
                    }
                }



                ScrollView{
                    id: scrollViewParamMetaData
                    width: parent.width
                    height: 300
                    clip: true
                    //boundsBehavior: Flickable.StopAtBounds


                    Column{
                        width: parent.width
                        spacing: 40
                        CompLabel{

                            visible: edtParamId.currentIndex !== -1 && popupRaptorControlParamSeter.paramDescription !== ""

                            width: parent.width
                            wrapMode: Text.WordWrap

                            text: popupRaptorControlParamSeter.paramDescription


                        }

                        CompLabel{

                            visible: edtParamId.currentIndex !== -1 && popupRaptorControlParamSeter.paramNotes !== ""

                            width: parent.width
                            wrapMode: Text.WordWrap

                            text: "NOTES:    " + popupRaptorControlParamSeter.paramNotes

                            color: "#80000000"
                        }

                        CompLabel{

                            visible: edtParamId.currentIndex !== -1 && popupRaptorControlParamSeter.paramRange !== ""

                            width: parent.width
                            wrapMode: Text.WordWrap

                            text: "RANGE:     " + popupRaptorControlParamSeter.paramRange
                        }

                        CompLabel{
                            visible: edtParamId.currentIndex !== -1 && popupRaptorControlParamSeter.paramIncrements !== ""

                            width: parent.width
                            wrapMode: Text.WordWrap

                            text: "INCREMENT:     " + popupRaptorControlParamSeter.paramIncrements
                        }

                        CompLabel{

                            visible: edtParamId.currentIndex !== -1 && popupRaptorControlParamSeter.paramUnits !== ""

                            width: parent.width
                            wrapMode: Text.WordWrap

                            text: "UNITS:     " + popupRaptorControlParamSeter.paramUnits
                        }

                        CompLabel{

                            visible: edtParamId.currentIndex !== -1 && popupRaptorControlParamSeter.paramBitMask !== ""

                            width: parent.width
                            wrapMode: Text.WordWrap

                            text: "BITMASK:     \n" + popupRaptorControlParamSeter.paramBitMask
                        }

                        CompLabel{

                            visible: edtParamId.currentIndex !== -1 && popupRaptorControlParamSeter.paramValues !== ""

                            width: parent.width
                            wrapMode: Text.WordWrap

                            text: "VALUES:\n" + popupRaptorControlParamSeter.paramValues
                        }

                    }

                }


                CompLabelledTextEdit {
                    id: edtParamValue

                    text: "PARAM VALUE:"
                    value: '0'
                    textEdit.inputMethodHints: Qt.ImhDigitsOnly
                    isReadonly: false
                    width: parent.width
                    height: popupRaptorControlParamSeter.editHeight
                }

                CompBtnBreadcrumb{
                    text: "RESET"
                    width: parent.width
                    height: 90
                    onClicked: popupRaptorControlParamSeter.onReset()
                }

                CompBtnBreadcrumb{
                    text: "EXECUTE"
                    width: parent.width
                    height: 90
                    onClicked: popupRaptorControlParamSeter.onSubmit()
                }

            }

        }
    }
}
