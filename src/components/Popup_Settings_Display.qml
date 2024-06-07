import QtQuick 2.0
import QtQuick.Controls 2.15
import QtQml.Models 2.15
import CONSTANTS 1.0

Popup_Settings_View__BASE {
    id: popup_Settings_Display

    viewName: "Display Settings"
    Column {
        id: colContents

        anchors{
            fill: contents
            margins: contentsBgRadius
        }

        Row {
            width: parent.width

            CompLabelledComboBox{
                id: comboRotation
                text: "Rotation (Visual)"

                height: isDelta ? 60 : 100
                width: parent.width * 0.8
                textFontPixelSize: isDelta ? 28 : 40
                valueComboBox: isDelta ? 24 : 40
                comboItem.valueRole: "value"
                comboItem.optionsHeight: isDelta ? 50 : 100

                comboModel: ListModel{
                    ListElement{
                        key: "Normal"
                        value: Constants.EOmegaRotationValue_Normal
                    }

                    ListElement{
                        key: "Right"
                        value: Constants.EOmegaRotationValue_Right
                    }

                    ListElement{
                        key: "Inverted"
                        value: Constants.EOmegaRotationValue_Inverted
                    }

                    ListElement{
                        key: "Left"
                        value: Constants.EOmegaRotationValue_Left
                    }
                }

                //onCurrentIndexChanged: {
                //    console.log("Combo's current index is now: " + comboRotation.currentIndex)
                //    console.log("---Current Text: " + comboRotation.currentText)


                //    var vVal = comboRotation.comboItem.valueAt(comboRotation.currentIndex)
                //    console.log("---Current Value: " + vVal)
                //    DisplayController.setScreenRotation(vVal)
                //}
            }

            RoundButton{
                height: comboRotation.height

                text: "Apply"

                onClicked:{
                    var vVal = comboRotation.comboItem.valueAt(comboRotation.currentIndex)
                    DisplayController.setScreenRotation(vVal)
                }
            }
        }


        Row {

            width: parent.width

            CompLabelledComboBox{
                id: comboRotation_Calibration

                text: "Rotation (Touch)"

                height: isDelta ? 60 : 100
                width: parent.width * 0.75
                textFontPixelSize: isDelta ? 28 : 40
                valueComboBox: isDelta ? 24 : 40
                comboItem.valueRole: "value"
                comboItem.optionsHeight: isDelta ? 50 : 100

                comboModel: ListModel{
                    ListElement{
                        key: "Normal"
                        value: Constants.EOmegaRotationValue_Normal
                    }

                    ListElement{
                        key: "Right"
                        value: Constants.EOmegaRotationValue_Right
                    }

                    ListElement{
                        key: "Inverted"
                        value: Constants.EOmegaRotationValue_Inverted
                    }

                    ListElement{
                        key: "Left"
                        value: Constants.EOmegaRotationValue_Left
                    }
                }


            }


            RoundButton{
                height: comboRotation_Calibration.height

                text: "Apply"

                onClicked:{
                    var vVal = comboRotation_Calibration.comboItem.valueAt(comboRotation_Calibration.currentIndex)
                    DisplayController.setTouchRotation(vVal)
                }
            }
        }


        }



}
