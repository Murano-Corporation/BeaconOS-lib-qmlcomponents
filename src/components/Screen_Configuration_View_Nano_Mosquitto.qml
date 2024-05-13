import QtQuick 2.15
import QtQuick.Controls 2.15
import Qt.labs.qmlmodels 1.0
import CONSTANTS 1.0

Item{
    id: screen_Configuration_View_Nano_Mosquitto


    Component.onCompleted: {
        Nano.mosquitto_ReadConfigFile()
    }


    function restoreDefaults(){
        Nano.mosquitto_ReadConfigFile()
    }

    ListView{
        id: colRoot



        clip: true
        boundsBehavior: Flickable.StopAtBounds
        spacing: 30

        anchors{
            left: parent.left
            right: parent.right
            top: parent.top
            bottom: rowControls.top
        }

        model: TableModelMosquittoConfig

        delegate: delChooser
        DelegateChooser{
            id: delChooser
            role: 'data_value_type'


            DelegateChoice{
                roleValue: 'QString'


                CompCheckableLabelledTextEdit{

                    width: colRoot.width

                    propertyName: model.display
                    text: model.value
                    checked: model.is_enabled

                    onTextChanged: {
                        colRoot.model.setData(colRoot.model.index(index,0), text, Constants.DataRole_Value);
                    }

                    onCheckedChanged: {
                        colRoot.model.setData(colRoot.model.index(index,0), checked, Constants.DataRole_Enabled);
                    }

                }
            }

            DelegateChoice{
                roleValue: "bool"

                Row{
                    height: 60

                    width: colRoot.width
                    spacing: 60

                    CheckBox{
                        height: 60
                        text: "Enabled?"
                        checked: model.is_enabled

                        anchors.verticalCenter: parent.verticalCenter

                        onCheckedChanged: {
                            colRoot.model.setData(colRoot.model.index(index,0), checked, Constants.DataRole_Enabled);
                        }

                    }

                    CompToggle{

                        enabled: model.is_enabled

                        height: parent.height
                        lblWidth: 250
                        width: 450
                        text: model.display
                        isOn: model.value
                        anchors.verticalCenter: parent.verticalCenter

                        onIsOnChanged: {
                            colRoot.model.setData(colRoot.model.index(index,0), isOn, Constants.DataRole_Value);
                        }

                    }
                }


            }

            DelegateChoice{
                roleValue: "int"

                CompCheckableLabelledTextEdit{

                    property var myModel: model
                    width: colRoot.width

                    propertyName: model.display
                    text: model.value
                    checked: model.is_enabled

                }
            }
        }
    }

    Row{
        id: rowControls

        anchors{
            bottom: parent.bottom
            left: parent.left
            right: parent.right
        }

        height: 60
        width: parent.width
        spacing: 30

        Button{
            id: btnRead

            text: "Restore Defaults"

            onClicked: Nano.mosquitto_ReadConfigFile()
        }

        Button{
            id: btnWrite

            text: "Save Values"

            onClicked: {

            }
        }

    }
}
