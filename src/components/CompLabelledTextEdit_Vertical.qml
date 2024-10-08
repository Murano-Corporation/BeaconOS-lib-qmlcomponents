import QtQuick 2.12

Column {
    id: compLabelledTextEdit_Vertical

    property alias headerText: lblHeader.text
    property alias valueText: lblText.text
    property alias headerObject: lblHeader
    property alias valueObject: lblText

    CompLabel {
        id: lblHeader

        font {
            pixelSize: 12
            capitalization: Font.AllUppercase
        }

        color: "#80000000"
    }

    CompLabel {
        id: lblText

        font {
            pixelSize: 18
        }
        color: "#000000"
    }
}
