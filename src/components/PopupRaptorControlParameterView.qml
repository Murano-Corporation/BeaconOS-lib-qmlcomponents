import QtQuick 2.15

Comp__BASE_Popup{
    id: popupRaptorControlParameterView
    popupName: "Raptor.Control: Parameter View"
    height: 700
    width: 600
    compBaseRadius: 20

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

                height: 80
                width: parent.width

                CompBtnBreadcrumb{
                    height: edtSetValue.height * 0.9

                    anchors.verticalCenter: parent.verticalCenter

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

                    anchors.verticalCenter: parent.verticalCenter


                    enabled: (listViewParameters.indexSelected !== lblNull && edtSetValue.text.length > 0)
                    height: edtSetValue.height * 0.9

                    text: "Apply"

                    onClicked: {
                        DroneController.sendCommand_SetParam(listViewParameters.indexSelected.paramId, edtSetValue.text)
                    }
                }

                // CompRaptorNavMenuItem{
                //     id: resetBtn

                //     imgIconSrc: "file:///usr/share/BeaconOS-lib-images/images/RefreshCircle.svg"
                //     width: parent.width
                //     height: 90
                //     onClicked: popupRaptorControlParamSeter.onReset()
                // }

                // CompRaptorNavMenuItem{
                //     id: executeBtn

                //     imgIconSrc: "file:///usr/share/BeaconOS-lib-images/images/PlayCircle.svg"
                //     width: parent.width
                //     height: 90
                //     onClicked: DroneController.sendCommand_SetParam(listViewParameters.indexSelected.paramId, edtSetValue.text)
                // }
            }
        }
    }
}
