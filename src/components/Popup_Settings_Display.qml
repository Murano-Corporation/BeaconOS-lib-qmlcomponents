import QtQuick 2.0
import QtQuick.Controls 2.15
import QtQml.Models 2.15
import CONSTANTS 1.0
Popup_Settings__BASE {
    id: popup_Settings_Display

    property bool isDelta: base.isDelta
    screenName: "Display"
    content: Column{
        id: colContents

        CompLabelledComboBox{
            id: comboRotation
            text: "Rotation"

            height: isDelta ? 60 : 100
            width: popup_Settings_Display.controlWidth
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

            onCurrentIndexChanged: {
                console.log("Combo's current index is now: " + comboRotation.currentIndex)
                console.log("---Current Text: " + comboRotation.currentText)


                var vVal = comboRotation.comboItem.valueAt(comboRotation.currentIndex)
                console.log("---Current Value: " + vVal)
                DisplayController.setScreenRotation(vVal)
            }
        }
    }



}
