import QtQuick 2.12
import QtQuick.Controls 2.12

ComboBox {
    id: comboFilters

    property alias fontPixelSize: lblContent.font.pixelSize
    property color bgBorderColor: "#4DE9E9E9"
    property alias currentTextColor: lblContent.color
    property string unselectedText: qsTr("Select")

    textRole: "key"

    height: 41
    width: 183

    displayText: currentIndex === -1 ? unselectedText : textAt(currentIndex)


    background: Rectangle{
        id: bgRect
        anchors.fill: parent    
        radius: height * 0.5
        color: "transparent"

        border{
            color: comboFilters.bgBorderColor
        }
    }



    contentItem: CompLabel {
        id: lblContent
        color: "#80FFFFFF"
        text: comboFilters.displayText
        anchors.fill: parent
        anchors.rightMargin: 40
        anchors.leftMargin: 20
        verticalAlignment: "AlignVCenter"
        elide: Label.ElideRight
        font{
            pixelSize: 20
        }
    }

    delegate: ItemDelegate{
        width: comboFilters.width

        contentItem: CompLabel{
            text: model.key
            verticalAlignment: Text.AlignVCenter
            elide: Text.ElideRight
            color: "#000000"

            MouseArea{
                anchors.fill: parent

                onClicked: {
                    comboFilters.currentIndex = index
                    comboFilters.popup.close()
                }
            }
        }

        highlighted: comboFilters.highlightedIndex === index
    }
}

/*##^##
Designer {
    D{i:0;formeditorColor:"#4c4e50"}
}
##^##*/
