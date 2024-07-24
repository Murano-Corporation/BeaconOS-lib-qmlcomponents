import QtQuick 2.15

Comp__BASE_Popup{
    id: popupRaptorControlParameterView
    popupName: "Raptor.Control: Parameter View"
    height: 900
    width: 600

    CompPopupBG{
        id: bg

        Column{
            id: col
            anchors{
                fill:parent
                margins: bg.radiusBG
            }

            spacing: 20

            CompLabel{
                id: lblTitle

                text: "Drone Parameters"
            }

            CompCustomisableTextField{
                id: edtSearch
                isPopupComponent: true
                width: parent.width
                height: 41
                onTextChanged: {
                    TableModelRaptorDroneParameters_All.setSearchString(text)
                }
            }


            ListView{
                id: listViewParameters

                property CompLabel indexSelected: lblNull
                CompLabel{
                    id: lblNull
                    visible: false
                }
                height: (bg.height - (col.anchors.margins * 2)) - (lblTitle.height + parent.spacing + edtSearch.height + parent.spacing + rowControls.height + parent.spacing)
                width: parent.width

                model: TableModelRaptorDroneParameters_All
                spacing: 64

                delegate: CompLabel{
                    property bool isSelected: this === listViewParameters.indexSelected
                    property string paramId: model.param_id
                    property string paramValue: model.param_value
                    property string paramType: model.param_type

                    width: listViewParameters.width

                    text: "[" + model.param_index + "] - " + paramId + ": (" + paramType + ") " + paramValue

                    Rectangle{
                        visible: parent.isSelected
                        z: -1
                        anchors.fill: parent
                        color: "#80FFFF00"

                    }

                    MouseArea{
                        anchors.fill: parent

                        onClicked: {
                            listViewParameters.indexSelected = parent
                        }
                    }
                }
            }

            Row {
                id: rowControls

                height: 90
                width: parent.width

                CompBtnBreadcrumb{
                    height: parent.height

                    text: "Update"

                    onClicked: DroneController.sendCommand("list_all_params",{})
                }

                CompTextField{
                    id: edtSetValue
                    isPopupComponent: true
                    enabled: listViewParameters.indexSelected !== lblNull
                    height: parent.height
                    lblText: ""
                    lblWidth: 0
                    textEditWidth:  300
                    width: 300
                    placeholderText: listViewParameters.indexSelected === lblNull ? "Select Parameter Above" : listViewParameters.indexSelected.paramValue
                    text: listViewParameters.indexSelected === lblNull ? "" : listViewParameters.indexSelected.paramValue
                }

                CompBtnBreadcrumb{
                    id: btnSet


                    enabled: (listViewParameters.indexSelected !== lblNull && edtSetValue.text.length > 0)
                    height: parent.height

                    text: "Apply"

                    onClicked: {
                        DroneController.sendCommand_SetParam(listViewParameters.indexSelected.paramId, edtSetValue.text)
                    }
                }
            }
        }
    }
}
