import QtQuick 2.12
import QtQuick.Controls 2.12
import QtGraphicalEffects 1.0

Item{
    id: compNsnTableItem


    property string keyName: "Key Name"
    property string value: "My Value"
    property real keyWidth: 200
    property real radius: 10
    property real listLongestKeyWidth: 200

    onListLongestKeyWidthChanged: {
        lblName.updateWidth()
    }

    signal keyWidthUpdated(real newWidth)

    Rectangle{
        id: rectBG_Item

        anchors{
            fill: parent
        }

        color: "#4C5474"
        visible: false
        radius: compNsnTableItem.radius
    }

    DropShadow{
        id: efxDropShadowItem

        anchors.fill: rectBG_Item

        source: rectBG_Item
        color: "#80000000"
        samples: 17
        radius: 8

    }

    CompLabel{
        id: lblName

        anchors{
            top: parent.top
            left: parent.left
            bottom: parent.bottom
        }

        width: compNsnTableItem.keyWidth
        leftPadding: 20
        rightPadding: 20
        text: compNsnTableItem.keyName
        onTextChanged: {
            updateWidth()
        }

        verticalAlignment: Text.AlignVCenter
        font{
            pixelSize: 20
        }
        color: "white"

        FontMetrics{
            id: fontMx

            font{
                pixelSize: lblName.font.pixelSize
                family: lblName.font.family
                weight: lblName.font.weight
            }
        }

        function updateWidth(){
            var textRect = fontMx.boundingRect(lblName.text)
            var idealWidth = lblName.leftPadding + lblName.rightPadding + textRect.width

            if(idealWidth > compNsnTableItem.listLongestKeyWidth)
            {
                compNsnTableItem.keyWidthUpdated(idealWidth)
            } else {
                lblName.width = compNsnTableItem.listLongestKeyWidth
            }
        }
    }


    CompLabel{
        id: lblValue

        anchors{
            top: parent.top
            left: lblName.right
            bottom: parent.bottom
            right: parent.right
        }

        elide: Text.ElideRight

        text: compNsnTableItem.value
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
        leftPadding: 20


        font{
            pixelSize: 20
            weight: Font.Light
        }
        color: "white"
    }

}

/*##^##
Designer {
    D{i:0;autoSize:true;formeditorZoom:0.9;height:64;width:600}
}
##^##*/
