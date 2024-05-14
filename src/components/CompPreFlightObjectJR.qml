import QtQuick 2.15
import QtQuick.Controls 2.15

Comp__BASE {
    id: pfObject
    height: 26
    width: 292

    property alias textInfoText: pfInfoText.text
    property alias textData: pfData.text
    property alias boolToggle: pfToggle

    CompTextField {
        id: pfInfoText
        height: 25
        width: 194
        edtFontPixelSize: 16
        anchors {
            top: parent.top
            bottom: parent.bottom
            left: parent.left
        }
    }
    CompLabel{
        id: pfData
        height: 25
        width: 78
        anchors {
            top: parent.top
            bottom: parent.bottom
            left: pfInfoText.right
        }
    }
    CheckBox{
        id: pfToggle
        height: 15
        width: 15
        checked: false
        anchors {
            right: parent.right
            rightMargin: 10
        }
    }
}
