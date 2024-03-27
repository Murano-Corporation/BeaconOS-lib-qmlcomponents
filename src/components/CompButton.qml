import QtQuick 2.12
import QtQuick.Controls 2.12

Button {
    id: compButton
    
    property alias textObject: lblText
    property alias backgroundColor: bgRect.color
    property alias fontColor: lblText.color
    //property alias font: lblText.font
    //property string text: ""
    property real borderWidthHorizontal: 20
    background: Rectangle {
        id: bgRect
        color: "Grey"

        anchors.fill: parent
    }
    property bool consoleOutputsEnabled: false
    property bool showIcon: (iconSource.length > 0)
    property string iconSource: ""
    onIconSourceChanged: {
        showIcon = (iconSource.length > 0)
    }
    property int iconHeight: 24
    property int iconWidth: 24
    property color iconColor:"#9287ED"


    Item{
        id: pri

        property real iconWidth: parent.showIcon ? parent.iconWidth : 0


        property real lblWidth: parent.text.length > 0 ? lblText.implicitWidth : 0

        property real lblSpacing: (parent.text.length > 0 && parent.showIcon) ? lblText.anchors.leftMargin : 0


        property real hBorderSpacing: parent.borderWidthHorizontal * 2

        property real widthCalcd: (iconWidth + lblWidth + lblSpacing + hBorderSpacing)

        //onWidthCalcdChanged: {
        //    if(!compButton.consoleOutputsEnabled)
        //        return
        //
        //    console.log("Icon Width now: " + iconWidth)
        //    console.log("Lbl Width now: " + lblWidth)
        //    console.log("HBorderSpacing now: " + hBorderSpacing)
        //    console.log("Lbl Spacing now: " + lblSpacing)
        //    console.log("Width calcd: " + widthCalcd)
        //}

    }


    width: pri.widthCalcd

    font{
        pixelSize: 20
        family: "Lato"
        weight: Font.Normal
    }

    //Rectangle{
    //    anchors.fill: parent
    //
    //    color: "Black"
    //}

    contentItem: Item{}

    Item {
        id: contentItem

        //Rectangle{
        //    anchors.fill: parent
        //
        //    color: "Green"
        //}

        anchors{
            left: parent.left
            leftMargin: compButton.borderWidthHorizontal
            right: parent.right
            rightMargin: compButton.borderWidthHorizontal
            top: parent.top
            bottom: parent.bottom
        }

        CompImageIcon {
            id: iconIamge

            anchors{
                left: parent.left
                top: parent.top
                bottom: parent.bottom
            }

            //Rectangle{
            //    anchors.fill: parent
            //
            //    color: "Red"
            //}

            image.source: compButton.iconSource
            color: compButton.iconColor
            width: compButton.iconWidth


        }

        CompLabel{
            id: lblText

            anchors{
                left: (compButton.showIcon  ? iconIamge.right : parent.left)
                leftMargin: (compButton.showIcon ? 8 : 0)
                right: parent.right
                verticalCenter: iconIamge.verticalCenter
            }

            text: compButton.text
            horizontalAlignment: Text.AlignHCenter


            font.pixelSize: compButton.font.pixelSize
            font.family: compButton.font.family
            font.weight: compButton.font.weight


            //Rectangle{
            //    anchors.fill: parent
            //
            //    color: "#800000ff"
            //}
        }

    }

    //MouseArea{
    //    anchors.fill: parent
    //
    //    onClicked: {
    //        parent.clicked()
    //    }
    //
    //}
    
}



/*##^##
Designer {
    D{i:0;formeditorZoom:1.25}
}
##^##*/
